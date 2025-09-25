import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopify/Dashboard_Screens/Add_Product.dart';

import '../Dashboard_Screens/Home_Screen.dart';
import 'Forgot_Password.dart';
import 'Sign_Up.dart';


class Login extends StatefulWidget {
  const Login({super.key});



  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _rememberme = false;
  bool isLoading=false;
  bool obscuretext = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController EmailController=TextEditingController();
  final TextEditingController PasswordController=TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  Future <void> LoginUser()async{
    if(_formKey.currentState?.validate() != true) return;
    setState(() {
      isLoading=true;
    });
        try{

            await _auth.signInWithEmailAndPassword(
                email: EmailController.text.trim(), password: PasswordController.text.trim());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successfully")));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(userId: FirebaseAuth.instance.currentUser!.uid),
              ),
            );

        }on FirebaseAuthException catch(e){
          String message="";
          if(e.code=='email-already-in-use'){
            message="Email Already in use";
          }else if(e.code=='weak_password'){
            message="Password Should be At Least 8 Characters";
          }else{
            message="Something Went Wrong";
          }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        } catch(e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error : $e")));
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Back !",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Login to your Account",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: EmailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is Required";
                        }
                        else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return "Enter a Valid Email Address";
                        }
                        else if (!value.contains("@")) {
                          return "Enter a Valid Email";
                        }
                        return null;
                      },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    maxLength: 8,
                    controller: PasswordController ,
                    obscureText: obscuretext,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          obscuretext=! obscuretext;
                        });
                      },
                        icon: Icon(
                          obscuretext ?Icons.visibility_off: Icons.visibility,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                      validator: (value){
                        if(value ==null || value.isEmpty){
                          return"Password is Required";
                        }
                        else if(!value.contains(RegExp(r'[A-Z]'))){
                          return "Password must Contain At Least 1 Capital Letter";
                        }
                        else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                          return "Password must contain at least one special character";
                        }
                        return null;
                      }
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberme,
                            onChanged: (value) {
                              setState(() {
                                _rememberme = value!;
                              });
                            },
                          ),
                          Text("Remember Me"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword()));
                          },
                          child: Text(
                            "Forgot Password ?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null :  LoginUser,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),

                      child: isLoading ? CircularProgressIndicator(color: Colors.white):
                      Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an Account?"),
                      TextButton(
                        onPressed: () {},
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
                          },
                          child: Text(
                            "Signup",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
