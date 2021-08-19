import 'package:flutter/material.dart';
import 'package:foodtruck/Services/Network.dart';
import 'dart:ui' as ui;
import 'package:foodtruck/main.dart';
import 'package:foodtruck/screens/Login_SignupView/SIGNUP.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:foodtruck/screens/UserView/Map_user.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

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
    super.initState();
    Provider.of<WebServices>(context, listen: false).initializeValues();
    Future.delayed(Duration(seconds: 2), go_to_home);
  }
  final box = GetStorage();


  go_to_home() {

   var token = box.read('token');
   var user = box.read('user');
   if(token == null || token == 'null' || token.isEmpty) {
     return Navigator.pushReplacement(
       context,
       PageRouteBuilder(
         pageBuilder: (context, animation, secondaryAnimation) {
           return Login();
         },
         transitionsBuilder: (context, animation, secondaryAnimation, child){
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },
       ),
     );
   }else{
     return Navigator.pushReplacement(
       context,
    PageRouteBuilder(
         pageBuilder: (context, animation, secondaryAnimation) {
           return user=='user'?Map_vendor():Map_user();
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
       backgroundColor: const Color(0xff039bf4),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FlareActor("assets/anim/ftesplash.flr",
              alignment: Alignment.center,
              fit: BoxFit.cover,
              animation: "ntro"),
        ),
      ),
    );
  }
}