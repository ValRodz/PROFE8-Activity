class Product {
  final int id;
  final int sellerId;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final int stock;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.stock,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      sellerId: json['seller_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: double.parse(json['price'].toString()),
      imageUrl: json['image_url'] as String?,
      stock: json['stock'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_id': sellerId,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'stock': stock,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
