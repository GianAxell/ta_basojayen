import 'package:flutter/material.dart';
// Jalur folder asli proyekmu
import 'screens/users/menu_list_screen.dart'; 
import 'screens/admin/menu_screen.dart'; 
import 'screens/admin/login_screen.dart'; 
import 'screens/admin/dashboard_screen.dart'; // PASTIKAN IMPORT INI ADA
import 'screens/admin/pesanan_masuk.dart';    // PASTIKAN IMPORT INI ADA

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baso Jayen POS',
      debugShowCheckedModeBanner: false,
      initialRoute: '/menu', // Pertama kali dibuka diarahkan ke menu pembeli
      routes: {
        // 1. Rute Sisi Pembeli
        '/menu': (context) => const MenuListScreen(),
        
        // 2. Rute Sisi Login Admin
        '/login-admin': (context) => const AdminLoginScreen(), 
        
        // 3. PERBAIKAN RUTING: Daftarkan /admin-dashboard agar sinkron dengan sidebar drawer
        '/admin-dashboard': (context) => const AdminDashboardScreen(), 

        // 4. Rute Manajemen Tabel Menu Admin Paket A-J
        '/admin-menu': (context) => const AdminMenuScreen(), 

        // 5. Rute Manajemen List Pesanan Masuk Kasir
        '/pesanan-masuk': (context) => const AdminPesananMasukScreen(),
      },
    );
  }
}