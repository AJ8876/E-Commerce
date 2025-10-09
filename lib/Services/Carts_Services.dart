import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopify/Product_model.dart';

class Carts_Services {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all cart products for a specific user
  Stream<List<Product>> GetCartProducts(String userId) {
    return _firestore
        .collection("Users")
        .doc(userId)
        .collection("Cart")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Add product to cart
  Future<void> addToCart(String userId, Product product) async {
    await _firestore
        .collection('Users')
        .doc(userId) // 👉 ab wahi userId use karo jo stream me hai
        .collection('Cart')
        .doc(product.id)
        .set(product.toMap());

    // print("Added successfully!");
  }

  /// Remove product from cart
  Future<void> removeFromCart(String userId, String productId) async {
    await _firestore
        .collection('Users')
        .doc(userId) // ✅ correct user ke andar se delete
        .collection('Cart')
        .doc(productId)
        .delete();
  }
  Future<void> clearCart(String userId) async {
    try {
      // Access the correct path under Users → userId → Cart
      var snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("Cart")
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      print("Cart cleared successfully for user: $userId");
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }
}