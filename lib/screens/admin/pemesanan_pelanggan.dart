import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/menu_model.dart';
import '../../models/order_model.dart';
import '../../services/menu_service.dart';
import '../../services/order_service.dart';
import '../../widgets/menu_image.dart';

class AdminPemesananPelangganScreen extends StatefulWidget {
  const AdminPemesananPelangganScreen({super.key});

  @override
  State<AdminPemesananPelangganScreen> createState() => _AdminPemesananPelangganScreenState();
}

class _AdminPemesananPelangganScreenState extends State<AdminPemesananPelangganScreen> {
  static const int _totalTables = 6;

  final MenuService _menuService = MenuService();
  final OrderService _orderService = OrderService();
  final TextEditingController _nameController = TextEditingController();
  List<MenuData> _menuItems = [];
  bool _isLoading = true;
  String currentActiveMenu = 'Pemesanan Pelanggan';

  Map<String, String> _occupiedTables = {};
  String? _selectedTable;
  StreamSubscription<Map<String, String>>? _occupiedSub;

  int get totalCartItems => _menuItems.fold(0, (sum, item) => sum + item.quantity);

  List<MenuData> get _cartItems => _menuItems.where((item) => item.quantity > 0).toList();

  int get _totalAmount => _cartItems.fold(0, (sum, item) => sum + (item.priceValue * item.quantity));

  @override
  void initState() {
    super.initState();
    _menuService.getActiveMenuStream().listen(
      (items) {
        if (mounted) {
          setState(() {
            _menuItems = items;
            _isLoading = false;
          });
        }
      },
      onError: (_) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      },
      cancelOnError: true,
    );

    _occupiedSub = _orderService.getOccupiedTablesStream().listen((occupied) {
      if (mounted) {
        setState(() {
          _occupiedTables = occupied;
          if (_selectedTable != null && occupied.containsKey(_selectedTable)) {
            _selectedTable = null;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _occupiedSub?.cancel();
    super.dispose();
  }

  void _submitOrder() async {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal 1 menu')),
      );
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nama pelanggan')),
      );
      return;
    }
    if (_selectedTable == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih meja terlebih dahulu')),
      );
      return;
    }

    final orderItems = _cartItems.map((item) => OrderItem(
      menuId: item.id ?? '',
      menuName: item.name,
      quantity: item.quantity,
      pricePerItem: item.priceValue,
      subtotal: item.priceValue * item.quantity,
    )).toList();

    final order = Order(
      items: orderItems,
      totalAmount: _totalAmount,
      paymentMethod: 'Tunai',
      customerName: _nameController.text.trim(),
      tableNumber: _selectedTable!,
      status: 'Diproses',
      createdAt: DateTime.now(),
    );

    try {
      if (_occupiedTables[_selectedTable!] == 'Selesai') {
        await _orderService.clearTable(_selectedTable!);
      }

      await _orderService.addOrder(order);

      _nameController.clear();
      for (final item in _menuItems) {
        item.quantity = 0;
      }
      setState(() {
        _selectedTable = null;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil dibuat'), backgroundColor: Color(0xFF22C55E)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat pesanan: ${e.toString().replaceFirst('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
          color: const Color(0xFF901B1E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo_jayen.png',
                            width: 36, height: 36, color: Colors.white,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.restaurant, color: Colors.white, size: 34),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'Baso Jayen',
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 26),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildSidebarItem(
                icon: Icons.grid_view_rounded,
                title: 'Dashboard',
                isActive: false,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/admin-dashboard');
                },
              ),
              _buildSidebarItem(
                icon: Icons.restaurant_menu_rounded,
                title: 'Menu',
                isActive: false,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/admin-menu');
                },
              ),
              _buildSidebarItem(
                icon: Icons.menu_book_rounded,
                title: 'Pesanan Masuk',
                isActive: false,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/pesanan-masuk');
                },
              ),
              _buildSidebarItem(
                icon: Icons.shopping_cart_outlined,
                title: 'Pemesanan Pelanggan',
                isActive: true,
                onTap: () => Navigator.pop(context),
              ),
              _buildSidebarItem(
                icon: Icons.qr_code,
                title: 'QR Code Meja',
                isActive: false,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/qr-table');
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildSidebarItem(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/menu');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF901B1E),
        title: Text('Pemesanan Pelanggan', style: GoogleFonts.inter(color: Colors.white)),
        actions: [
          if (totalCartItems > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalCartItems',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF901B1E)))
          : Column(
              children: [
                Expanded(
                  child: _menuItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text('Tidak ada menu tersedia', style: GoogleFonts.inter(color: Colors.grey, fontSize: 16)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          itemCount: _menuItems.length,
                          itemBuilder: (context, index) {
                            final item = _menuItems[index];
                            return _buildMenuItemCard(item);
                          },
                        ),
                ),
                if (_cartItems.isNotEmpty) _buildBottomOrderForm(),
              ],
            ),
    );
  }

  Widget _buildMenuItemCard(MenuData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF901B1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                width: 56, height: 56,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: MenuImage(imagePath: item.imagePath, size: 56),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                const SizedBox(height: 2),
                Text(item.desc, style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withOpacity(0.8)), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(item.price, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          item.quantity == 0
              ? ElevatedButton(
                  onPressed: () => setState(() => item.quantity++),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  child: Text('+', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        icon: const Icon(Icons.remove, color: Color(0xFF901B1E), size: 16),
                        onPressed: () => setState(() => item.quantity--),
                      ),
                      Text('${item.quantity}', style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        icon: const Icon(Icons.add, color: Color(0xFF901B1E), size: 16),
                        onPressed: () => setState(() => item.quantity++),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildBottomOrderForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF901B1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Nama Pelanggan',
              hintStyle: GoogleFonts.inter(color: Colors.white.withOpacity(0.6), fontSize: 14),
              prefixIcon: Icon(Icons.person_outline, color: Colors.white.withOpacity(0.7), size: 20),
              filled: true,
              fillColor: Colors.white.withOpacity(0.15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),
          _buildTableGrid(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total: Rp ${NumberFormat('#,##0', 'id_ID').format(_totalAmount)}',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Buat Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Meja',
          style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 130,
          child: GridView.builder(
            physics: const ClampingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.1,
            ),
            itemCount: _totalTables,
          itemBuilder: (context, index) {
            final tableNum = (index + 1).toString();
            final tableStatus = _occupiedTables[tableNum];
            final isTerisi = tableStatus == 'Diproses';
            final isMakan = tableStatus == 'Selesai';
            final isSelected = _selectedTable == tableNum;

            Color bgColor;
            Color borderColor;
            Widget icon;
            String label;

            if (isTerisi) {
              bgColor = Colors.white.withOpacity(0.1);
              borderColor = Colors.red.withOpacity(0.6);
              icon = Icon(Icons.close, color: Colors.red.withOpacity(0.7), size: 20);
              label = 'Terisi';
            } else if (isSelected) {
              bgColor = Colors.amber;
              borderColor = Colors.white;
              icon = Icon(Icons.check, color: const Color(0xFF901B1E), size: 20);
              label = '';
            } else {
              bgColor = Colors.white.withOpacity(0.15);
              borderColor = Colors.white.withOpacity(0.3);
              icon = Icon(Icons.table_restaurant_outlined, color: Colors.white.withOpacity(0.6), size: 20);
              label = '';
            }

            return GestureDetector(
              onTap: () {
                if (isTerisi) return;
                setState(() => _selectedTable = tableNum);
              },
              onLongPress: () {
                if (isTerisi || isMakan) {
                  _tampilkanDialogKosongkanMeja(tableNum);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon,
                    const SizedBox(height: 4),
                    Text(
                      'Meja $tableNum',
                      style: GoogleFonts.inter(
                        color: isTerisi
                            ? Colors.red.withOpacity(0.7)
                            : Colors.white,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (label.isNotEmpty)
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          color: Colors.red.withOpacity(0.5),
                          fontSize: 9,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        ),
      ],
    );
  }

  void _tampilkanDialogKosongkanMeja(String tableNum) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFF901B1E), shape: BoxShape.circle),
              child: const Icon(Icons.cleaning_services, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Kosongkan Meja $tableNum?',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pelanggan di Meja $tableNum sudah selesai makan dan meninggalkan meja.',
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text('Batal', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black87)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      try {
                        await _orderService.clearTable(tableNum);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Meja $tableNum sudah kosong'),
                              backgroundColor: const Color(0xFF22C55E),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${e.toString().replaceFirst('Exception: ', '')}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text('Kosongkan', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 22),
        title: Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
        onTap: onTap,
        dense: true,
      ),
    );
  }
}
