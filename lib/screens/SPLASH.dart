import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:foodtruck/main.dart';
import 'package:foodtruck/screens/Login_SignupView/SIGNUP.dart';
import 'package:flare_flutter/flare_actor.dart';

import 'Login_SignupView/login.dart';

class SPLASH extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPLASHSTATE();
  }
}

class SPLASHSTATE extends State<SPLASH> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), go_to_home);
  }

  go_to_home() {
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Login();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xff039bf4),
        body: FlareActor("assets/anim/ftesplash.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "ntro"),
      ),
    );
  }
}
