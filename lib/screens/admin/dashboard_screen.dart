import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // menu aktif di dashboard
  String currentActiveMenu = 'Dashboard';

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
                            width: 24,
                            height: 24,
                            color: Colors.white,
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.restaurant, color: Colors.white, size: 22),
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
                  Navigator.pop(context); // Tutup drawer laci samping
                  Navigator.pushNamed(context, '/pesanan-masuk'); // Terbang ke halaman list order kasir
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
                  value: 'Rp 1,4jt',
                  trends: '+12%',
                  isPositive: true,
                ),
                _buildSummaryCard(
                  icon: Icons.assignment_outlined,
                  title: 'Pesanan hari ini',
                  value: '74',
                  trends: '+12%',
                  isPositive: true,
                ),
                _buildSummaryCard(
                  icon: Icons.restaurant_menu_rounded,
                  title: 'Total menu aktif',
                  value: '18',
                  extraInfo: 'Makanan\n& Minuman',
                  isPositive: null,
                ),
                _buildSummaryCard(
                  icon: Icons.table_bar_outlined,
                  title: 'meja aktif',
                  value: '6',
                  extraInfo: 'Dari 10 meja',
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
                      _tableHeaderCell('Meja', width: 60),
                      _tableHeaderCell('Menu', width: 80),
                      _tableHeaderCell('Total', width: 50),
                      _tableHeaderCell('Status', width: 70, alignRight: true),
                    ],
                  ),
                  const Divider(color: Colors.black87, thickness: 1.5, height: 16),

                  _buildOrderRow('Meja 1', 'Paket A', '15rb', 'Proses'),
                  _buildOrderRow('Meja 3', 'Paket C', '15rb', 'Selesai'),
                  _buildOrderRow('Meja 5', 'Paket D', '15rb', 'Selesai'),
                  _buildOrderRow('Meja 2', 'Paket B', '15rb', 'Proses'),
                  _buildOrderRow('Meja 7', 'Paket F', '15rb', 'Proses'),
                  _buildOrderRow('Meja 6', 'Paket E', '15rb', 'Selesai'),
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
                    decoration: BoxDecoration(color: isSelesai ? const Color(0xFF22C55E) : const Color(0xFFE9C46A), borderRadius: BorderRadius.circular(12)),
                    child: Text(status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: isSelesai ? Colors.white : Colors.black87)),
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