import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wayoutchatapp/api/apis.dart';
import 'package:wayoutchatapp/screens/home_screen.dart';

import '../../main.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAnimate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Apis.auth.currentUser != null) {
      print("/user :: ${Apis.auth.currentUser}");
      Future.delayed(Duration(milliseconds: 5), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      });
    } else {
      Future.delayed(Duration(milliseconds: 5), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginHomeScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to We chat"),
      ),
      body: Stack(
        children: [
          Positioned(top: mq.height * .15, right: mq.width * .25, width: mq.width * .5, child: Icon(Icons.markunread_outlined)),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: Text(
                "Made in pakistan",
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }
}
