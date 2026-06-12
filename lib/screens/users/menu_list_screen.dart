import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/menu_model.dart';
import 'screen_keranjang.dart';

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  // Data lengkap dari Paket A sampai Paket J
  final List<MenuData> menuItems = [
    MenuData(
      imagePath: 'assets/images/paket_a.png',
      name: 'Paket A',
      desc: 'Mie, Baso urat, Baso daging, Baso tahu, Siomay',
      price: 'Rp. 10.000',
      priceValue: 10000,
    ),
    MenuData(
      imagePath: 'assets/images/paket_b.png',
      name: 'Paket B',
      desc: 'Mie, Baso daging, Baso tahu, Baso aci, Siomay',
      price: 'Rp. 10.000',
      priceValue: 10000,
    ),
    MenuData(
      imagePath: 'assets/images/paket_c.png',
      name: 'Paket C',
      desc: 'Baso daging, Baso urat, Baso Tahu...',
      price: 'Rp. 10.000',
      priceValue: 10000,
    ),
    MenuData(
      imagePath: 'assets/images/paket_d.png',
      name: 'Paket D',
      desc: 'Baso telor, Baso daging, Baso...eker',
      price: 'Rp. 10.000',
      priceValue: 10000,
    ),
    MenuData(
      imagePath: 'assets/images/paket_e.png',
      name: 'Paket E',
      desc: 'Mie, Baso jumbo isi daging, sayuran segar',
      price: 'Rp. 10.000',
      priceValue: 10000,
    ),
    MenuData(
      imagePath: 'assets/images/paket_f.png',
      name: 'Paket F',
      desc: 'Baso urat jumbo, tahu kulit, mi kuning',
      price: 'Rp. 10.000',
      priceValue: 10000,
    ),
    MenuData(
      imagePath: 'assets/images/paket_g.png',
      name: 'Paket G',
      desc: 'Kombinasi baso aci pedas dan siomay kering',
      price: 'Rp. 10.000',
      priceValue: 10000,
    ),
    MenuData(
      imagePath: 'assets/images/paket_h.png',
      name: 'Paket H',
      desc: 'Baso tahu super, siomay basah, mi bihun',
      price: 'Rp. 10.000',
      priceValue: 10000,
    ),
    MenuData(
      imagePath: 'assets/images/paket_i.png',
      name: 'Paket I',
      desc: 'Baso telur puyuh, baso halus, ceker ayam',
      price: 'Rp. 10.000',
      priceValue: 10000,
    ),
    MenuData(
      imagePath: 'assets/images/paket_j.png',
      name: 'Paket J',
      desc: 'Paket komplit porsi besar untuk pecinta baso urat',
      price: 'Rp. 10.000',
      priceValue: 10000,
    ),
  ];

  int get totalCartItems {
    return menuItems.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF901B1E), // Marun khas Jayen
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Daftar menu',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.normal),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white, size: 26),
            onPressed: () => Navigator.pushNamed(context, '/login-admin'),
          ),

          GestureDetector(
            onTap: _bukaHalamanKeranjang,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Image.asset(
                    'assets/images/keranjang.png',
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_basket, color: Colors.white, size: 26),
                  ),
                ),
                if (totalCartItems > 0)
                  Positioned(
                    right: 4,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$totalCartItems',
                        style: GoogleFonts.inter(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),

      // halaman utama
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang di Baso Jayen',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pilih hidangan favorit Anda\npesan dengan mudah.',
                  style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black, height: 1.2),
                ),
                const SizedBox(height: 16),

                // Bar Pencarian
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBDBDB).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari menu...',
                      hintStyle: GoogleFonts.inter(color: Colors.black54),
                      icon: const Icon(Icons.search, color: Colors.black54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Rekomendasi',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                ),
                const SizedBox(height: 16),

                // grid menu
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: menuItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.63,
                  ),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF901B1E),
                        border: Border.all(color: const Color(0xFF901B1E), width: 4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            color: Colors.white,
                            child: Center(
                              child: Container(
                                width: 95,
                                height: 95,
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                child: ClipOval(
                                  child: Image.asset(item.imagePath, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: Text(
                                      item.desc,
                                      style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 11),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.price,
                                    style: GoogleFonts.inter(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8),

                                  // tombol tambah / jumlah
                                  SizedBox(
                                    width: double.infinity,
                                    height: 32,
                                    child: item.quantity == 0
                                        ? ElevatedButton(
                                            onPressed: () => setState(() => item.quantity++),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              padding: EdgeInsets.zero,
                                            ),
                                            child: Text('Tambahkan', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: const Icon(Icons.remove, color: Color(0xFF901B1E), size: 16),
                                                  onPressed: () => setState(() => item.quantity--),
                                                ),
                                                Text(
                                                  '${item.quantity}',
                                                  style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                                                ),
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: const Icon(Icons.add, color: Color(0xFF901B1E), size: 16),
                                                  onPressed: () => setState(() => item.quantity++),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          if (totalCartItems > 0)
            Positioned(
              bottom: 20, left: 16, right: 16,
              child: ElevatedButton(
                onPressed: _bukaHalamanKeranjang,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F62C6),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: Text(
                  'Keranjang',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _bukaHalamanKeranjang() {
    List<MenuData> selectedMenus = menuItems.where((item) => item.quantity > 0).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenKeranjang(selectedItems: selectedMenus),
      ),
    ).then((_) => setState(() {}));
  }
}