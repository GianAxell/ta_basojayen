import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/menu_model.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';
import 'screen_status_pesanan.dart';

class PaymentScreen extends StatefulWidget {
  final int totalAmount;
  final List<MenuData> selectedItems;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String tableNumber;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.selectedItems,
    this.customerName = '',
    this.customerEmail = '',
    this.customerPhone = '',
    this.tableNumber = '',
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Default terpilih otomatis ke E-Wallet sesuai desain Figma
  String selectedMethod = 'E-Wallet'; 

  // Data Rekening Toko Baso Jayen
  final String _bankName = 'BANK BCA';
  final String _accountNumber = '123456789098765';
  final String _accountHolder = 'Woody';

  // Fungsi untuk memunculkan Popup bahwa Pesanan Telah Berhasil Dipesan
  Future<void> _showSuccessPopup() async {
    final orderService = OrderService();
    final orderItems = widget.selectedItems.map((item) => OrderItem(
      menuId: item.id ?? '',
      menuName: item.name,
      quantity: item.quantity,
      pricePerItem: item.priceValue,
      subtotal: item.priceValue * item.quantity,
    )).toList();

    final order = Order(
      items: orderItems,
      totalAmount: widget.totalAmount,
      paymentMethod: selectedMethod,
      customerName: widget.customerName,
      customerEmail: widget.customerEmail,
      customerPhone: widget.customerPhone,
      tableNumber: widget.tableNumber,
      status: 'Diproses',
      createdAt: DateTime.now(),
    );

    try {
      await orderService.addOrder(order);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memproses pesanan: ${e.toString().replaceFirst('Exception: ', '')}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 72),
            const SizedBox(height: 16),
            Text(
              'Pesanan Berhasil Dipesan!', 
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pembayaran menggunakan $selectedMethod telah diterima dan pesanan Anda sedang diteruskan ke dapur.', 
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Tombol Selesai untuk Menuju ke Halaman Status Pesanan
            ElevatedButton(
              onPressed: () {
                // 1. Tutup popup sukses terlebih dahulu
                Navigator.pop(context);
                
                // 2. Masuk ke halaman Status Pesanan membawa data nominal
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderStatusScreen(
                      totalAmount: widget.totalAmount,
                      itemCount: widget.selectedItems.fold(0, (sum, item) => sum + item.quantity),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF901B1E),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                'Selesai', 
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF901B1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pilih Pembayaran',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Text(
              'Total Pembayaran: Rp. ${NumberFormat('#,##0', 'id_ID').format(widget.totalAmount)}',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF901B1E)),
            ),
            const SizedBox(height: 28),

            // opsi e-wallet
            _buildPaymentMethodTile(
              methodName: 'E-Wallet',
              subtext: 'GoPay, OVO, DANA',
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 16),

            // opsi transfer bank
            _buildPaymentMethodTile(
              methodName: 'Transfer Bank',
              subtext: 'BCA, MANDIRI, BRI',
              icon: Icons.account_balance_outlined,
            ),
            const SizedBox(height: 40),

            // pemilihan pembayaran berdasarkan metode yang dipilih
            if (selectedMethod == 'E-Wallet') ...[
              Center(
                child: Container(
                  width: 220,
                  height: 220,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF901B1E), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/qr_jayen.jpeg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[100],
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code_2_rounded, size: 64, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Foto QR belum terdaftar\ndi pubspec.yaml', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Scan QR code diatas menggunakan aplikasi E-Wallet pilihanmu untuk melakukan pembayaran',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF8F8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF901B1E).withOpacity(0.2), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_bankName, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF901B1E))),
                        const Icon(Icons.credit_card_rounded, color: Color(0xFF901B1E)),
                      ],
                    ),
                    const Divider(height: 24, thickness: 1),
                    Text('Nomor Rekening:', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_accountNumber, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 1.2)),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Nomor rekening berhasil disalin!'), duration: Duration(seconds: 2)),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0xFF901B1E), borderRadius: BorderRadius.circular(8)),
                            child: Text('Salin', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Nama Pemilik Rekening:', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(_accountHolder, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Silakan lakukan transfer ke nomor rekening resmi Baso Jayen di atas',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 60),

            // tombol lanjutkan pembayaran untuk memunculkan popup sukses
            ElevatedButton(
              onPressed: () {
                _showSuccessPopup(); // Memanggil Popup Sukses Berhasil Dipesan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF901B1E),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                'Lanjutkan Pembayaran',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile({required String methodName, required String subtext, required IconData icon}) {
    bool isSelected = selectedMethod == methodName;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = methodName;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF901B1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFFE9C46A) : Colors.transparent, width: 2.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(methodName, style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtext, style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFE9C46A), size: 24),
          ],
        ),
      ),
    );
  }
}