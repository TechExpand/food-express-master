import 'package:flutter/material.dart';
import 'package:foodtruck/Services/Network.dart';
import 'dart:ui' as ui;
import 'package:foodtruck/main.dart';
import 'package:foodtruck/screens/Login_SignupView/SIGNUP.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:foodtruck/screens/UserView/Map_user.dart';
import 'package:foodtruck/screens/video.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login_SignupView/login.dart';
import 'VendorView/MAp_vendor.dart';

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
    Provider.of<WebServices>(context, listen: false).initializeValues();
    super.initState();
    Future.delayed(Duration(seconds: 7), go_to_home);
  }

  go_to_home() {
     return decideFirstWidget();
  }

Future<Widget> decideFirstWidget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var video = prefs.getString('video');
     var user = prefs.getString('user');
    if (token == null || token == 'null' || token == '') {
      return Navigator.pushAndRemoveUntil(
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
        (route) => false,
      );
    } else {

      if(video == null || video == 'null' || video == '') {
        return Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return VideoApp(); //SignUpAddress();
            },
            transitionsBuilder: (context, animation, secondaryAnimation,
                child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
              (route) => false,
        );
      }else{
       return Navigator.pushAndRemoveUntil(
         context,
         PageRouteBuilder(
           pageBuilder: (context, animation, secondaryAnimation) {
             return user == 'user'
                 ? Map_user()
                 : Map_vendor(); //SignUpAddress();
           },
           transitionsBuilder: (context, animation, secondaryAnimation,
               child) {
             return FadeTransition(
               opacity: animation,
               child: child,
             );
           },
         ),
             (route) => false,
       );
      }
      }
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
  }}
//import 'package:flutter/material.dart';
//import 'dart:ui' as ui;
//import 'package:foodtruck/main.dart';
//import 'package:foodtruck/screens/Login_SignupView/SIGNUP.dart';
//import 'package:flare_flutter/flare_actor.dart';
//
//import 'Login_SignupView/login.dart';
//
//class SPLASH extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return SPLASHSTATE();
//  }
//}
//
//class SPLASHSTATE extends State<SPLASH> {
//  @override
//  void initState() {
//    super.initState();
//    Future.delayed(Duration(seconds: 2), go_to_home);
//  }
//
//  go_to_home() {
//    return Navigator.pushReplacement(
//      context,
//      PageRouteBuilder(
//        pageBuilder: (context, animation, secondaryAnimation) {
//          return Login();
//        },
//        transitionsBuilder: (context, animation, secondaryAnimation, child) {
//          return FadeTransition(
//            opacity: animation,
//            child: child,
//          );
//        },
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        backgroundColor: const Color(0xff039bf4),
//        body: FlareActor("assets/anim/ftesplash.flr",
//            alignment: Alignment.center,
//            fit: BoxFit.contain,
//            animation: "ntro"),
//      ),
//    );
//  }
//}
