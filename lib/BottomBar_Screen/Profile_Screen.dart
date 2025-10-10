import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _obscurePassword = true;
  bool _isEditing=false;
  bool _isLoading=true;
  final TextEditingController FirstNameController=TextEditingController();
  final TextEditingController LastNameController=TextEditingController();
  final TextEditingController EmailController=TextEditingController();
  final TextEditingController PasswordController=TextEditingController();

  @override
  void initState() {
    super.initState();
    _FetchUserData();
  }

     Future<void> _FetchUserData()async{
     try {
       DocumentSnapshot doc = await
       FirebaseFirestore.instance.collection("Users").doc(widget.userId).get();
       if (doc.exists) {
         setState(() {
           FirstNameController.text = doc['FirstName'] ?? '';
           LastNameController.text = doc['LastName'] ?? '';
           EmailController.text = doc['Email'] ?? '';
           PasswordController.text = doc['Password'] ?? '';
           _isLoading = false;
         });
       }
       else {
         setState(() => _isLoading = false);
         Fluttertoast.showToast(msg: "User not Found",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.BOTTOM,
           backgroundColor: Colors.redAccent,
           textColor: Colors.white,
           fontSize: 16.0,
         );
       }
     }catch(e){
       Fluttertoast.showToast(msg: "Error Loading Data : $e",
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         backgroundColor: Colors.redAccent,
         textColor: Colors.white,
         fontSize: 16.0,
       );
     }
     }

     Future<void> _UpdateuserProfile()async{
     try{
          await FirebaseFirestore.instance.collection("Users").doc(widget.userId)
              .update({
                "FirstName" : FirstNameController.text.trim(),
                "LastName"  : LastNameController.text.trim(),
                "Email"     : EmailController.text.trim(),
                "Password"  : PasswordController.text.trim(),

          });

          Fluttertoast.showToast(msg: "Profile Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          setState(() => _isEditing=false);
     } catch(e) {
       Fluttertoast.showToast(msg: "Error Updating Profile $e",
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         backgroundColor: Colors.redAccent,
         textColor: Colors.white,
         fontSize: 16.0,
       );
     }
     }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        centerTitle: true,
        leading: BackButton(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              _isEditing= ! _isEditing;
            });
          },
              icon: Icon(_isEditing? Icons.close:Icons.edit,color: Colors.white),
          ),
        ],
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(
          color: Colors.purple,
        ),
      ):
      SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Edit your Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Update your personal information",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                enabled: _isEditing,
                controller: FirstNameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Colors.purple),
                  hintText: "First Name",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                enabled: _isEditing,
                controller: LastNameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline, color: Colors.purple),
                  hintText: "Last Name",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                enabled: _isEditing,
                controller: EmailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.purple),
                  hintText: "Email",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                enabled: _isEditing,
                controller: PasswordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      _obscurePassword =! _obscurePassword;
                    });
                  },
                      icon: Icon(_obscurePassword? Icons.visibility_off : Icons.visibility,color: Colors.grey),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.purple),
                  hintText: "Password",
                ),
              ),
            ),
               if(_isEditing)
               Center(
                 child: ElevatedButton.icon(onPressed: _UpdateuserProfile,
                     label: Text("Save Changes",style: TextStyle(color: Colors.white),
                     ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                           textStyle: TextStyle(
                             fontSize: 17,
                             fontWeight: FontWeight.w500,
                           ),
                      )
                 )
               )
          ],
        ),
      ),
    );
  }
}
