import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Athentication_module/Login.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  AppOpenAd? _appOpenAd;
  bool _isAdLoaded=false;
  int _countdown=10;
  Timer? _countdownTimer;
  bool _navigated=false;



  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    });
  }


  void _startcountdown(){
    _countdownTimer= Timer.periodic(Duration(seconds: 1), (timer){
      if(_countdown > 0){
        setState(() {
          _countdown--;
        });
      }
        else {
             GoToSplashIfNotNavigated();
      }
    });
  }

  void GoToSplashIfNotNavigated(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            Image.asset("asset/png.jd.png",height: 200,width: 200),
            SizedBox(height: 25),
            Text(
              "E Commerce",
              style: TextStyle(
                  color: Colors.purple, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            if(isLoading)
            CircularProgressIndicator(
             valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
                  ],
                ),
        ),
        );
  }
}
