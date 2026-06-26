import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'users/menu_list_screen.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> with WidgetsBindingObserver {
  MobileScannerController? _controller;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller?.start();
    } else if (state == AppLifecycleState.paused) {
      _controller?.stop();
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final url = barcode.rawValue!;
    final uri = Uri.tryParse(url);
    if (uri != null && uri.scheme == 'basojayen' && uri.host == 'order') {
      final tableNumber = uri.queryParameters['table'] ?? '';
      if (tableNumber.isNotEmpty) {
        _isProcessing = true;
        _controller?.stop().then((_) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MenuListScreen(tableNumber: tableNumber),
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF901B1E),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Scan QR Code Meja',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: Colors.white.withOpacity(0.6), size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Kamera tidak tersedia',
                      style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _controller?.start();
                        setState(() {});
                      },
                      child: Text('Coba Lagi', style: GoogleFonts.inter(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
          // scan area overlay
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, color: Colors.white.withOpacity(0.3), size: 80),
                ],
              ),
            ),
          ),
          // instruction text
          Positioned(
            left: 32,
            right: 32,
            bottom: MediaQuery.of(context).size.height * 0.15,
            child: Text(
              'Arahkan kamera ke QR Code di meja\nuntuk mulai memesan',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          // flash toggle
          Positioned(
            right: 20,
            bottom: MediaQuery.of(context).size.height * 0.15,
            child: IconButton(
              icon: const Icon(Icons.flashlight_on, color: Colors.white, size: 28),
              onPressed: () => _controller?.toggleTorch(),
            ),
          ),
        ],
      ),
    );
  }
}
