import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController NameController = TextEditingController();
  final TextEditingController PhoneController = TextEditingController();
  final TextEditingController AddressController = TextEditingController();
  final TextEditingController CityController = TextEditingController();
  String SelectMethod = 'JazzCash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text("Payment Screen", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Billing Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 14),
            Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.deepPurple),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: NameController,
                      decoration: InputDecoration(
                        hintText: "Full Name",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(Icons.phone, color: Colors.deepPurple),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: PhoneController,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(Icons.home, color: Colors.deepPurple),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: AddressController,
                      decoration: InputDecoration(
                        hintText: "Address",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(Icons.location_city, color: Colors.deepPurple),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: CityController,
                      decoration: InputDecoration(
                        hintText: "City",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
               Text("Select Payment Method",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
               ),
              SizedBox(height: 14),
              GestureDetector(
                onTap: ()=> setState(() => SelectMethod='JazzCash'),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 14,vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: SelectMethod== 'JazzCash' ? Colors.deepPurple: Colors.black26),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet_rounded,color: Colors.deepPurple),
                        SizedBox(width: 12),
                         Expanded(child: Text("JazzCash",style: TextStyle(fontSize: 15),
                         ),
                         ),
                           if(SelectMethod== 'JazzCash')
                             Icon(Icons.check_circle,color: Colors.deepPurple),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
