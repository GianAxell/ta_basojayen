import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderStatusScreen extends StatelessWidget {
  final int totalAmount;
  final int itemCount;

  const OrderStatusScreen({
    super.key, 
    required this.totalAmount, 
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF901B1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: Text(
          'Status Pesanan',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          // 1. header pesanan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Color(0xFF901B1E)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#ORD20260604-004',
                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'SEDANG DIPROSES',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '$itemCount menu | Rp. ${totalAmount == 0 ? "60.000" : totalAmount}',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 2. status pesanan
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0xFF901B1E), // Mengikuti gambar image_825d01.png
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  _buildStatusStep(
                    title: 'Pesanan diterima',
                    subtitle: '10.35 | Pembayaran dikonfirmasi',
                    isCompleted: true,
                    isLast: false,
                  ),
                  _buildStatusStep(
                    title: 'Sedang dimasak',
                    subtitle: '10.37 | Dapur memproses',
                    isCompleted: true,
                    isLast: false,
                  ),
                  _buildStatusStep(
                    title: 'Pesanan sudah siap diambil',
                    subtitle: '10.55 | Pesanan Selesai',
                    isCompleted: false, // Warna biru di Figma
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // 3. tombol selesai
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF901B1E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                'Selesai',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatusStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFF22C55E) : const Color(0xFF3B5998), // Hijau vs Biru
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
              if (!isLast) ...[
                const SizedBox(height: 4),
                const Icon(Icons.arrow_downward, color: Colors.white, size: 16), // Panah putih penghubung
                const SizedBox(height: 4),
              ],
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withOpacity(0.8)),
                ),
                if (!isLast) const SizedBox(height: 28), // Spacer antar status
              ],
            ),
          ),
        ],
      ),
    );
  }
}