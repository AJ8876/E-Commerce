import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Splash_View.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   if(Platform.isAndroid){
     await Firebase.initializeApp(
         options: const FirebaseOptions(
           apiKey: 'AIzaSyB4bChrEwalRY9KmDzZw2zMxUtLBrx7taI',
           appId: '1:918878073427:android:1d50f368763bcb4fa04ca6',
           messagingSenderId: '918878073427',
           projectId: 'shopify-31cb7',
         ));
   }
     else{
     await Firebase.initializeApp();
   }
     await MobileAds.instance.initialize();

      runApp( MyApp());
  }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashView(),
    );
  }
}