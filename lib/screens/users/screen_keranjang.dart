import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/menu_model.dart'; // Menghubungkan ke file model data eksternal
import 'screen_pembayaran.dart'; 
import 'screen_data_diri.dart';

class ScreenKeranjang extends StatefulWidget {
  final List<MenuData> selectedItems; 
  const ScreenKeranjang({super.key, required this.selectedItems});

  @override
  State<ScreenKeranjang> createState() => _ScreenKeranjangState();
}

class _ScreenKeranjangState extends State<ScreenKeranjang> {
  
  // Fungsi untuk menambah atau mengurangi kuantitas item
  void _updateQty(int index, int delta) {
    setState(() {
      widget.selectedItems[index].quantity += delta;
      if (widget.selectedItems[index].quantity < 1) widget.selectedItems[index].quantity = 1;
    });
  }

  // Fungsi untuk menghapus item dari list keranjang belanja
  void _removeItem(int index) {
    setState(() {
      widget.selectedItems[index].quantity = 0; 
      widget.selectedItems.removeAt(index);     
    });
  }

  // Menghitung subtotal
  int get subtotal {
    return widget.selectedItems.fold(0, (sum, item) => sum + (item.priceValue * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF901B1E),
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol back default bawaan scaffold
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Keranjang',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // daftar produk yang dipesan
          widget.selectedItems.isEmpty 
            ? Expanded(
                child: Center(
                  child: Text('Belum ada pesanan.', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey)),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.selectedItems[index];
                    return _buildCartCard(index, item);
                  },
                ),
              ),

          // ringkasan pesanan
          if (widget.selectedItems.isNotEmpty) _buildSummarySection(),
        ],
      ),
    );
  }

  // Kartu Produk di Keranjang
  Widget _buildCartCard(int index, MenuData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF901B1E), 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 85,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0), 
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: Image.asset(item.imagePath, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name, 
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _removeItem(index),
                      child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.desc,
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withOpacity(0.8)),
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  item.price, 
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)
                ),
                const SizedBox(height: 4),
                
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _qtyActionBtn(Icons.remove, () => _updateQty(index, -1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '${item.quantity}', 
                            style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)
                          ),
                        ),
                        _qtyActionBtn(Icons.add, () => _updateQty(index, 1)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyActionBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Color(0xFF901B1E), 
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 12, color: Colors.white), 
      ),
    );
  }

  // Ringkasan Pesanan
  Widget _buildSummarySection() {
    double listHeight = widget.selectedItems.length > 3 
        ? 72.0 
        : (widget.selectedItems.length * 24.0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF901B1E), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Pesanan', 
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)
          ),
          const SizedBox(height: 12),
          
          SizedBox(
            height: listHeight,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.selectedItems.length,
              itemBuilder: (context, index) {
                final item = widget.selectedItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.name} ${item.quantity}x', 
                        style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 14)
                      ),
                      Text(
                        'Rp. ${item.priceValue * item.quantity}', 
                        style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 14)
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const Divider(height: 20, thickness: 1, color: Colors.white), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              Text('Rp. $subtotal', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 20),
          
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerDataScreen(totalAmount: subtotal),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, 
              foregroundColor: Colors.black, 
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 0,
            ),
            child: Text(
              'Lanjutkan Pembayaran', 
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)
            ),
          ),
        ],
      ),
    );
  }
}