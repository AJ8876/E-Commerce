import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formkey=GlobalKey<FormState>();

  TextEditingController EmailController=TextEditingController();

  Future <void> resetPassword()async{
    if(_formkey.currentState !.validate()){
      try{
            await FirebaseAuth.instance.sendPasswordResetEmail(email: EmailController.text.trim());
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Password reset Link Send to your Email"),
                  backgroundColor: Colors.purple,
                ));
      }
      on FirebaseAuthException catch(e){
        String message = " ";
        if(e.code=="User-not-found"){
          message = "No user found for that email";
        }
          else{
            message = "Error : ${e.message}";
        }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),
            backgroundColor: Colors.red,
          ));
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rest Your Password",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Enter your email address below. We'll send you a password reset link",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: EmailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Your Email";
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return "Please Enter a Valid Email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Enter Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: resetPassword,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      "Send Reset Link",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back to Login",
                    style: TextStyle(color: Colors.purple, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
