class Order {
  final int id;
  final int buyerId;
  final double total;
  final String status; // pending, shipped, completed, cancelled
  final DateTime createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.buyerId,
    required this.total,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      buyerId: json['buyer_id'] is int
          ? json['buyer_id'] as int
          : int.parse(json['buyer_id'].toString()),
      total: double.parse(json['total'].toString()),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'total': total,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      orderId: json['order_id'] is int
          ? json['order_id'] as int
          : int.parse(json['order_id'].toString()),
      productId: json['product_id'] is int
          ? json['product_id'] as int
          : int.parse(json['product_id'].toString()),
      quantity: json['quantity'] is int
          ? json['quantity'] as int
          : int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
