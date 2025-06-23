import 'package:flutter/material.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({super.key});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
   appBar: AppBar(
     title: Text("Order Detail",style: TextStyle(color: Colors.black),
     ),
       backgroundColor: Colors.deepPurple,
     centerTitle: true,
     elevation: 2,
   ),
       body: SingleChildScrollView(
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
                 boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 5,offset: Offset(0, 2),
                 ),
                 ],
               ),
             )
           ],
         ),
       ),
    );
  }
}
