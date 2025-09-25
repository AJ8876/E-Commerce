class Product {
  final String id;
  final String name;
  final double price;
  final double? discountPrice;
  final double sku;
  final String category;
  final String subCategory;
  final int stock;
  final double weight;
  final String condition;
  final bool isAvailable;
  final bool isFeatured;
  final String description;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.discountPrice,
    required this.sku,
    required this.category,
    required this.subCategory,
    required this.stock,
    required this.weight,
    required this.condition,
    required this.isAvailable,
    required this.isFeatured,
    required this.description,
    required this.images,
  });

  factory Product.fromMap(Map<String, dynamic> data, String docId) {
    return Product(
      id: docId,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      discountPrice: data['discountPrice'] != null
          ? (data['discountPrice'] as num).toDouble()
          : null,
      sku: (data['sku'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      subCategory: data['subCategory'] ?? '',
      stock: (data['stock'] ?? 0).toInt(),
      weight: (data['weight'] ?? 0).toDouble(),
      condition: data['condition'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
      isFeatured: data['isFeatured'] ?? false,
      description: data['description'] ?? '',
      images: List<String>.from(data['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'discountPrice': discountPrice,
      'sku': sku,
      'category': category,
      'subCategory': subCategory,
      'stock': stock,
      'weight': weight,
      'condition': condition,
      'isAvailable': isAvailable,
      'isFeatured': isFeatured,
      'description': description,
      'images': images,
    };
  }
}