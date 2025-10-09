import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopify/Dashboard_Screens/Home_Screen.dart';
import 'Login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String selectgender = "Male";
  bool obsecuretext = true;

  final TextEditingController FirstNameController=TextEditingController();
  final TextEditingController LastNameController=TextEditingController();
  final TextEditingController EmailController=TextEditingController();
  final TextEditingController PasswordController=TextEditingController();

  bool isLoading= false;
  final _formKey= GlobalKey<FormState>();

  final FirebaseAuth _auth= FirebaseAuth.instance;
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;






  Future <void> signUpUser()async {

    if(_formKey.currentState?.validate()!= true) return;
     setState(() {
       isLoading= true;
     });
    try{
      UserCredential userCredential= await _auth.createUserWithEmailAndPassword(
          email: EmailController.text.trim(), password: PasswordController.text.trim(),
      );


      final user= userCredential.user;
      if(user!=null){
        // print("User Created: ${user.uid}");
        await _firestore.collection("Users").doc(user.uid).set(
          {
            "FirstName": FirstNameController.text.trim(),
            "LastName": LastNameController.text.trim(),
            "Email": EmailController.text.trim(),
            "Password": PasswordController.text.trim(),
            "Gender": selectgender,
            "Created_at": FieldValue.serverTimestamp(),
          });
         if(! mounted) return;
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account Created Successfully")));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userId: FirebaseAuth.instance.currentUser!.uid),
          ),
        );
    }else{
        throw Exception("User Creation Failed");
      }

    } on FirebaseAuthException catch (e){
      String message = "";
      if(e.code=='email-already-in-use'){
        message= "Email Already Used";
      }
      else if(e.code=='weak-password'){
        message="Password Should be Atleast 8 Characters";
      }
      else{
        message="Something went Wrong";
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
        title: Text(
          "SignUp Screen",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create Your Account",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Sign up to get Started",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: FirstNameController,
                      decoration: InputDecoration(
                        labelText: "First Name",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                         validator: (value){
                        if(value ==null || value.isEmpty){
                          return "First Name is Required";
                        }
                          return null;
                         }
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: LastNameController,
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        prefixIcon: Icon(Icons.person_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value){
                        if(value ==null || value.isEmpty){
                          return"Last Name is Required";
                        }
                        return null;
                      }
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: EmailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                        validator: (value){
                          if(value ==null || value.isEmpty){
                            return"Email is Required";
                          }
                            else if(! RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
                              return "Enter a Valid Email Address";
                          }
                            else if(!value.contains("@")){
                              return "Enter a Valid Email";
                          }
                          return null;
                        }
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      maxLength: 8,
                      controller: PasswordController,
                      obscureText: obsecuretext,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(onPressed: (){
                          setState(() {
                            obsecuretext =! obsecuretext;
                          });
                        }, icon: Icon(obsecuretext ? Icons.visibility_off : Icons.visibility),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                        validator: (value){
                          if(value ==null || value.isEmpty){
                            return"Password is Required";
                          }
                            else if(value.length<8 || value.length>8){
                              return "Password must be At least 8 Characters";
                          }
                             else if(!value.contains(RegExp(r'[A-Z]'))){
                               return "Password must Contain At Least 1 Capital Letter";
                          }
                          else if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                            return "Password must contain at least one special character";
                          }
                          return null;
                        }
                    ),
                    SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            "Gender :",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              Radio(
                                value: "Male",
                                groupValue: selectgender,
                                onChanged: (value) {
                                  setState(() {
                                    selectgender = value.toString();
                                  });
                                },
                              ),
                              Text("Male"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: "Female",
                                groupValue: selectgender,
                                onChanged: (value) {
                                  setState(() {
                                    selectgender = value.toString();
                                  });
                                },
                              ),
                              Text("Female"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: "Other",
                                groupValue: selectgender,
                                onChanged: (value) {
                                  setState(() {
                                    selectgender = value.toString();
                                  });
                                },
                              ),
                              Text("Other"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null: (){

                          print("Signup Button clicked");
                          signUpUser();
                        },


                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                        child: isLoading?CircularProgressIndicator(color: Colors.white
                        ):Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an Account? "),
                        TextButton(
                          onPressed: () {},
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Login()));
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.purple),
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
