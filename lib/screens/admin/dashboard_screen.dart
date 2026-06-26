import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/menu_model.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';
import '../../services/menu_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String currentActiveMenu = 'Dashboard';
  final OrderService _orderService = OrderService();
  final MenuService _menuService = MenuService();

  double _todayIncome = 0;
  int _todayOrders = 0;
  int _activeMenuCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    double income = 0;
    int orderCount = 0;
    List<MenuData> menus = [];

    try {
      income = await _orderService.getTodayIncome();
    } catch (e) {
      income = 0;
    }

    try {
      orderCount = await _orderService.getTodayOrderCount();
    } catch (e) {
      orderCount = 0;
    }

    try {
      menus = await _menuService.getAllMenus();
    } catch (e) {
      menus = [];
    }

    if (mounted) {
      setState(() {
        _todayIncome = income;
        _todayOrders = orderCount;
        _activeMenuCount = menus.where((m) => m.isActive).length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Dashboard',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),

      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
          color: const Color(0xFF901B1E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. header sidebar dengan logo dan nama restoran
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
                            width: 36,
                            height: 36,
                            color: Colors.white,
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.restaurant, color: Colors.white, size: 34),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'Baso Jayen',
                            style: GoogleFonts.inter(
                              color: Colors.white, 
                              fontSize: 18, 
                              fontWeight: FontWeight.normal,
                            ),
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

              // 2. daftar menu sidebar
              _buildSidebarItem(
                icon: Icons.grid_view_rounded,
                title: 'Dashboard',
                isActive: currentActiveMenu == 'Dashboard',
                onTap: () {
                  setState(() => currentActiveMenu = 'Dashboard');
                  Navigator.pop(context);
                },
              ),
              
              // Menghubungkan tombol Menu langsung ke halaman tabel admin
              _buildSidebarItem(
                icon: Icons.restaurant_menu_rounded,
                title: 'Menu',
                isActive: currentActiveMenu == 'Menu',
                onTap: () {
                  setState(() => currentActiveMenu = 'Menu');
                  Navigator.pop(context); // 1. Tutup laci hamburger drawer
                  Navigator.pushNamed(context, '/admin-menu'); // 2. Berpindah ke manajemen tabel menu
                },
              ),
              
              // pesanan masuk
              _buildSidebarItem(
                icon: Icons.menu_book_rounded,
                title: 'Pesanan Masuk',
                isActive: currentActiveMenu == 'Pesanan Masuk',
                onTap: () {
                  setState(() => currentActiveMenu = 'Pesanan Masuk');
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/pesanan-masuk');
                },
              ),

              // pemesanan pelanggan
              _buildSidebarItem(
                icon: Icons.shopping_cart_outlined,
                title: 'Pemesanan Pelanggan',
                isActive: currentActiveMenu == 'Pemesanan Pelanggan',
                onTap: () {
                  setState(() => currentActiveMenu = 'Pemesanan Pelanggan');
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/pemesanan-pelanggan');
                },
              ),

              _buildSidebarItem(
                icon: Icons.qr_code,
                title: 'QR Code Meja',
                isActive: currentActiveMenu == 'QR Code Meja',
                onTap: () {
                  setState(() => currentActiveMenu = 'QR Code Meja');
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/qr-table');
                },
              ),

              const Spacer(),

              // 3. tombol logout
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

      // isi dashboard
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.25,
              children: [
                _buildSummaryCard(
                  icon: Icons.attach_money_rounded,
                  title: 'Pendapatan hari ini',
                  value: 'Rp ${NumberFormat('#,##0', 'id_ID').format(_todayIncome)}',
                  isPositive: true,
                ),
                _buildSummaryCard(
                  icon: Icons.assignment_outlined,
                  title: 'Pesanan hari ini',
                  value: '$_todayOrders',
                  isPositive: true,
                ),
                _buildSummaryCard(
                  icon: Icons.restaurant_menu_rounded,
                  title: 'Total menu aktif',
                  value: '$_activeMenuCount',
                  extraInfo: 'Menu Aktif',
                  isPositive: null,
                ),
                _buildSummaryCard(
                  icon: Icons.table_bar_outlined,
                  title: 'meja aktif',
                  value: '6',
                  extraInfo: 'Dari 6 meja',
                  isPositive: null,
                ),
              ],
            ),
            
            const SizedBox(height: 24),

            // Tabel Pesanan Masuk
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDBDBDB),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pesanan masuk terbaru',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _tableHeaderCell('Nama', width: 80),
                      _tableHeaderCell('Menu', width: 80),
                      _tableHeaderCell('Total', width: 50),
                      _tableHeaderCell('Status', width: 70, alignRight: true),
                    ],
                  ),
                  const Divider(color: Colors.black87, thickness: 1.5, height: 16),

                  StreamBuilder<List<Order>>(
                    stream: _orderService.getOrderStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
                      }
                      final orders = snapshot.data;
                      if (orders == null || orders.isEmpty) {
                        return Padding(padding: const EdgeInsets.all(16), child: Center(child: Text('Belum ada pesanan', style: GoogleFonts.inter(fontSize: 12, color: Colors.black54))));
                      }
                      return Column(
                        children: orders.take(10).map((order) {
                          final customerName = order.customerName.isNotEmpty ? order.customerName : 'Pelanggan';
                          final menuNames = order.items.take(2).map((item) => '${item.menuName}${item.quantity > 1 ? " ${item.quantity}x" : ""}').join(', ');
                          final total = order.totalAmount;
                          return _buildOrderRow(customerName, menuNames, 'Rp ${NumberFormat('#,##0', 'id_ID').format(total)}', order.status);
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({required IconData icon, required String title, required String value, String? trends, String? extraInfo, bool? isPositive}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFDBDBDB), borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.black54),
              const SizedBox(width: 4),
              Expanded(child: Text(title, style: GoogleFonts.inter(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const Spacer(),
          Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
          const Spacer(),
          if (trends != null)
            Row(
              children: [
                Icon(isPositive == true ? Icons.trending_up_rounded : Icons.trending_down_rounded, size: 14, color: isPositive == true ? Colors.green[700] : Colors.red),
                const SizedBox(width: 2),
                Text(trends, style: GoogleFonts.inter(fontSize: 11, color: Colors.green[700], fontWeight: FontWeight.bold)),
              ],
            ),
          if (extraInfo != null) Text(extraInfo, style: GoogleFonts.inter(fontSize: 10, color: Colors.green[700], height: 1.1)),
        ],
      ),
    );
  }

  Widget _tableHeaderCell(String text, {required double width, bool alignRight = false}) {
    return SizedBox(width: width, child: Text(text, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black), textAlign: alignRight ? TextAlign.right : TextAlign.left));
  }

  Widget _buildOrderRow(String meja, String menu, String total, String status) {
    bool isSelesai = status == 'Selesai';
    bool isDibatalkan = status == 'Dibatalkan';
    Color bgColor;
    Color textColor;
    if (isSelesai) {
      bgColor = const Color(0xFF22C55E);
      textColor = Colors.white;
    } else if (isDibatalkan) {
      bgColor = const Color(0xFFE53935);
      textColor = Colors.white;
    } else {
      bgColor = const Color(0xFFE9C46A);
      textColor = Colors.black87;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 60, child: Text(meja, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500))),
              SizedBox(width: 80, child: Text(menu, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500))),
              SizedBox(width: 50, child: Text(total, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500))),
              SizedBox(
                width: 70,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                    child: Text(status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(color: Colors.black26, thickness: 0.8, height: 1),
        ],
      ),
    );
  }
}