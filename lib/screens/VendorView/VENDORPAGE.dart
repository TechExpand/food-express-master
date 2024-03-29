import 'dart:io';
import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:foodtruck/Services/LocationService.dart';
import 'package:foodtruck/Services/Network.dart';
import 'package:foodtruck/screens/VendorView/VendorPageSeeAllMenu.dart';
import 'package:foodtruck/Services/admob.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:foodtruck/screens/VendorView/menuitemdetail.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:google_fonts/google_fonts.dart';

class VENDORPAGE extends StatefulWidget {
  int id;
  double lan;
  double log;

  VENDORPAGE({
    this.id,
    this.lan,
    this.log,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VENDORPAGESTATE();
  }
}

class VENDORPAGESTATE extends State<VENDORPAGE> {
  var profile;
  var menu;
  BitmapDescriptor custom_marker;

  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
              size: Size(0.5, 0.5),
            ),
            'assets/images/truckmarkerBlue.png')
        .then((v) {
      custom_marker = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();
    GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
    var webservices = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: Container(
          color: Colors.white,
          child: AdmobBanner(
            adUnitId: Provider.of<AdmobService>(context, listen: false)
                .getBannerAdUnitId(),
            adSize: AdmobBannerSize.BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
          )),
      key: scaffoldKey,
      backgroundColor: const Color(0xffffffff),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Colors.blue[400],
              Color(0xffDAF0FF),
              Color(0xffECF7FF),
              Colors.white,
            ],
          ),
        ),
        child: FutureBuilder(
            future: webservices.location_profile(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PageView.builder(
                    itemCount: snapshot.data.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListView(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                color: Color(0xFF67b9fb),
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(widget.lan, widget.log),
                                      zoom: 15),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                  markers: {
                                    Marker(
                                        icon: custom_marker,
                                        markerId: MarkerId('1'),
                                        position:
                                            LatLng(widget.lan, widget.log))
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.width /
                                            8,
                                        left:
                                            MediaQuery.of(context).size.width /
                                                20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.8),
                                          shape: BoxShape.circle),
                                      width: 60,
                                      height: 60,
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Container(
                            width:MediaQuery.of(context).size.width,
                            height: 150.0,
                            child: Row(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 130.0,
                                  height: 130.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: NetworkImage(snapshot
                                          .data[index].pro_pic
                                          .toString()),
                                      fit: BoxFit.fill,
                                    ),
                                    border: Border.all(
                                        width: 1.0,
                                        color: Colors.blue.withOpacity(0.8)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child:  Text(
                                        "${snapshot.data[index].business_name.toString()}",
                                        style: GoogleFonts.poppins(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff2699fb)),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),

                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      height: 30,
                                      child: VendorRating(webservices),
                                    ),
                                  )
                                ]),
                              )
                            ]),
                            decoration: BoxDecoration(
                                // color: const Color(0xff339EFF),
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${snapshot.data[index].detail.toString()}",
                                // style: TextStyle(
                                //   fontFamily: 'Arial',
                                //   fontSize: 14,
                                //   color: const Color(0xff2699fb),
                                // ),
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff2699fb)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'WHAT WE SPECIALIZE IN',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff2699fb),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${snapshot.data[index].unique_detail.toString()}",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff2699fb)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'OUR MENU',
                                style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff2699fb)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          MenuVendor(
                              snapshot.data[index].phone,
                              snapshot.data[index].subID,
                            widget.id,
                              snapshot.data[index].id,
                              ),
                          Rating(scaffoldKey, context, widget.id)
                        ],
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Widget Rating(scaffoldKey, context, vendor_id) {
    var rate_value;
    var webservices = Provider.of<WebServices>(context, listen: false);
    return  ExpansionTile(
        title: Text('Tap to Rate this Vendor!'),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SmoothStarRating(
              allowHalfRating: false,
              size: 35,
              onRated: (value) {
                rate_value = value;
              },
              color: Color(0xFF67b9fb),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Rate this Vendor',
              style: TextStyle(color: Colors.black45),
            ),
          ),
          Consumer<WebServices>(
            builder: (context, webservices_consumer, child) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: webservices_consumer.login_state == false
                    ? TextButton.icon(
                       style: TextButton.styleFrom(
                         backgroundColor: Colors.blue,
                       ),
                        onPressed: () {
                          if (!rate_value.isNaN) {
                            webservices.Login_SetState_third();
                            webservices.PostRating(
                              lanlog: vendor_id,
                              context: context,
                              scaffoldKey: scaffoldKey,
                              rate: rate_value,
                            );
                          }
                        },
                        icon: Icon(Icons.rate_review, color: Colors.white),
                        label: Text(
                          'Submit Rating',
                          style: TextStyle(color: Colors.white),
                        ))
                    : CircularProgressIndicator()),
          ),
        ],
    );
  }

  Widget MenuVendor(vendor_phone, subcription_id, lanlog_id, user_id) {
    var webservices = Provider.of<WebServices>(context, listen: false);
    return FutureBuilder(
        future: webservices.location_menu(lanlog_id, subcription_id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'VENDOR MENU IS UNAVAILABLE') {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${snapshot.data}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black38),
                ),
              ));
            } else if (snapshot.data == 'Connection Error') {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${snapshot.data}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black38)),
              ));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount:
                    snapshot.data.length == 0 ? 0 : snapshot.data.length + 1,
                itemBuilder: (context, index) {
                  return index == snapshot.data.length
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return VendorPageSeeAllMenu(
                                    vendor_phone: vendor_phone,
                                    user_id: user_id,
                                    subcription_id: subcription_id,
                                  );
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, top: 8, bottom: 15),
                            child: Text('View Full Menu...',
                                style: TextStyle(
                                    color: Color(0xFF67b9fb),
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20)),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return menuitemdetail(
                                    menu_description:
                                        snapshot.data[index].menu_description,
                                    menu_picture1:
                                        snapshot.data[index].menu_picture1,
                                    menu_price: snapshot.data[index].menu_price,
                                    menu_title: snapshot.data[index].menu_title,
                                    vendor_phone: vendor_phone,
                                  );
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
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
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(1.0, 1.0),
                                    blurRadius: .5,
                                    spreadRadius: .5,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(snapshot
                                      .data[index].menu_picture1
                                      .toString()),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                    width: 1.0,
                                    color: Colors.blue.withOpacity(.1)),
                              ),
                            ),
                            title: Text(
                              '${snapshot.data[index].menu_title}',
                              // style: TextStyle(
                              //   fontFamily: 'Arial',
                              //   fontSize: 24,
                              //   color: const Color(0xff2699fb),
                              //   height: 1.3571428571428572,
                              // ),
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff2699fb),
                                  height: 1.7),
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
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff2699fb),
                                          height: .4),
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
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff2699fb),
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

  Widget VendorRating(webservices) {
    return FutureBuilder(
        future: webservices.get_vendor_rating(
            vendor_id: widget.id, context: context),
        builder: (context, snapshot) {
          var rate = 0;
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return SmoothStarRating(
                  allowHalfRating: false,
                  isReadOnly: true,
                  rating: 0,
                  size: 17,
                  color: Color(0xff67b9fb),
                );
            } else if (snapshot.data == 'failed to get rating' ||
                snapshot.data == 'failed') {
              return Text('${snapshot.data}');
            } else {
              for (var index in snapshot.data) {
                rate = rate + index.rate;
              }
              var average_rate = rate / snapshot.data.length;

              return SmoothStarRating(
                allowHalfRating: false,
                isReadOnly: true,
                rating: average_rate == null ? 0.0 : average_rate,
                size: 17,
                color: Color(0xff67b9fb),
              );
            }
          } else {
            return Text(
              'Loading...',
              style: TextStyle(
                  color: Color(0xff67b9fb), fontWeight: FontWeight.bold),
            );
          }
        });
  }
}
