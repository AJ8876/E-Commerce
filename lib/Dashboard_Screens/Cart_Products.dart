import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopify/Dashboard_Screens/Detail_Product_Screen.dart';
import 'package:shopify/Global_List.dart';

class CartProducts extends StatefulWidget {
  const CartProducts({super.key});

  @override
  State<CartProducts> createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Cart"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body:
          cartlist.isEmpty
              ? Center(
                child: Text(
                  "Your Cart is Empty",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
              : ListView.builder(
                itemCount: cartlist.length,
                itemBuilder: (context, index) {
                  final product = cartlist[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading:
                          product.images.isNotEmpty
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  product.images[0],
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
                              color: Colors.deepPurple,
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DetailProductScreen(product: product),
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
