import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import 'dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final success = await _authService.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
      setState(() => _isLoading = false);

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username atau Password salah!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(color: const Color(0xFF901B1E)),
              ),
              Expanded(
                flex: 6,
                child: Container(color: const Color(0xFFE0E0E0)),
              ),
            ],
          ),
          // Kotak Form Login Tengah
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF901B1E),
                  borderRadius: BorderRadius.circular(4), // Siku tegas khas desain komponen kamu
                  border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.restaurant_rounded,
                          color: Color(0xFF901B1E),
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Admin Login',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Input Username
                      TextFormField(
                        controller: _usernameController,
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        validator: (value) => value!.isEmpty ? 'Username kosong' : null,
                      ),
                      const SizedBox(height: 16),
                      // Input Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        validator: (value) => value!.isEmpty ? 'Password kosong' : null,
                      ),
                      const SizedBox(height: 36),
                      // Tombol login
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                          foregroundColor: Colors.black87,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black87))
                            : Text('Log in', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}