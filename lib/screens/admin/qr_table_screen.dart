import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminQRTableScreen extends StatefulWidget {
  const AdminQRTableScreen({super.key});

  @override
  State<AdminQRTableScreen> createState() => _AdminQRTableScreenState();
}

class _AdminQRTableScreenState extends State<AdminQRTableScreen> {
  static const int totalTables = 6;
  String currentActiveMenu = 'QR Code Meja';

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
                isActive: false,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/pemesanan-pelanggan');
                },
              ),
              _buildSidebarItem(
                icon: Icons.qr_code,
                title: 'QR Code Meja',
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF901B1E),
        title: Text('QR Code Meja', style: GoogleFonts.inter(color: Colors.white)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: totalTables,
        itemBuilder: (context, index) {
          final tableNum = index + 1;
          return _buildQRCard(tableNum);
        },
      ),
    );
  }

  Widget _buildQRCard(int tableNum) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Meja $tableNum',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF901B1E)),
          ),
          const SizedBox(height: 8),
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF901B1E).withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/qrcode/$tableNum.jpeg',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_2, size: 40, color: Colors.grey[400]),
                      const SizedBox(height: 4),
                      Text('QR Meja $tableNum', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              final bytes = await rootBundle.load('assets/images/qrcode/$tableNum.jpeg');
              final blob = html.Blob([bytes.buffer]);
              final blobUrl = html.Url.createObjectUrlFromBlob(blob);
              html.AnchorElement(href: blobUrl)
                ..download = 'QR_Meja_$tableNum.png'
                ..click();
              html.Url.revokeObjectUrl(blobUrl);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF901B1E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download, size: 12, color: const Color(0xFF901B1E)),
                  const SizedBox(width: 4),
                  Text('Download QR', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF901B1E), fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
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
