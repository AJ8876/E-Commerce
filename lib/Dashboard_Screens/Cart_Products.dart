import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopify/Dashboard_Screens/Detail_Product_Screen.dart';
import 'package:shopify/Dashboard_Screens/Order_Detail.dart';
import 'package:shopify/Product_model.dart';
import 'package:shopify/Services/Carts_Services.dart';

class CartProducts extends StatefulWidget {
  final String userId;

  const CartProducts({super.key, required this.userId});

  @override
  State<CartProducts> createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  final Carts_Services _carts_services = Carts_Services();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Cart"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Product>>(
        stream: _carts_services.GetCartProducts(widget.userId),
        builder: (context, snapshot) {
          // print("👀 Listening for cart of user: ${widget.userId}");
          // print("📊 Snapshot data: ${snapshot.data}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Your Cart is Empty",
                style: TextStyle(color: Colors.black54, fontSize: 18),
              ),
            );
          }

          final CartList = snapshot.data!;

          return ListView.builder(
            itemCount: CartList.length,
            itemBuilder: (context, index) {
              final product = CartList[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: product.images.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      base64Decode(product.images[0]),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 40),
                  ),
                  title: Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        "Rs. ${product.price}",
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.discountPrice != null)
                        Text(
                          "Discount : Rs. ${product.discountPrice}",
                          style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                      Text(
                        "Stock : ${product.stock}",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  // 👇 Remove from cart button
                  trailing: IconButton(
                    icon: Icon(Icons.remove_shopping_cart, color: Colors.grey),
                    onPressed: () async {
                      await _carts_services.removeFromCart(
                          widget.userId, product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${product.name} removed from cart"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailProductScreen(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetail(UserId: widget.userId,)));
            },
          label: Text("Processed to Checkout",style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.arrow_forward,color: Colors.white),
          backgroundColor: Colors.purple,
        ),
    );
  }
}