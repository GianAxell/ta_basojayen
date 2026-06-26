import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';

class AdminPesananMasukScreen extends StatefulWidget {
  const AdminPesananMasukScreen({super.key});

  @override
  State<AdminPesananMasukScreen> createState() => _AdminPesananMasukScreenState();
}

class _AdminPesananMasukScreenState extends State<AdminPesananMasukScreen> {
  String currentActiveMenu = 'Pesanan Masuk';
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _orderService.getOrderStream().listen(
      (orders) {
        if (mounted) {
          setState(() {
            _orders = orders;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF901B1E),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'Pesanan Masuk',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 26),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Siku tegas figma
        child: Container(
          color: const Color(0xFF901B1E), // Latar marun sidebar penuh
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
                          const Icon(Icons.restaurant, color: Colors.white, size: 22),
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

              // Item Navigasi Samping
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
                isActive: true,
                onTap: () => Navigator.pop(context),
              ),

              _buildSidebarItem(
                icon: Icons.shopping_cart_outlined,
                title: 'Pemesanan Pelanggan',
                isActive: false,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/pemesanan-pelanggan');
                },
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

      // isi halaman utama
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF901B1E)))
          : _orders.isEmpty
              ? Center(child: Text('Belum ada pesanan masuk', style: GoogleFonts.inter(fontSize: 16, color: Colors.black54)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return _buildOrderCard(order, index);
                  },
                ),
    );
  }

  // daftar pesanan masuk
  Widget _buildOrderCard(Order order, int index) {
    bool isDiproses = order.status == 'Diproses';
    bool isSelesai = order.status == 'Selesai';

    final itemNames = order.items.map((item) => '${item.menuName} ${item.quantity}x').join('\n');
    final timeStr = order.createdAt != null
        ? DateFormat('HH:mm').format(order.createdAt!)
        : '--:--';
    final totalItems = order.items.fold(0, (sum, item) => sum + item.quantity);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama Pelanggan, Kode ID Order, dan Badge Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    order.customerName.isNotEmpty ? order.customerName : 'Pelanggan',
                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.orderNumber.isNotEmpty ? '#${order.orderNumber}' : '#${order.id?.substring(0, 6) ?? ''}',
                    style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF1E88E5), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              
              // status pesanan
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isDiproses 
                      ? const Color(0xFFFFF59D) 
                      : (isSelesai ? const Color(0xFFBBDEFB) : const Color(0xFFFFCDD2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDiproses 
                        ? Colors.amber[900] 
                        : (isSelesai ? Colors.blue[800] : const Color(0xFFB71C1C)),
                  ),
                ),
              ),
            ],
          ),
          
          // text: Waktu trans, jumlah item & meja
          Text(
            order.tableNumber.isNotEmpty
                ? '$timeStr  •  $totalItems menu  •  Meja ${order.tableNumber}'
                : '$timeStr  •  $totalItems menu',
            style: GoogleFonts.inter(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 10),
          
          // Detail Rincian Menu
          Text(
            itemNames,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 14),

          // Total Bayar & Tombol Aksi Kasir
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp ${NumberFormat('#,##0', 'id_ID').format(order.totalAmount)}',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF901B1E)),
              ),
              
              // tombol untuk status pesanan
              if (isDiproses)
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _eksekusiStatus(index, 'Selesai'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 0,
                      ),
                      child: Text('Selesai', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _eksekusiStatus(index, 'Dibatalkan'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935), 
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              if (isSelesai || order.status == 'Dibatalkan')
                GestureDetector(
                  onTap: () => _hapusDariTampilan(index, order),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // fungsi untuk update status pesanan dan menampilkan pop up sukses
  void _eksekusiStatus(int index, String statusBaru) async {
    final order = _orders[index];
    if (statusBaru == 'Selesai') {
      _tampilkanDialogKonfirmasiSelesai(index, order);
      return;
    }
    try {
      await _orderService.updateStatus(order.id!, statusBaru);
      _tampilkanPopupSukses(false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal update status: ${e.toString().replaceFirst('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _tampilkanDialogKonfirmasiSelesai(int index, Order order) {
    final isDineIn = order.tableNumber.isNotEmpty;
    final tableInfo = isDineIn ? 'Meja ${order.tableNumber}' : 'Takeaway';
    final customerName = order.customerName.isNotEmpty ? order.customerName : 'Pelanggan';

    final buttonLabel = isDineIn ? 'Ya, Kosongkan Meja' : 'Konfirmasi Selesai';
    final buttonIcon = isDineIn ? Icons.cleaning_services : Icons.check_circle;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 64),
            const SizedBox(height: 12),
            Text(
              'Konfirmasi pesanan $customerName sebagai selesai?',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pesanan di $tableInfo akan ditandai selesai.',
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await _orderService.updateStatus(order.id!, 'Selesai');
                    if (isDineIn) {
                      await _orderService.clearTable(order.tableNumber);
                    }
                    _tampilkanPopupSukses(true);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${e.toString().replaceFirst('Exception: ', '')}'), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                icon: Icon(buttonIcon, color: Colors.white, size: 20),
                label: Text(buttonLabel, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _hapusDariTampilan(int index, Order order) async {
    if (order.id != null) {
      await _orderService.deleteOrder(order.id!);
    }
    if (mounted) {
      setState(() => _orders.removeAt(index));
    }
  }

  void _tampilkanPopupSukses(bool sukses) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // Efek Auto-close pop up
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        });

        return Dialog(
          backgroundColor: const Color(0xFF901B1E), // Kotak dialog marun penuh figma
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(
                    sukses ? Icons.check : Icons.close,
                    color: const Color(0xFF901B1E),
                    size: 55,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  sukses ? 'Pesanan telah selesai' : 'Pesanan dibatalkan',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget pembangun item navigasi
  Widget _buildSidebarItem({required IconData icon, required String title, required bool isActive, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: isActive ? Colors.white.withOpacity(0.12) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 16),
            Text(
              title, 
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}