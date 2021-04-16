import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:foodtruck/Services/Network.dart';
import 'package:foodtruck/Utils/utils.dart';
import 'package:foodtruck/screens/Login_SignupView/SIGNUP.dart';
import 'package:foodtruck/screens/VendorView/MAp_vendor.dart';
import 'package:foodtruck/Services/admob.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login> {
  var email;
  var password;
  final form_key = GlobalKey<FormState>();
  final form_key1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Container(
              color: Colors.white,
              height: 105,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 55,
                    color: Colors.white,
                    child: TabBar(
                      tabs: <Widget>[
                        Tab(
                          icon: Icon(
                            Icons.person_pin,
                            color: Colors.blue.shade400,
                          ),
                          child: Text(
                            'Login as User',
                            style: TextStyle(
                              color: Colors.blue.shade400,
                            ),
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.fastfood,
                            color: Colors.blue.shade400,
                          ),
                          child: Text(
                            'Login as Vendor',
                            style: TextStyle(
                              color: Colors.blue.shade400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      color: Colors.white,
                      child: AdmobBanner(
                        adUnitId:
                            Provider.of<AdmobService>(context, listen: false)
                                .getBannerAdUnitId(),
                        adSize: AdmobBannerSize.BANNER,
                        listener:
                            (AdmobAdEvent event, Map<String, dynamic> args) {},
                      ))
                ],
              ),
            )),
        appBar: AppBar(
          actions: <Widget>[
            Image.asset(
              'assets/images/truckIcon.png',
              width: 100,
            ),
            SizedBox(
              width: 8,
            )
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'LOGIN',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.visible,
          ),
        ),
        backgroundColor: const Color(0xffffffff),
        body: TabBarView(
          children: [
            UserLogin(email, password, context, form_key1),
            VendorLogin(email, password, context, form_key)
          ],
        ),
      ),
    );
  }
}

Widget UserLogin(email, password, context, form_key) {
  return Form(
    key: form_key,
    child: SingleChildScrollView(
      child: Flexible(
        flex: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.all(MediaQuery.of(context).size.height / 14),
            //   child: Container(
            //       width: 150,
            //       height: 100,
            // child: Image.asset('assets/images/logotruck.png')),
            // ),

            SizedBox(
              height: 200.0,
            ),

            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 50, bottom: 20),
              child: FractionallySizedBox(
                widthFactor: 0.85,
                // width: 300,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email Required';
                    } else {
                      email = value;
                      return null;
                    }
                  },
                  // decoration: InputDecoration(
                  //     focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8)),
                  //     labelText: 'Email',
                  //     labelStyle: TextStyle(
                  //       color: Colors.black54,
                  //     ),
                  //     icon: Icon(
                  //       Icons.person,
                  //       color: Colors.white,
                  //     ),
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8))

                  //         ),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        color: Colors.blue),
                    suffixIcon: Icon(Icons.email),
                    // contentPadding: EdgeInsets.all(5.0)
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 50, bottom: 20),
              child: FractionallySizedBox(
                // width: 300,
                widthFactor: 0.85,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password Required';
                    } else {
                      password = value;
                      return null;
                    }
                  },
                  // decoration: InputDecoration(
                  //     focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8)),
                  //     labelText: 'Password',
                  //     labelStyle: TextStyle(
                  //       color: Colors.black54,
                  //     ),
                  //     icon: Icon(
                  //       Icons.person,
                  //       color: Colors.white,
                  //     ),
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8))
                  //         ),

                  /// t button style
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        color: Colors.blue),
                    suffixIcon: Icon(Icons.vpn_key),
                    // contentPadding: EdgeInsets.all(5.0)
                  ),

                  ///
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: InkWell(
            //       onTap: () {
            //         Navigator.push(context,
            //             MaterialPageRoute(builder: (context) {
            //           return SIGNUP();
            //         }));
            //       },
            //       child: Container(
            //           decoration: BoxDecoration(
            //               border: Border.all(
            //                 color: Colors.black54,
            //               ),
            //               borderRadius: BorderRadius.circular(8)),
            //           child: Padding(
            //             padding: const EdgeInsets.all(4.0),
            //             child: Text("Don't Have an Account? Register"),
            //           ))),
            // ),
            // Padding(
            //   padding: EdgeInsets.all(12.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Container(
            //           width: 10,
            //           height: 1,
            //           color: Colors.black54,
            //         ),
            //       ),
            //       Text(
            //         'or',
            //         style: TextStyle(fontStyle: FontStyle.italic),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Container(
            //           width: 10,
            //           height: 1,
            //           color: Colors.black54,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 15.0,
            ),

            Consumer<WebServices>(
              builder: (context, webservices_consumer, child) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: webservices_consumer.login_state == false
                      ? RaisedButton(
                          onPressed: () {
                            if (form_key.currentState.validate()) {
                              webservices_consumer.Login_SetState();
                              webservices_consumer.Login_UserApi(
                                      email: email,
                                      password: password,
                                      context: context)
                                  .then((value) => webservices_consumer
                                          .get_current_user_location()
                                          .then((value) {
                                        var data = Provider.of<Utils>(context,
                                            listen: false);
                                        data.storeData('video', 'video');
                                        data.storeData('user', 'user');
                                        Timer.periodic(Duration(seconds: 5),
                                            (timer) {
                                          webservices_consumer
                                              .Update_User_Location(
                                            id: value[0].id,
                                            context: context,
                                          );
                                        });
                                      }));
                            }
                          },
                          color: Color(0xFF67b9fb),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff67b9fb),
                                    Color(0xff8acbff)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 150.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Login",
                                textAlign: TextAlign.center,
                                // style: TextStyle(color: Colors.white),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  //   textColor: Colors.white,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        )
                      : CircularProgressIndicator()),
            ),

            SizedBox(
              height: 30.0,
            ),

            Padding(
                // padding: EdgeInsets.all(15),
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 7, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Need an account?',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 11,
                        color: Colors.blue,
                        //   fontWeight: FontWeight.w200,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SIGNUP();
                        }));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.person_add),
                          Text(
                            'Sign up!',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    ),
  );
}

Widget VendorLogin(email, password, context, form_key) {
  return Form(
      key: form_key,
      child: SingleChildScrollView(
          child: Flexible(
              flex: 20,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Padding(
                    //   padding: EdgeInsets.all(
                    //       MediaQuery.of(context).size.height / 14),
                    //   child: Container(
                    //       width: 150,
                    //       height: 100,
                    //       child: Image.asset('assets/images/logotruck.png')),
                    // ),

                    // SizedBox(
                    //   height: 200.0,
                    // ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height / 14),
                      child: Container(
                          width: 150,
                          height: 100,
                          child: Image.asset('assets/images/logotruck.png')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 50,
                          bottom: 20),
                      child: FractionallySizedBox(
                        // width: 300,
                        widthFactor: 0.85,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Username Required';
                            } else {
                              email = value;
                              return null;
                            }
                          },
                          // decoration: InputDecoration(
                          //     focusedBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(8)),
                          //     labelText: 'Email',
                          //     labelStyle: TextStyle(
                          //       color: Colors.black54,
                          //     ),
                          //     icon: Icon(
                          //       Icons.person,
                          //       color: Colors.white,
                          //     ),
                          //     border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(8))),

                          /// t buttonstyle
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                color: Colors.blue),
                            suffixIcon: Icon(Icons.email),
                            // contentPadding: EdgeInsets.all(5.0)
                          ),

                          ///
                          ///
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 50,
                          bottom: 20),
                      child: FractionallySizedBox(
                        // width: 300,
                        widthFactor: 0.85,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password Required';
                            } else {
                              password = value;
                              return null;
                            }
                          },
                          // decoration: InputDecoration(
                          //     focusedBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(8)),
                          //     labelText: 'Password',
                          //     labelStyle: TextStyle(
                          //       color: Colors.black54,
                          //     ),
                          //     icon: Icon(
                          //       Icons.person,
                          //       color: Colors.white,
                          //     ),
                          //     border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(8))
                          //         ),

                          /// t button style
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                color: Colors.blue),
                            suffixIcon: Icon(Icons.vpn_key),
                            // contentPadding: EdgeInsets.all(5.0)
                          ),

                          ///
                          ///
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 15.0,
                    ),

                    // Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: InkWell(
                    //         onTap: () {
                    //           Navigator.push(context,
                    //               MaterialPageRoute(builder: (context) {
                    //             return SIGNUP();
                    //           }));
                    //         },
                    //         child: Container(
                    //             decoration: BoxDecoration(
                    //                 border: Border.all(
                    //                   color: Colors.black54,
                    //                 ),
                    //                 borderRadius: BorderRadius.circular(8)),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(4.0),
                    //               child:
                    //                   Text("Don't Have an Account? Register"),
                    //             )))),

                    // Padding(
                    //   padding: EdgeInsets.all(10.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.all(12.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Container(
                    //           width: 10,
                    //           height: 1,
                    //           color: Colors.black54,
                    //         ),
                    //       ),
                    //       Text(
                    //         'or',
                    //         style: TextStyle(fontStyle: FontStyle.italic),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Container(
                    //           width: 10,
                    //           height: 1,
                    //           color: Colors.black54,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    Consumer<WebServices>(
                      builder: (context, webservices_consumer, child) =>
                          Padding(
                        // padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            webservices_consumer.login_state == false
                                ? RaisedButton(
                                    onPressed: () {
                                      if (form_key.currentState.validate()) {
                                        webservices_consumer.Login_SetState();
                                        webservices_consumer.Login_VendorApi(
                                                email: email,
                                                password: password,
                                                context: context)
                                            .then((value) => webservices_consumer
                                                .get_current_vendor_location().then((value){
                                          var data = Provider.of<Utils>(context,
                                              listen: false);
                                          data.storeData('video', 'video');
                                          data.storeData('user', 'vendor');
                                                  Timer.periodic(
                                                        Duration(minutes: 10),
                                                        (timer) {
                                                      webservices_consumer
                                                          .Update_Vendor_Location(
                                                        id: value[0].id,
                                                        context: context,
                                                      );
                                                    });}));
                                      }
                                    },
                                    color: Color(0xFF67b9fb),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    // padding: EdgeInsets.all(0.0),
                                    // padding:
                                    //     EdgeInsets.fromLTRB(35, 15, 35, 15),
                                    // child: Ink(
                                    //   decoration: BoxDecoration(
                                    //     gradient: LinearGradient(
                                    //       colors: [
                                    //         Color(0xff67b9fb),
                                    //         Color(0xff8acbff)
                                    //       ],
                                    //       begin: Alignment.centerLeft,
                                    //       end: Alignment.centerRight,
                                    //     ),
                                    //     // borderRadius:
                                    //     //     BorderRadius.circular(30)
                                    //   ),
                                    //   child: Container(
                                    //     constraints: BoxConstraints(
                                    //         maxWidth: 100.0, minHeight: 50.0),
                                    //     alignment: Alignment.center,
                                    //     child: Text(
                                    //       "Login",
                                    //       textAlign: TextAlign.center,
                                    //       // style: TextStyle(color: Colors.white),
                                    //       style: TextStyle(
                                    //         fontFamily: 'Poppins',
                                    //         fontSize:
                                    //             18, //   textColor: Colors.white,
                                    //         color: Colors.white,
                                    //         fontWeight: FontWeight.w300,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xff67b9fb),
                                              Color(0xff8acbff)
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 150.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Login",
                                          textAlign: TextAlign.center,
                                          // style: TextStyle(color: Colors.white),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            //   textColor: Colors.white,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ),

                    // Padding(
                    //     padding: const EdgeInsets.all(15),
                    //     child: InkWell(
                    //         onTap: () {
                    //           Navigator.push(context,
                    //               MaterialPageRoute(builder: (context) {
                    //             return SIGNUP();
                    //           }));
                    //         },
                    //         child: Container(
                    //             // decoration: BoxDecoration(
                    //             //     border: Border.all(
                    //             //       color: Colors.black54,
                    //             //     ),
                    //             //     borderRadius: BorderRadius.circular(8)
                    //             //     ),
                    //             //     child: Padding(
                    //             //   padding: const EdgeInsets.all(4.0),
                    //             //   child: Text(
                    //             //     "Don't Have an Account? Register",
                    //             //     style: TextStyle(
                    //             //       fontFamily: 'Arial',
                    //             //       fontSize: 12,
                    //             //       color: Colors.blue,
                    //             //       //   fontWeight: FontWeight.w200,
                    //             //     ),
                    //             //   ),
                    //             // )

                    //             //                 Padding(
                    //             // padding: EdgeInsets.all(15),
                    //             // child: Column(
                    //             //   crossAxisAlignment: CrossAxisAlignment.end,
                    //             //   mainAxisSize: MainAxisSize.min,
                    //             //   children: <Widget>[
                    //             //     Text(
                    //             //       'Already have an account?',
                    //             //       style: TextStyle(
                    //             //         //   fontFamily: 'Arial',
                    //             //         //   fontSize: 16,
                    //             //         color: Colors.blue,
                    //             //         //   fontWeight: FontWeight.w200,
                    //             //       ),
                    //             //     ),
                    //             //     InkWell(
                    //             //       child: Row(
                    //             //         mainAxisSize: MainAxisSize.max,
                    //             //         mainAxisAlignment: MainAxisAlignment.end,
                    //             //         children: <Widget>[
                    //             //           Icon(Icons.vpn_key),
                    //             //           Text(
                    //             //             'Sign in',
                    //             //             textAlign: TextAlign.right,
                    //             //             style: TextStyle(
                    //             //               fontFamily: 'Arial',
                    //             //               fontSize: 16,
                    //             //               color: Colors.blue,
                    //             //               fontWeight: FontWeight.w200,
                    //             //             ),
                    //             //           ),
                    //             //         ],
                    //             //       ),
                    //             //     ),
                    //             //   ],
                    //             // ))

                    //             )
                    //             )
                    //             ),
                    SizedBox(
                      height: 30.0,
                    ),

                    Padding(
                        // padding: EdgeInsets.all(15),
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width / 7,
                            bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Need an account?',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 11,
                                color: Colors.blue,
                                //   fontWeight: FontWeight.w200,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SIGNUP();
                                }));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(Icons.vpn_key),
                                  Text(
                                    'Sign up!',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ]))));
}
