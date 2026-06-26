class OrderItem {
  final String? id;
  final String? orderId;
  final String menuId;
  final String menuName;
  final int quantity;
  final int pricePerItem;
  final int subtotal;

  OrderItem({
    this.id,
    this.orderId,
    this.menuId = '',
    required this.menuName,
    required this.quantity,
    required this.pricePerItem,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      'menu_id': menuId,
      'menu_name': menuName,
      'quantity': quantity,
      'price_per_item': pricePerItem,
      'subtotal': subtotal,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id']?.toString(),
      orderId: map['order_id']?.toString(),
      menuId: map['menu_id'] ?? '',
      menuName: map['menu_name'] ?? '',
      quantity: map['quantity'] ?? 0,
      pricePerItem: map['price_per_item'] ?? 0,
      subtotal: map['subtotal'] ?? 0,
    );
  }
}

class Order {
  final String? id;
  final String orderNumber;
  final String? customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final List<OrderItem> items;
  final int totalAmount;
  final String paymentMethod;
  final String status;
  final String tableNumber;
  final DateTime? createdAt;

  Order({
    this.id,
    this.orderNumber = '',
    this.customerId,
    this.customerName = '',
    this.customerEmail = '',
    this.customerPhone = '',
    this.items = const [],
    required this.totalAmount,
    this.paymentMethod = 'E-Wallet',
    this.status = 'Diproses',
    this.tableNumber = '',
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'order_number': orderNumber,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'status': status,
      'table_number': tableNumber,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toString(),
      orderNumber: map['order_number'] ?? '',
      customerId: map['customer_id']?.toString(),
      customerName: map['customer_name'] ?? '',
      customerEmail: map['customer_email'] ?? '',
      customerPhone: map['customer_phone'] ?? '',
      items: (map['order_items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: map['total_amount'] ?? 0,
      paymentMethod: map['payment_method'] ?? 'E-Wallet',
      status: map['status'] ?? 'Diproses',
      tableNumber: map['table_number'] ?? '',
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at'] as String) : null,
    );
  }

  Order copyWith({String? status}) {
    return Order(
      id: id,
      orderNumber: orderNumber,
      customerId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      items: items,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      status: status ?? this.status,
      tableNumber: tableNumber,
      createdAt: createdAt,
    );
  }

  Order copyWithItems(List<OrderItem> newItems) {
    return Order(
      id: id,
      orderNumber: orderNumber,
      customerId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      items: newItems,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      status: status,
      tableNumber: tableNumber,
      createdAt: createdAt,
    );
  }
}
