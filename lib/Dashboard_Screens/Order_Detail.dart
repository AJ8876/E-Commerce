import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopify/Product_model.dart';

import '../Services/Carts_Services.dart';
import 'Payment_Screen.dart';

class OrderDetail extends StatefulWidget {
  final String UserId;
  const OrderDetail({super.key, required this.UserId});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final Carts_Services _carts_services=Carts_Services();
  String? orderId ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text("Order Detail", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<Product>>(
          stream: _carts_services.GetCartProducts(widget.UserId),
          builder: (context,Snapshot){
            if(Snapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
             if(!Snapshot.hasData || Snapshot.data!.isEmpty){
               return Center(
                 child: Text("No Items in the Cart"),
               );
             }
               final CartItems= Snapshot.data!;
              double SubTotal= CartItems.fold(0,(sum,item)=> sum+item.price);
              double shippingCharges= 250;
              double Total= SubTotal + shippingCharges;


              return StreamBuilder<DocumentSnapshot>(

                  stream: orderId != null
                      ? FirebaseFirestore.instance
                      .collection("Orders")
                      .doc(orderId)
                      .snapshots()
                      : const Stream.empty(),
                  builder: (context, orderSnapshot) {
                    String status = "Pending";
                    if (orderSnapshot.hasData && orderSnapshot.data!.exists) {
                      status = orderSnapshot.data!["status"];
                    }
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.0),
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Order Id",
                                      style: TextStyle(fontSize: 15, color: Colors.black87),
                                    ),
                                    Text(
                                      "#OD${DateTime.now().millisecondsSinceEpoch}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Date",
                                      style: TextStyle(fontSize: 15, color: Colors.black87),
                                    ),
                                    Text(
                                      "Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Status", style: TextStyle(fontSize: 15)),
                                    Chip(
                                      label: Text(status,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,
                                        color: status=="Delivered"? Colors.green: Colors.orange,
                                      ),
                                      ),
                                      backgroundColor: Colors.green.shade100,
                                      labelStyle: TextStyle(color: Colors.purple),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Items Ordered",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),

                          ...CartItems.map((product){
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                              ),
                              child: Row(
                                children: [
                                  product.images.isNotEmpty?
                                  Image.memory(base64Decode(product.images[0]
                                  ),
                                    height: 65,width: 65,
                                    fit: BoxFit.cover,
                                  ):
                                  Container(
                                    height: 65,width: 65,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image),
                                  ),
                                  SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Quantity : ${product.stock}",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "RS : ${product.price}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }),

                          //Product 1

                          // Product 2
                          SizedBox(height: 20),
                          Text(
                            "Delivery Address",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "M Adeel\nHome town Streat 3 Ryk",
                              style: TextStyle(fontSize: 15, height: 1.5),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Payment Method
                          Text(
                            "Payment Method",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.account_balance_rounded, color: Colors.purple),
                                SizedBox(width: 10),
                                Text("JazzCash .....76021", style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Summery",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sub Total",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Rs. $SubTotal",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Shipping",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Rs. $shippingCharges",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Rs.$Total",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () async{
                                final doc= await FirebaseFirestore.instance.collection("Orders")
                                    .add({
                                  "userId": widget.UserId,
                                  "items": CartItems.map((p)=> p.toMap()).toList(),
                                  "subtotal": SubTotal,
                                  "total": Total,
                                  "status": "Pending",
                                  "createdAt": FieldValue.serverTimestamp(),
                                });
                                setState(() {
                                  orderId=doc.id;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Order Confirm Successfully"),
                                  ),
                                );
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context)=>PaymentScreen(
                                      userId: widget.UserId,
                                      cartItems: CartItems,
                                      subTotal: SubTotal,
                                      shipping: shippingCharges,
                                      Total: Total,
                                      orderId: doc.id,

                                    )));
                              },
                              label: Text("Order Confirm Successfully", style: TextStyle(color: Colors.white)),
                              icon: Icon(
                                Icons.replay_circle_filled_outlined,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    );
                  }

              );
              },

      ),


    );
  }
}
