import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screen_pembayaran.dart'; // Menghubungkan ke halaman pembayaran setelah data diisi

class CustomerDataScreen extends StatefulWidget {
  final int totalAmount; // Menerima total harga dari keranjang

  const CustomerDataScreen({super.key, required this.totalAmount});

  @override
  State<CustomerDataScreen> createState() => _CustomerDataScreenState();
}

class _CustomerDataScreenState extends State<CustomerDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
        // Teks Judul
        title: Text(
          'Isi data diri',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. input nama
              _buildMaroonInput(
                controller: nameController,
                hintText: 'Masukan nama Anda',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 2. input email
              _buildMaroonInput(
                controller: emailController,
                hintText: 'Masukan email anda',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  // Validasi format email
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Format email salah';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 3. input nomor telepon (opsional)
              _buildMaroonInput(
                controller: phoneController,
                hintText: 'Masukan Nomor Telpon anda (Opsional)',
                icon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
                // Tidak pakai validator karena opsional
              ),
              
              const Spacer(),

              // 4. tombol lanjutkan
              ElevatedButton(
                onPressed: () {
                  // Validasi apakah form wajib sudah diisi semua
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          totalAmount: widget.totalAmount,
                          // Data diri bisa dioper ke screen_pembayaran jika diperlukan nanti
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF901B1E),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                ),
                child: Text(
                  'Lanjutkan',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pendukung untuk membuat Input Field
  Widget _buildMaroonInput({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: Colors.white.withOpacity(0.7), fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7), size: 22),
        filled: true,
        fillColor: const Color(0xFF901B1E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        // saat error validasi muncul
        errorStyle: const TextStyle(color: Colors.redAccent),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
      ),
    );
  }
}