# Baso Jayen - POS Aplikasi

Aplikasi **Point of Sale (POS)** untuk restoran Baso Jayen berbasis Flutter dengan backend Supabase.

📥 **[Download APK v1.0.0](https://github.com/GianAxell/ta_basojayen/releases/latest)**

## Fitur

### User (Pelanggan)
- Scan QR Code meja untuk memulai pemesanan
- Lihat daftar menu & paket (search by nama/deskripsi)
- Keranjang belanja
- Checkout dengan data diri
- Pembayaran (simulasi — E-Wallet / Transfer Bank)

### Admin
- **Dashboard:** Ringkasan penjualan harian, jumlah pesanan
- **Menu:** CRUD menu + upload gambar + search
- **Pesanan Masuk:** Kelola status pesanan (Diproses → Selesai → Kosongkan Meja)
- **Pemesanan Pelanggan:** Buat pesanan manual + pilih meja
- **QR Code Meja:** Tampilkan & download QR code per meja
- **Pencatatan Tunai:** Catat transaksi tunai

## Tech Stack

| Komponen | Teknologi |
|----------|-----------|
| Frontend | Flutter (Dart) — target Web & Android |
| Backend | Supabase (PostgreSQL, Realtime, Storage) |
| QR Scanner | mobile_scanner v7 |
| Image Upload | Supabase Storage |
| State Management | setState |
| Payment Gateway | Tidak ada — simulasi UI saja |

## Cara Install

### Prasyarat
- Flutter SDK (Dart ^3.12.0)
- Android SDK
- Koneksi internet (untuk Supabase)

### Langkah-langkah

1. Clone repositori:
   ```bash
   git clone https://github.com/GianAxell/ta_basojayen.git
   cd ta_basojayen
   ```

2. Setup konfigurasi Supabase:
   - Edit `lib/config.dart`
   - Isi `supabaseUrl` dan `supabaseAnonKey` dari project Supabase kamu

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Build APK:
   ```bash
   $env:GRADLE_USER_HOME="D:\gradle-cache"   # opsional, jika space C terbatas
   flutter build apk --debug
   ```

5. Hasil build ada di:
   ```
   build\app\outputs\flutter-apk\app-debug.apk
   ```
   File bisa di-rename bebas (misal `basojayen.apk`) tanpa mempengaruhi nama aplikasi di HP.

## Struktur Proyek

```
lib/
├── main.dart                     # Entry point + routing
├── config.dart                   # Config Supabase
├── models/
│   └── menu_model.dart           # Model Menu
│   └── order_model.dart          # Model Order
├── services/
│   ├── supabase_service.dart     # Koneksi Supabase
│   ├── menu_service.dart         # CRUD menu
│   ├── order_service.dart        # CRUD order
│   └── customer_service.dart     # CRUD customer
├── screens/
│   ├── splash_screen.dart        # Splash + auto-redirect
│   ├── scan_qr_screen.dart       # Scan QR meja
│   ├── users/                    # Halaman pelanggan
│   │   ├── menu_list_screen.dart
│   │   ├── screen_keranjang.dart
│   │   ├── screen_data_diri.dart
│   │   ├── screen_pembayaran.dart
│   │   └── screen_status_pesanan.dart
│   └── admin/                    # Halaman admin
│       ├── dashboard_screen.dart
│       ├── menu_screen.dart
│       ├── login_screen.dart
│       ├── pesanan_masuk.dart
│       ├── pemesanan_pelanggan.dart
│       ├── qr_table_screen.dart
│       └── pencatatan_tunai.dart
├── utils/
│   ├── qr_download_native.dart   # Download QR (native/Android)
│   └── qr_download_web.dart      # Download QR (web)
└── widgets/
    └── menu_image.dart           # Widget gambar menu
```

## Catatan Build

| Perintah | Keterangan |
|----------|------------|
| `flutter build apk --debug` | Build APK debug (kamera berfungsi) |
| `flutter build apk` | Build APK release (butuh proguard rules jika mobile_scanner error) |
| `$env:GRADLE_USER_HOME="D:\gradle-cache"` | Pindah cache Gradle ke D drive jika space C terbatas |

## Credits

- **Dosen:** Ade Sutedi, S.T., M.Kom.
