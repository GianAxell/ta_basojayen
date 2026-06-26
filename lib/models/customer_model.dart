class Customer {
  final String? id;
  final String name;
  final String email;
  final String phone;

  Customer({this.id, required this.name, required this.email, this.phone = ''});

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'phone': phone,
  };

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
    id: map['id']?.toString(),
    name: map['name'] ?? '',
    email: map['email'] ?? '',
    phone: map['phone'] ?? '',
  );
}
