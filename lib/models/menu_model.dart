class MenuData {
  final String imagePath;
  final String name;
  final String desc;
  final String price;
  final int priceValue;
  int quantity; // Menampung jumlah porsi yang dipesan pelanggan

  MenuData({
    required this.imagePath,
    required this.name,
    required this.desc,
    required this.price,
    required this.priceValue,
    this.quantity = 0, // Default awal adalah 0 porsi saat aplikasi dibuka
  });
}