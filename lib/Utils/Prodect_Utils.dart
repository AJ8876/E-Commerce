
  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopify/Product_model.dart';

Product productFromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return Product(
    id: doc.id,
    name: data['name'] ?? '',
    price: (data['price'] ?? 0).toDouble(),
    discountPrice: data['discountPrice'] !=null? (data['discountPrice'] as num).toDouble():
    null,
    sku: data['sku'] ?? '',
    category: data['category'] ?? '',
    subCategory: data['subcategory'] ?? '',
    stock: data['stock'] ?? 0,
    weight: (data['weight'] ?? 0).toDouble(),
    condition: data['condition'] ?? '',
    isAvailable: data['isAvailable'] ?? true,
    isFeatured: data['isFeatured'] ?? false,
    description: data['description'] ?? '',
    images: List<String>.from(data['images'] ?? []),
  );

}