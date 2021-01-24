import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:foodtruck/Services/Network.dart';
import 'package:foodtruck/screens/VendorView/VendorAddMenu.dart';
import 'package:foodtruck/screens/VendorView/menuitemdetail.dart';
import 'package:foodtruck/screens/VendorView/vendoreditmenu.dart';
import 'package:foodtruck/Services/admob.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:provider/provider.dart';

class VendorPageSeeAllMenu extends StatefulWidget {
  var user_id;
  var subcription_id;
  var vendor_phone;

  VendorPageSeeAllMenu({this.user_id, this.subcription_id, this.vendor_phone});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VendorPageSeeAllMenuState();
  }
}

class VendorPageSeeAllMenuState extends State<VendorPageSeeAllMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  Container(
                    color: Colors.white,
                    child: AdmobBanner(
                      adUnitId: Provider.of<AdmobService>(context, listen: false).getBannerAdUnitId(),
                      adSize: AdmobBannerSize.BANNER,
                      listener: (AdmobAdEvent event, Map<String, dynamic> args){

                      },
                    )
                  ),
      appBar: AppBar(
        leading: InkWell(
              onTap: () {
                return Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.black)),
        actions: <Widget>[
         Image.asset('assets/images/truckIcon.png', width: 100,),
         SizedBox(width: 8,)
        ],
        backgroundColor: Colors.white,
        title: Text('All Vendor Menu', style: TextStyle(color: Colors.black), overflow: TextOverflow.visible,),
      ),
      backgroundColor: Colors.white,
      body: See_All_Menu_Items_Widget(),
    );
  }

  Widget See_All_Menu_Items_Widget() {
    var webservices = Provider.of<WebServices>(context, listen: false);
    return FutureBuilder(
                  future: webservices.location_menu(
                      widget.user_id, widget.subcription_id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == 'VENDOR MENU IS UNAVAILABLE') {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${snapshot.data}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black38),
                          ),
                        ));
                      } else if (snapshot.data == 'Connection Error') {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${snapshot.data}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38)),
                        ));
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data.length == 0 ? 0 : snapshot.data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return menuitemdetail(
                                              menu_description: snapshot
                                                  .data[index].menu_description,
                                              menu_picture1: snapshot
                                                  .data[index].menu_picture1,
                                              menu_price:
                                                  snapshot.data[index].menu_price,
                                              menu_title: snapshot
                                                  .data[index].menu_title,
                                                vendor_phone: widget.vendor_phone,
                                            );
                                          },
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 60.0,
                                        height: 55.0,
                                        decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: NetworkImage(snapshot
                                                .data[index].menu_picture1
                                                .toString()),
                                            fit: BoxFit.cover,
                                          ),
                                          border: Border.all(
                                              width: 1.0,
                                              color: const Color(0xff707070)),
                                        ),
                                      ),
                                      title: Text(
                                        '${snapshot.data[index].menu_title}',
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 14,
                                          color: const Color(0xff2699fb),
                                          height: 1.3571428571428572,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      subtitle: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                '${snapshot.data[index].menu_description}',
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  fontSize: 14,
                                                  color:
                                                      const Color(0xff2699fb),
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                '${snapshot.data[index].menu_price}\$',
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  fontSize: 17,
                                                  color:
                                                      const Color(0xff2699fb),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                  );
                          },
                        );
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  });
    
    
    
    
   
  }
}
