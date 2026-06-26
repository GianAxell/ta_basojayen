import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/menu_model.dart';
import '../../services/menu_service.dart';
import '../../widgets/menu_image.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  String currentActiveMenu = 'Menu';
  final MenuService _menuService = MenuService();
  final TextEditingController _searchController = TextEditingController();
  List<MenuData> _menuItems = [];
  bool _isLoading = true;
  String _searchQuery = '';

  List<MenuData> get _filteredMenuItems {
    if (_searchQuery.isEmpty) return _menuItems;
    return _menuItems.where((item) =>
      item.name.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
    _menuService.getMenuStream().listen(
      (items) {
        if (mounted) {
          setState(() {
            _menuItems = items;
            _isLoading = false;
          });
        }
      },
      onError: (_) {
        if (mounted) {
          setState(() => _isLoading = false);
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
        backgroundColor: const Color(0xFF901B1E),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'Menu',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      // sidebar drawer navigasi
      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
          color: const Color(0xFF901B1E), // Warna merah marun penuh
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Sidebar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo_jayen.png',
                            width: 50, height: 50, color: Colors.white,
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.restaurant, color: Colors.white, size: 34),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'Baso Jayen',
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 26),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Items Navigasi Samping
              _buildSidebarItem(
                icon: Icons.grid_view_rounded,
                title: 'Dashboard',
                isActive: currentActiveMenu == 'Dashboard',
                onTap: () {
                  setState(() => currentActiveMenu = 'Dashboard');
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/admin-dashboard'); // Balik ke dashboard
                },
              ),
              _buildSidebarItem(
                icon: Icons.restaurant_menu_rounded,
                title: 'Menu',
                isActive: currentActiveMenu == 'Menu',
                onTap: () {
                  setState(() => currentActiveMenu = 'Menu');
                  Navigator.pop(context);
                },
              ),
              
              // Item Navigasi Pesanan Masuk
              _buildSidebarItem(
                icon: Icons.menu_book_rounded,
                title: 'Pesanan Masuk',
                isActive: currentActiveMenu == 'Pesanan Masuk',
                onTap: () {
                  setState(() => currentActiveMenu = 'Pesanan Masuk');
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/pesanan-masuk'); // Lempar navigasi ke halaman list order kasir
                },
              ),

              _buildSidebarItem(
                icon: Icons.shopping_cart_outlined,
                title: 'Pemesanan Pelanggan',
                isActive: currentActiveMenu == 'Pemesanan Pelanggan',
                onTap: () {
                  setState(() => currentActiveMenu = 'Pemesanan Pelanggan');
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/pemesanan-pelanggan');
                },
              ),

              _buildSidebarItem(
                icon: Icons.qr_code,
                title: 'QR Code Meja',
                isActive: currentActiveMenu == 'QR Code Meja',
                onTap: () {
                  setState(() => currentActiveMenu = 'QR Code Meja');
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/qr-table');
                },
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildSidebarItem(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  isActive: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/menu');
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Body utama
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Cari Menu & Tombol Tambah Menu
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari menu...',
                        hintStyle: GoogleFonts.inter(color: Colors.black54, fontSize: 14),
                        icon: const Icon(Icons.search, color: Colors.black54, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(bottom: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                ElevatedButton(
                  onPressed: () => _showAddDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    elevation: 0,
                  ),
                  child: Text(
                    '+ Tambah menu',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tabel Menu
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDBDBDB).withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      children: [
                        const SizedBox(width: 40), 
                        Expanded(flex: 4, child: Text('Nama menu', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13))),
                        Expanded(flex: 2, child: Text('Harga', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13))),
                        Expanded(flex: 2, child: Text('Status', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13))),
                        Expanded(flex: 3, child: Center(child: Text('Aksi', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)))),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),

                  if (_isLoading)
                    const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()))
                  else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredMenuItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredMenuItems[index];
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Row(
                          children: [
                            MenuImage(imagePath: item.imagePath, size: 36),
                            const SizedBox(width: 8),
                            
                            Expanded(flex: 4, child: Text(item.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                            Expanded(flex: 2, child: Text(NumberFormat('#,##0', 'id_ID').format(item.priceValue), style: GoogleFonts.inter(fontSize: 14))),
                            
                            // Status Badge
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  _menuService.toggleActive(item.id!, !item.isActive);
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: item.isActive ? const Color(0xFFFFF59D) : const Color(0xFFFF8A80), 
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item.isActive ? 'Aktif' : 'Nonaktif',
                                      style: GoogleFonts.inter(
                                        fontSize: 10, fontWeight: FontWeight.bold,
                                        color: item.isActive ? Colors.amber[900] : const Color(0xFFB71C1C),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Tombol Aksi
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => _showEditDialog(context, item),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                                      child: const Icon(Icons.edit_outlined, size: 18, color: Colors.black87),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => _showDeleteDialog(context, item.name, index),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                                      child: const Icon(Icons.delete_outline, size: 18, color: Colors.black87),
                                    ),
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem({required IconData icon, required String title, required bool isActive, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: isActive ? Colors.white.withOpacity(0.12) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 16),
            Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddMenuDialog(
          menuService: _menuService,
          onSave: (name, price, desc, status, imagePath) async {
            try {
              await _menuService.addMenu(MenuData(
                imagePath: imagePath,
                name: name,
                desc: desc,
                price: 'Rp. ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(price.replaceAll('.', '')) ?? 0)}',
                priceValue: int.tryParse(price.replaceAll('.', '')) ?? 0,
                isActive: status == 'Aktif',
              ));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal menambahkan menu: ${e.toString().replaceFirst('Exception: ', '')}'), backgroundColor: Colors.red),
              );
            }
          },
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, MenuData item) {
    showDialog(
      context: context,
      builder: (context) {
        return EditMenuDialog(
          item: item,
          menuService: _menuService,
          onSave: (newName, newPrice, newDesc, newStatus, newImagePath) async {
            try {
              await _menuService.updateMenu(item.id!, item.copyWith(
                imagePath: newImagePath,
                name: newName,
                desc: newDesc,
                price: 'Rp. ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(newPrice.replaceAll('.', '')) ?? 0)}',
                priceValue: int.tryParse(newPrice.replaceAll('.', '')) ?? 0,
                isActive: newStatus == 'Aktif',
              ));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal mengupdate menu: ${e.toString().replaceFirst('Exception: ', '')}'), backgroundColor: Colors.red),
              );
            }
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String menuName, int index) {
    final item = _menuItems[index];
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF901B1E), 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.delete_outline, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 16),
                Text('Hapus menu?', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Kamu yakin mau hapus $menuName?\nData tidak bisa dikembalikan.', textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 13)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF5350), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: Text('Batal', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await _menuService.deleteMenu(item.id!);
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Gagal menghapus menu: ${e.toString().replaceFirst('Exception: ', '')}'), backgroundColor: Colors.red),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF5350), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: Text('Ya, Hapus', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddMenuDialog extends StatefulWidget {
  final MenuService menuService;
  final Function(String name, String price, String desc, String status, String imagePath) onSave;
  const AddMenuDialog({super.key, required this.menuService, required this.onSave});
  @override
  State<AddMenuDialog> createState() => _AddMenuDialogState();
}
class _AddMenuDialogState extends State<AddMenuDialog> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  String currentStatus = 'Aktif';
  XFile? _imageFile;
  bool _isUploading = false;

  @override
  void dispose() { nameController.dispose(); priceController.dispose(); descController.dispose(); super.dispose(); }

  Future<void> _pickImage() async {
    final file = await widget.menuService.pickImage();
    if (file != null) {
      setState(() => _imageFile = file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF901B1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tambah menu', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_imageFile != null)
                      ClipOval(
                        child: kIsWeb
                            ? Image.network(_imageFile!.path, width: 75, height: 75, fit: BoxFit.cover)
                            : Image.file(File(_imageFile!.path), width: 75, height: 75, fit: BoxFit.cover),
                      )
                    else
                      Container(width: 75, height: 75, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white30), child: const Icon(Icons.fastfood, color: Colors.white, size: 32)),
                    Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, color: Color(0xFF901B1E), size: 16))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Nama menu', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(controller: nameController, style: GoogleFonts.inter(color: Colors.black), decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12), hintText: 'Masukkan nama paket...', hintStyle: TextStyle(fontSize: 13, color: Colors.grey))),
            ),
            const SizedBox(height: 12),
            Text('Isi Paket', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: descController,
                maxLines: 3,
                style: GoogleFonts.inter(color: Colors.black, fontSize: 13),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                  hintText: 'Contoh: Mie, Baso urat, Baso daging,...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Harga (angka saja)', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(controller: priceController, keyboardType: TextInputType.number, style: GoogleFonts.inter(color: Colors.black), decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12), hintText: 'Contoh: 15000', hintStyle: TextStyle(fontSize: 13, color: Colors.grey))),
            ),
            const SizedBox(height: 12),
            Text('Status', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentStatus, isExpanded: true, icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  items: ['Aktif', 'Nonaktif'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value, style: GoogleFonts.inter(color: Colors.black)))).toList(),
                  onChanged: (newValue) => setState(() => currentStatus = newValue!),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text('Batal', style: GoogleFonts.inter(fontWeight: FontWeight.bold)))),
                const SizedBox(width: 12),
                Expanded(
                  child: _isUploading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isEmpty || priceController.text.isEmpty) return;
                            if (_imageFile == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pilih gambar terlebih dahulu'), backgroundColor: Colors.red),
                              );
                              return;
                            }
                            setState(() => _isUploading = true);
                            try {
                              final url = await widget.menuService.uploadImage(_imageFile!);
                              widget.onSave(nameController.text, priceController.text, descController.text, currentStatus, url);
                              if (mounted) Navigator.pop(context);
                            } catch (e) {
                              if (mounted) {
                                setState(() => _isUploading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${e.toString().replaceFirst('Exception: ', '')}'), backgroundColor: Colors.red),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: Text('Simpan', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EditMenuDialog extends StatefulWidget {
  final MenuData item;
  final MenuService menuService;
  final Function(String name, String price, String desc, String status, String imagePath) onSave;
  const EditMenuDialog({super.key, required this.item, required this.menuService, required this.onSave});
  @override
  State<EditMenuDialog> createState() => _EditMenuDialogState();
}
class _EditMenuDialogState extends State<EditMenuDialog> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descController;
  late String currentStatus;
  XFile? _imageFile;
  bool _isUploading = false;

  @override
  void initState() { super.initState(); nameController = TextEditingController(text: widget.item.name); priceController = TextEditingController(text: widget.item.priceValue.toString()); descController = TextEditingController(text: widget.item.desc); currentStatus = widget.item.isActive ? 'Aktif' : 'Nonaktif'; }
  @override
  void dispose() { nameController.dispose(); priceController.dispose(); descController.dispose(); super.dispose(); }

  Future<void> _pickImage() async {
    final file = await widget.menuService.pickImage();
    if (file != null) {
      setState(() => _imageFile = file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = _imageFile != null
        ? (kIsWeb
            ? Image.network(_imageFile!.path, width: 40, height: 40, fit: BoxFit.cover)
            : Image.file(File(_imageFile!.path), width: 40, height: 40, fit: BoxFit.cover))
        : MenuImage(imagePath: widget.item.imagePath, size: 40);
    return Dialog(
      backgroundColor: const Color(0xFF901B1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit menu', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipOval(child: displayImage),
                        Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Color(0xFF901B1E), shape: BoxShape.circle), child: const Icon(Icons.camera_alt, color: Colors.white, size: 12))),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.item.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)), Text('Makanan - $currentStatus', style: GoogleFonts.inter(color: Colors.grey, fontSize: 11))])
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Nama menu', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: TextField(controller: nameController, style: GoogleFonts.inter(color: Colors.black))),
            const SizedBox(height: 12),
            Text('Isi Paket', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: descController,
                maxLines: 3,
                style: GoogleFonts.inter(color: Colors.black, fontSize: 13),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                  hintText: 'Contoh: Mie, Baso urat, Baso daging,...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Harga (angka)', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: TextField(controller: priceController, keyboardType: TextInputType.number, style: GoogleFonts.inter(color: Colors.black))),
            const SizedBox(height: 12),
            Text('Status', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentStatus, isExpanded: true, icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  items: ['Aktif', 'Nonaktif'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value, style: GoogleFonts.inter(color: Colors.black)))).toList(),
                  onChanged: (newValue) => setState(() => currentStatus = newValue!),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text('Batal', style: GoogleFonts.inter(fontWeight: FontWeight.bold)))),
                const SizedBox(width: 12),
                Expanded(
                  child: _isUploading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isEmpty || priceController.text.isEmpty) return;
                            setState(() => _isUploading = true);
                            try {
                              String imagePath = widget.item.imagePath;
                              if (_imageFile != null) {
                                imagePath = await widget.menuService.uploadImage(_imageFile!);
                              }
                              widget.onSave(nameController.text, priceController.text, descController.text, currentStatus, imagePath);
                              if (mounted) Navigator.pop(context);
                            } catch (e) {
                              if (mounted) {
                                setState(() => _isUploading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${e.toString().replaceFirst('Exception: ', '')}'), backgroundColor: Colors.red),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: Text('Simpan', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}