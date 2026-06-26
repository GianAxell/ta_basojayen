import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config.dart';
import 'services/supabase_service.dart';
import 'services/connectivity_service.dart';
import 'screens/users/menu_list_screen.dart';
import 'screens/admin/menu_screen.dart';
import 'screens/admin/login_screen.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/admin/pesanan_masuk.dart';
import 'screens/admin/pemesanan_pelanggan.dart';
import 'screens/admin/qr_table_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/scan_qr_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await SupabaseService().initialize(AppConfig.supabaseUrl, AppConfig.supabaseAnonKey);
  } catch (e) {
    // Biarkan app tetap jalan walau Supabase gagal init
  }

  final appLinks = AppLinks();
  appLinks.uriLinkStream.listen(_handleDeepLink);

  ConnectivityService().initialize();

  runApp(const MyApp());
}

void _handleDeepLink(Uri uri) {
  if (uri.scheme == 'basojayen' && uri.host == 'order') {
    final tableNumber = uri.queryParameters['table'] ?? '';
    if (tableNumber.isNotEmpty) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => MenuListScreen(tableNumber: tableNumber),
        ),
      );
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _dialogVisible = false;

  void _showNoInternetDialog() {
    if (_dialogVisible) return;
    _dialogVisible = true;
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, color: Color(0xFF901B1E), size: 64),
              const SizedBox(height: 16),
              Text(
                'Jaringan Tidak Tersedia',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Periksa koneksi internet Anda dan coba lagi.',
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final online = await ConnectivityService().checkNow();
                    if (online) {
                      if (mounted) Navigator.of(context, rootNavigator: true).pop();
                      _dialogVisible = false;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF901B1E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Coba Lagi',
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ConnectivityService().onConnectivityChanged.listen((isOnline) {
      if (!mounted) return;
      if (isOnline && _dialogVisible) {
        _dialogVisible = false;
        final ctx = navigatorKey.currentContext;
        if (ctx != null) {
          Navigator.of(ctx, rootNavigator: true).pop();
        }
      } else if (!isOnline) {
        _showNoInternetDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Baso Jayen POS',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/scan-qr': (context) => const ScanQRScreen(),
        '/menu': (context) => const MenuListScreen(),
        '/login-admin': (context) => const AdminLoginScreen(),
        '/admin-dashboard': (context) => const AdminDashboardScreen(),
        '/admin-menu': (context) => const AdminMenuScreen(),
        '/pesanan-masuk': (context) => const AdminPesananMasukScreen(),
        '/pemesanan-pelanggan': (context) => const AdminPemesananPelangganScreen(),
        '/qr-table': (context) => const AdminQRTableScreen(),
      },
    );
  }
}