class MenuData {
  final String? id;
  final String imagePath;
  final String name;
  final String desc;
  final String price;
  final int priceValue;
  int quantity;
  final bool isActive;

  MenuData({
    this.id,
    required this.imagePath,
    required this.name,
    required this.desc,
    required this.price,
    required this.priceValue,
    this.quantity = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'image_path': imagePath,
      'name': name,
      'description': desc,
      'price': price,
      'price_value': priceValue,
      'is_active': isActive,
    };
  }

  factory MenuData.fromMap(Map<String, dynamic> map) {
    return MenuData(
      id: map['id']?.toString(),
      imagePath: map['image_path'] ?? 'assets/images/paket_a.png',
      name: map['name'] ?? '',
      desc: map['description'] ?? '',
      price: map['price'] ?? 'Rp. 0',
      priceValue: map['price_value'] ?? 0,
      isActive: map['is_active'] ?? true,
    );
  }

  MenuData copyWith({
    String? id,
    String? imagePath,
    String? name,
    String? desc,
    String? price,
    int? priceValue,
    int? quantity,
    bool? isActive,
  }) {
    return MenuData(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      price: price ?? this.price,
      priceValue: priceValue ?? this.priceValue,
      quantity: quantity ?? this.quantity,
      isActive: isActive ?? this.isActive,
    );
  }
}
