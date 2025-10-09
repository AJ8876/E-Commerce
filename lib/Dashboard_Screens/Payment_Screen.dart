import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopify/Dashboard_Screens/Home_Screen.dart';
import 'package:shopify/Product_model.dart';

import '../Services/Carts_Services.dart';

class PaymentScreen extends StatefulWidget {
  final String userId;
  final List<Product> cartItems;
  final double subTotal;
  final double shipping;
  final double Total;
  final String orderId;
  const PaymentScreen({super.key,
    required this.userId,
    required this.cartItems,
    required this.subTotal,
    required this.shipping,
    required this.Total, required this.orderId
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController NameController = TextEditingController();
  final TextEditingController PhoneController = TextEditingController();
  final TextEditingController AddressController = TextEditingController();
  final TextEditingController CityController = TextEditingController();
  String SelectMethod = 'JazzCash';
  String? selectedBank;
  final Carts_Services _carts_services=Carts_Services();

  late double subtotal;
  late double shipping;
  late double total;

  @override
  void initState() {
    super.initState();
    subtotal=widget.subTotal;
    shipping=widget.shipping;
    total=widget.Total;
  }

  Future<void> PlaceOrder()async{
     if( NameController.text.isEmpty || PhoneController.text.isEmpty ||
         AddressController.text.isEmpty || CityController.text.isEmpty){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Fill all Billing Details")));
       return ;
     }
    try{
         QuerySnapshot OrderSnapshot=await FirebaseFirestore
             .instance
             .collection("Orders").where("userId", isEqualTo: widget.userId)
             .where("status", isEqualTo: "Pending")
             .orderBy("createdAt", descending: true)
             .limit(1).get();
           if(OrderSnapshot.docs.isNotEmpty){
             String orderId=OrderSnapshot.docs.first.id;

             await FirebaseFirestore.instance.collection("Orders").doc(orderId)
             .update({
               "status": "Delivered",
               "userId": widget.userId,
               "items": widget.cartItems.map((p)=>p.toMap()).toList(),
               "subTotal": widget.subTotal,
               "shipping": widget.shipping,
               "total": widget.Total,
               "paymentMethod": SelectMethod,
               "bankName": SelectMethod== "Bank Transfer"? selectedBank: null,
               "billingInfo": {
                 "name": NameController.text,
                 "phone": PhoneController.text,
                 "address": AddressController.text,
                 "city": CityController.text,
               },
               "createdAt": FieldValue.serverTimestamp(),
             });

             // ScaffoldMessenger.of(context).showSnackBar(
             //   SnackBar(content: Text("Order Created & Marked As Delivered")),
             // );
           }
           else{
             await FirebaseFirestore.instance.collection("Orders").add({

               "userId": widget.userId,
               "items": widget.cartItems.map((p)=>p.toMap()).toList(),
               "subTotal": widget.subTotal,
               "shipping": widget.shipping,
               "total": widget.Total,
               "status": "Pending",
               "paymentMethod": SelectMethod,
               "bankName": SelectMethod== "Bank Transfer"? selectedBank: null,
               "billingInfo": {
                 "name": NameController.text,
                 "phone": PhoneController.text,
                 "address": AddressController.text,
                 "city": CityController.text,
               },
               "createdAt": FieldValue.serverTimestamp(),

             });
           }

           await _carts_services.clearCart(widget.userId);
           setState(() {
             widget.cartItems.clear();
             subtotal=0;
             shipping=0;
             total=0;
           });

            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Row(
                      children: [
                        Icon(Icons.check_circle,color: Colors.green,size: 28),
                        SizedBox(width: 8),
                        Text("Order Placed !")
                      ],
                    ),
                       content: Text("Your Order has been Placed Successfully"),
                      actions: [
                        TextButton(onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(userId: widget.userId)));
                        },
                            child: Text("Continue Shopping",style: TextStyle(color: Colors.purple,fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                        ),
                      ],
                  );
                }
            );

           if(SelectMethod == 'JazzCash'){
             _redirectToUrl("https://www.jazzcash.com.pk/");
           }
           else if(SelectMethod == 'EasyPaisa'){
             _redirectToUrl("https://easypaisa.com.pk/");
           }
             else if(SelectMethod == 'Bank Transfer'){
               if(selectedBank == "Meezan Bank"){
                 _redirectToUrl("https://www.meezanbank.com/");
               }
               else if(selectedBank =='HBL'){
                 _redirectToUrl("https://www.hbl.com/");
               }
               else if(selectedBank =='UBL'){
                 _redirectToUrl("https://www.ubldigital.com/");
               }
           }
         
    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: $e")));
          }
  }
  void _redirectToUrl(String url) {
    print("Redirecting to$url");
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text("Payment Screen", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Billing Information",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            ),
              TextField(
                controller: NameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                    filled: true,
                   fillColor: Colors.white,
                ),
              ),
            SizedBox(height: 10),
            TextField(
              maxLength: 11,
              keyboardType: TextInputType.number,
              controller: PhoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
                 onChanged: (value){
                  if(value.length>11){
                    Fluttertoast.showToast(msg: "Phone Number Should Not more than 11",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                       PhoneController.text=value.substring(0,11);
                       PhoneController.selection=TextSelection.fromPosition(TextPosition(offset: PhoneController.text.length));
                  }
                    else if(value.length<11 && value.isNotEmpty){
                    Fluttertoast.showToast(msg: "Phone Number Should not Less than 11 ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                 },
            ),
            SizedBox(height: 10),
            TextField(
              controller: AddressController,
              decoration: InputDecoration(
                labelText: "Address #",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: CityController,
              decoration: InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 25),
            Text(
              "Select Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 14),
            GestureDetector(
              onTap: () => setState(() => SelectMethod = 'JazzCash'),
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        SelectMethod == 'JazzCash'
                            ? Colors.purple
                            : Colors.black26,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.purple,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text("JazzCash", style: TextStyle(fontSize: 15)),
                    ),
                    if (SelectMethod == 'JazzCash')
                      Icon(Icons.check_circle, color: Colors.purple),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => SelectMethod = 'EasyPaisa'),
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        SelectMethod == 'EasyPaisa'
                            ? Colors.purple
                            : Colors.black26,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone_android, color: Colors.purple),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text("EasyPaisa", style: TextStyle(fontSize: 15)),
                    ),
                    if (SelectMethod == 'EasyPaisa')
                      Icon(Icons.check_circle, color: Colors.purple),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => SelectMethod = 'Bank Transfer'),
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        SelectMethod == 'Bank Transfer'
                            ? Colors.purple
                            : Colors.black26,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance, color: Colors.purple),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Bank Transfer",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    if (SelectMethod == 'Bank Transfer')
                      Icon(Icons.check_circle, color: Colors.purple),
                  ],
                ),
              ),
            ),
            if(SelectMethod == 'Bank Transfer')...[
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
              value: selectedBank,
              hint: Text("Select Bank"),
                  items: ['Meezan Bank','HBL','UBl'].map((bank){
                return DropdownMenuItem(value: bank,child: Text(bank));
                  }).toList(),
                  onChanged: (val)=>setState(()=> selectedBank = val),
           ),
            ],

            // Order Summery
            Text(
              "Order Summery",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Items Total", style: TextStyle(fontSize: 14)),
                      Text("Rs. ${widget.subTotal}", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Shipping", style: TextStyle(fontSize: 14)),
                      Text("Rs. ${widget.shipping}", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rs. ${widget.Total}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
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
                onPressed: PlaceOrder,
                label: Text(
                  "Place Order",
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(Icons.payment, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
