import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/menu_model.dart';
import '../../services/menu_service.dart';
import '../../widgets/menu_image.dart';
import 'screen_keranjang.dart';

class MenuListScreen extends StatefulWidget {
  final String tableNumber;
  const MenuListScreen({super.key, this.tableNumber = ''});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  final MenuService _menuService = MenuService();
  final TextEditingController _searchController = TextEditingController();
  List<MenuData> _menuItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  int get totalCartItems {
    return _menuItems.fold(0, (sum, item) => sum + item.quantity);
  }

  List<MenuData> get _filteredMenuItems {
    if (_searchQuery.isEmpty) return _menuItems;
    return _menuItems.where((item) =>
      item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      item.desc.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
    _menuService.getActiveMenuStream().listen(
      (items) {
        if (mounted) {
          setState(() {
            _menuItems = items;
            _isLoading = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Gagal memuat menu: ${error.toString()}';
          });
        }
      },
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF901B1E)))
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, color: Color(0xFF901B1E), size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal Memuat Menu',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                        });
                        _menuService.getActiveMenuStream().listen(
                          (items) {
                            if (mounted) {
                              setState(() {
                                _menuItems = items;
                                _isLoading = false;
                              });
                            }
                          },
                          onError: (error) {
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                                _errorMessage = 'Gagal memuat menu: ${error.toString()}';
                              });
                            }
                          },
                          cancelOnError: true,
                        );
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: Text('Coba Lagi', style: GoogleFonts.inter(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF901B1E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _menuItems.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.restaurant_menu, color: Colors.grey, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Belum Ada Menu Tersedia',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Menu belum ditambahkan oleh admin.\nSilakan cek kembali nanti.',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tableNumber.isNotEmpty
                      ? 'Selamat datang di Baso Jayen - Meja ${widget.tableNumber}'
                      : 'Selamat datang di Baso Jayen',
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
                    controller: _searchController,
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
                if (_searchQuery.isNotEmpty && _filteredMenuItems.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.search_off, color: Colors.grey, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Menu "$_searchQuery" tidak ditemukan',
                            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredMenuItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.63,
                    ),
                    itemBuilder: (context, index) {
                      final item = _filteredMenuItems[index];
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
                              child: MenuImage(imagePath: item.imagePath, size: 95),
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
    List<MenuData> selectedMenus = _menuItems.where((item) => item.quantity > 0).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenKeranjang(selectedItems: selectedMenus, tableNumber: widget.tableNumber),
      ),
    ).then((_) {
      setState(() {
        for (final item in _menuItems) {
          item.quantity = 0;
        }
      });
    });
  }
}