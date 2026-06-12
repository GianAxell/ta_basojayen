import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  // 'Menu' yang aktif di halaman ini
  String currentActiveMenu = 'Menu';

  // Data dummy admin
  final List<Map<String, dynamic>> adminMenuItems = [
    {'image': 'assets/images/paket_a.png', 'name': 'Paket A', 'price': '10.000', 'isActive': true},
    {'image': 'assets/images/paket_b.png', 'name': 'Paket B', 'price': '10.000', 'isActive': true},
    {'image': 'assets/images/paket_c.png', 'name': 'Paket C', 'price': '10.000', 'isActive': true},
    {'image': 'assets/images/paket_d.png', 'name': 'Paket D', 'price': '17.000', 'isActive': true},
    {'image': 'assets/images/paket_e.png', 'name': 'Paket E', 'price': '10.000', 'isActive': false},
    {'image': 'assets/images/paket_f.png', 'name': 'Paket F', 'price': '10.000', 'isActive': false},
    {'image': 'assets/images/paket_g.png', 'name': 'Paket G', 'price': '10.000', 'isActive': true},
    {'image': 'assets/images/paket_h.png', 'name': 'Paket H', 'price': '10.000', 'isActive': true},
    {'image': 'assets/images/paket_i.png', 'name': 'Paket I', 'price': '10.000', 'isActive': true},
    {'image': 'assets/images/paket_j.png', 'name': 'Paket J', 'price': '15.000', 'isActive': true},
  ];

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
                            width: 24, height: 24, color: Colors.white,
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.restaurant, color: Colors.white, size: 22),
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
                        const SizedBox(width: 50), 
                        Expanded(flex: 3, child: Text('Nama menu', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13))),
                        Expanded(flex: 2, child: Text('Harga', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13))),
                        Expanded(flex: 2, child: Text('Status', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13))),
                        Expanded(flex: 2, child: Center(child: Text('Aksi', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)))),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: adminMenuItems.length,
                    itemBuilder: (context, index) {
                      final item = adminMenuItems[index];
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                              child: ClipOval(
                                  child: Image.asset(
                                    item['image'], fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, color: Colors.grey),
                                  ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            
                            Expanded(flex: 3, child: Text(item['name'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500))),
                            Expanded(flex: 2, child: Text(item['price'], style: GoogleFonts.inter(fontSize: 14))),
                            
                            // Status Badge
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    item['isActive'] = !item['isActive'];
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: item['isActive'] ? const Color(0xFFFFF59D) : const Color(0xFFFF8A80), 
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item['isActive'] ? 'Aktif' : 'Nonaktif',
                                      style: GoogleFonts.inter(
                                        fontSize: 11, fontWeight: FontWeight.bold,
                                        color: item['isActive'] ? Colors.amber[900] : const Color(0xFFB71C1C),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Tombol Aksi
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => _showEditDialog(context, item),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                                      child: const Icon(Icons.edit_outlined, size: 20, color: Colors.black87),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _showDeleteDialog(context, item['name'], index),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                                      child: const Icon(Icons.delete_outline, size: 20, color: Colors.black87),
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
          onSave: (name, price, status) {
            setState(() {
              adminMenuItems.add({
                'image': 'assets/images/paket_a.png', 
                'name': name,
                'price': price,
                'isActive': (status == 'Aktif'),
              });
            });
          },
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return EditMenuDialog(
          item: item,
          onSave: (newName, newPrice, newStatus) {
            setState(() {
              item['name'] = newName;
              item['price'] = newPrice;
              item['isActive'] = (newStatus == 'Aktif');
            });
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String menuName, int index) {
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
                        onPressed: () {
                          setState(() {
                            adminMenuItems.removeAt(index);
                          });
                          Navigator.pop(context);
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
  final Function(String name, String price, String status) onSave;
  const AddMenuDialog({super.key, required this.onSave});
  @override
  State<AddMenuDialog> createState() => _AddMenuDialogState();
}
class _AddMenuDialogState extends State<AddMenuDialog> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  String currentStatus = 'Aktif';
  @override
  void dispose() { nameController.dispose(); priceController.dispose(); super.dispose(); }
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(width: 75, height: 75, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white30), child: const Icon(Icons.fastfood, color: Colors.white, size: 32)),
                  Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, color: Color(0xFF901B1E), size: 16))),
                ],
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
            Text('Harga', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(controller: priceController, keyboardType: TextInputType.number, style: GoogleFonts.inter(color: Colors.black), decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12), hintText: 'Contoh: 15.000', hintStyle: TextStyle(fontSize: 13, color: Colors.grey))),
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
                Expanded(child: ElevatedButton(onPressed: () { if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) { widget.onSave(nameController.text, priceController.text, currentStatus); } Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text('Simpan', style: GoogleFonts.inter(fontWeight: FontWeight.bold)))),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EditMenuDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function(String name, String price, String status) onSave;
  const EditMenuDialog({super.key, required this.item, required this.onSave});
  @override
  State<EditMenuDialog> createState() => _EditMenuDialogState();
}
class _EditMenuDialogState extends State<EditMenuDialog> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late String currentStatus;
  @override
  void initState() { super.initState(); nameController = TextEditingController(text: widget.item['name']); priceController = TextEditingController(text: widget.item['price']); currentStatus = widget.item['isActive'] ? 'Aktif' : 'Nonaktif'; }
  @override
  void dispose() { nameController.dispose(); priceController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF901B1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit menu', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  ClipOval(child: Image.asset(widget.item['image'], width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, color: Colors.grey))),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.item['name'], style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)), Text('Makanan - $currentStatus', style: GoogleFonts.inter(color: Colors.grey, fontSize: 11))])
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Nama menu', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: TextField(controller: nameController, style: GoogleFonts.inter(color: Colors.black))),
            const SizedBox(height: 12),
            Text('Harga', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: TextField(controller: priceController, style: GoogleFonts.inter(color: Colors.black))),
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
                Expanded(child: ElevatedButton(onPressed: () { widget.onSave(nameController.text, priceController.text, currentStatus); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text('Simpan', style: GoogleFonts.inter(fontWeight: FontWeight.bold)))),
              ],
            )
          ],
        ),
      ),
    );
  }
}