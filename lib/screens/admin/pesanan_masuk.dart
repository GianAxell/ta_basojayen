import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPesananMasukScreen extends StatefulWidget {
  const AdminPesananMasukScreen({super.key});

  @override
  State<AdminPesananMasukScreen> createState() => _AdminPesananMasukScreenState();
}

class _AdminPesananMasukScreenState extends State<AdminPesananMasukScreen> {
  String currentActiveMenu = 'Pesanan Masuk';

  // Data Dummy Pesanan
  List<Map<String, dynamic>> orders = [
    {
      'id': '#007',
      'meja': 'Meja 7',
      'waktu': '10:58',
      'total_menu': '3 menu',
      'item_list': 'Mie, Baso urat, Baso daging, Baso tahu, Siomay (Paket A)\nBaso daging, Baso urat, Baso Tahu... (Paket C)\nBaso telor, Baso daging, Baso...eker (Paket D)',
      'harga': '30.000',
      'status': 'Diproses',
    },
    {
      'id': '#006',
      'meja': 'Meja 3',
      'waktu': '10:58',
      'total_menu': '3 menu',
      'item_list': 'Mie, Baso urat, Baso daging, Baso tahu, Siomay (Paket A)\nBaso daging, Baso urat, Baso Tahu... (Paket C)\nBaso telor, Baso daging, Baso...eker 2x (Paket D)',
      'harga': '40.000',
      'status': 'Diproses',
    },
    {
      'id': '#005',
      'meja': 'Meja 1',
      'waktu': '10:58',
      'total_menu': '1 menu',
      'item_list': 'Baso daging, Baso urat, Baso Tahu... (Paket C)',
      'harga': '10.000',
      'status': 'Selesai',
    },
    {
      'id': '#004',
      'meja': 'Meja 2',
      'waktu': '10:58',
      'total_menu': '2 menu',
      'item_list': 'Mie, Baso urat, Baso daging, Baso tahu, Siomay (Paket A)\nBaso daging, Baso urat, Baso Tahu... (Paket C)',
      'harga': '20.000',
      'status': 'Dibatalkan',
    },
  ];

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order, index);
        },
      ),
    );
  }

  // daftar pesanan masuk
  Widget _buildOrderCard(Map<String, dynamic> order, int index) {
    bool isDiproses = order['status'] == 'Diproses';
    bool isSelesai = order['status'] == 'Selesai';

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
          // Meja, Kode ID Order, dan Badge Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    order['meja'],
                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order['id'],
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
                  order['status'],
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
          
          // text: Waktu trans & jumlah item paket
          Text(
            '${order['waktu']}  •  ${order['total_menu']}',
            style: GoogleFonts.inter(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 10),
          
          // Detail Rincian Menu Paket Jayen
          Text(
            order['item_list'],
            style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 14),

          // Total Bayar & Tombol Aksi Kasir
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp. ${order['harga']}',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF901B1E)),
              ),
              
              // tombol untuk status pesanan "Diproses"
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
            ],
          ),
        ],
      ),
    );
  }

  // fungsi untuk update status pesanan dan menampilkan pop up sukses
  void _eksekusiStatus(int index, String statusBaru) {
    setState(() {
      orders[index]['status'] = statusBaru;
    });

    _tampilkanPopupSukses(statusBaru == 'Selesai');
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