import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopify/Dashboard_Screens/Detail_Product_Screen.dart';
import 'package:shopify/Global_List.dart';
import 'package:shopify/Product_model.dart';

class FavouriteScreen extends StatefulWidget {
  final String? productId;
  const FavouriteScreen({super.key, this.productId});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favourites"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection("Users")
                .doc(userId)
                .collection("Favourites")
                .snapshots(),
        builder: (context, SnapShot) {
          print("📥 Favourite snapshot: ${SnapShot.data!.docs.map((e) => e.data())}");
          if (SnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!SnapShot.hasData || SnapShot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Favourites Yet",
                style: TextStyle(color: Colors.black54, fontSize: 18),
              ),
            );
          }
           final products = SnapShot.data!.docs.map((doc){
             return Product.fromMap(doc.data() as Map<String,dynamic> , doc.id);
           }
           ).toList();
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DetailProductScreen(productId:product.id ,),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child:
                              product.images.isNotEmpty
                                  ? Image.memory(
                                    base64Decode(product.images[0]),
                                    height: 130,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                  : Container(
                                    height: 130,
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(Icons.image, size: 50),
                                    ),
                                  ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "Rs. ${product.price}",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (product.discountPrice != null) ...[
                                    SizedBox(width: 6),
                                    Text(
                                      "Rs. ${product.discountPrice}",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ],
                              ),

                              Text(
                                "Stock: ${product.stock} Units",
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      product.isAvailable
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                              Text(
                                "Status: ${product.isAvailable ? 'In Stock' : 'Out of Stock'}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      product.isAvailable
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
