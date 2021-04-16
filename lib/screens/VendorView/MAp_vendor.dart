import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:foodtruck/Services/LocationService.dart';
import 'package:foodtruck/Services/Network.dart';
import 'package:foodtruck/Utils/utils.dart';
import 'package:foodtruck/screens/Login_SignupView/login.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:foodtruck/screens/VendorView/VENDORPAGE.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:google_fonts/google_fonts.dart';

class Map_vendor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Map_vendorSample();
  }
}

class Map_vendorSample extends StatefulWidget {
  @override
  State<Map_vendorSample> createState() => Map_vendorSampleState();
}

class Map_vendorSampleState extends State<Map_vendorSample> {
  GlobalKey<ScaffoldState> scaffold_key = GlobalKey<ScaffoldState>();
  PageController _myPage;
  @override
  void initState() {
    super.initState();
    _myPage =
        PageController(initialPage: 0, viewportFraction: 1, keepPage: true);
  }

  @override
  void dispose() {
    _myPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var utils = Provider.of<Utils>(context, listen: false);
    var webservices = Provider.of<WebServices>(context, listen: false);
    var locationValues = Provider.of<LocationService>(context, listen: false);
    return Scaffold(
      key: scaffold_key,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon:Icon(Icons.logout), color: Colors.blue,
            onPressed: ()async{
              final box = GetStorage();
              box.remove('token');
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return Login();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },),
          Image.asset(
            'assets/images/truckIcon.png',
            width: 100,
          ),
          SizedBox(
            width: 8,
          )
        ],
        backgroundColor: Colors.white,
        title: Row(
          children: [
            FutureBuilder(
                future: webservices.get_all_vendor_current_location(
                  context: context,
                  location_latitude: locationValues.location_latitude,
                  location_longtitude: locationValues.location_longitude,
                  range_value: 100,
                ),
                builder: (context, snapshots) {
                  if (snapshots.hasData) {
                    return Text(
                        '${snapshots.data == null ? 0 : snapshots.data.length} VENDORS ONLINE',
                        // style: TextStyle(
                        //   color: Colors.blue,
                        //   fontSize: 15,
                        // ),
                        style: GoogleFonts.poppins(
                          // textStyle: Theme.of(context).textTheme.display1,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: Colors.blue,
                        ),
                        overflow: TextOverflow.visible);
                  } else if (snapshots.hasError) {
                    return Text('${snapshots.error}');
                  }
                  return Center(child: CircularProgressIndicator());
                }),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: IconButton(
                  onPressed: utils.view
                      ? () {
                          setState(() {
                            utils.changeView(false);
                            _myPage.jumpToPage(1);
                          });
                        }
                      : () {
                          setState(() {
                            utils.changeView(true);
                            _myPage.jumpToPage(0);
                          });
                        },
                  icon: Icon(utils.view ? Icons.view_list : Icons.my_location,
                      color: Colors.blue)),
            ),

          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          return showDialog(
              builder:(context)=> BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: AlertDialog(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  content: Container(
                    height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Oops!!',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              child: Center(
                                child: Text(
                                  'DO YOU WANT TO EXIT THIS APP?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(26),
                                elevation: 2,
                                child: Container(
                                  height: 35,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(26)),
                                  child: FlatButton(
                                    onPressed: () {
                                      return exit(0);
                                    },
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(26)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 190.0, minHeight: 53.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Yes",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            // fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(26),
                                elevation: 2,
                                child: Container(
                                  height: 35,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(26)),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(26)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 190.0, minHeight: 53.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "No",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            // fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
              context: context);
        },
        child: PageView(
          controller: _myPage,
          physics: NeverScrollableScrollPhysics(),
          children: [
            bodywidget(),
            listMap(),
          ],
        ),
      ),
    );
  }
}


class listMap extends StatefulWidget {
  @override
  _listMapState createState() => _listMapState();
}

class _listMapState extends State<listMap> {
  var range_value = 50.0;
  @override
  Widget build(BuildContext context) {
    var locationValues = Provider.of<LocationService>(context, listen: false);
    var webservices = Provider.of<WebServices>(context, listen: false);
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.7, 0.9],
          colors: [
            Color(0xffECF7FF),
            Colors.white,
          ],
        ),
      ),
      child: FutureBuilder(
          future: webservices.get_all_vendor_current_location(
            context: context,
            location_latitude: locationValues.location_latitude,
            location_longtitude: locationValues.location_longitude,
            range_value: range_value,
          ),
          builder: (context, snapshots) {
            if (snapshots.hasData) {
              return ListDetails(snapshots, locationValues, context);
            } else if (snapshots.hasError) {
              return Text('${snapshots.error}');
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget ListDetails(snapshots, locationValues, context) {
    var webservices = Provider.of<WebServices>(context, listen: false);
    var locationValues = Provider.of<LocationService>(context, listen: false);
    return ListView.builder(
        itemCount: snapshots.data == null ? 0 : snapshots.data.length,
        itemBuilder: (context, index) {
          if (snapshots.connectionState == ConnectionState.done) {
            return FutureBuilder(
                future: webservices.location_profile(snapshots.data[index].id),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return VENDORPAGE(
                                  id: snapshots.data[index].id,
                                  lan: double.parse(snapshots.data[index].Lan),
                                  log: double.parse(snapshots.data[index].Log));
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 110,
                            height: 80.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(snapshot.data == null
                                    ? ''
                                    : snapshot.data[0].pro_pic),
                                fit: BoxFit.fill,
                              ),
                              border: Border.all(
                                  width: 1.0,
                                  color: Colors.blue.withOpacity(0.3)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${snapshot.data == null ? '' : snapshot.data[0].business_name.toString()}',
                                  // style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 20,
                                  //     color: Color(0xff67b9fb)),
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff67b9fb)),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                VendorRating(
                                  snapshots.data[index].id,
                                ),
                                Text(
                                  '${snapshot.data == null ? '' : snapshot.data[0].unique_detail.toString()}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff2699fb)),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '${snapshots.data[index].distance.toStringAsFixed(1)}' +
                                        ' MILES AWAY',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff2699fb),
                                        height: .5),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Divider(
                                  color: Colors.blue,
                                  thickness: 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Text('');
          }
        });
  }

  Widget VendorRating(id) {
    var webservices = Provider.of<WebServices>(context, listen: false);
    return FutureBuilder(
        future: webservices.get_vendor_rating(vendor_id: id, context: context),
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

class bodywidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return bodywidgetstate();
  }
}

class bodywidgetstate extends State<bodywidget> {
  BitmapDescriptor custom_marker;
  BitmapDescriptor custom_user_marker;
  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
              size: Size(1.5, 1.5),
            ),
            'assets/images/truckmarkerBlue.png')
        .then((v) {
      custom_marker = v;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(1.5, 1.5)),
            'assets/images/homemarkerBlue.png')
        .then((v) {
      custom_user_marker = v;
    });
  }

  Completer<GoogleMapController> _controller = Completer();
  var marker = Set<Marker>();
  var zoom_value = 12.0;
  var index_value;
  var range_value = 50.0;

  @override
  Widget build(BuildContext context) {
    var locationValues = Provider.of<LocationService>(context, listen: false);
    var webservices = Provider.of<WebServices>(context, listen: false);
    // TODO: implement build
    return FutureBuilder(
        future: webservices.get_all_vendor_current_location(
          context: context,
          location_latitude: locationValues.location_latitude,
          location_longtitude: locationValues.location_longitude,
          range_value: range_value,
        ),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            return MapDetails(snapshots, locationValues, context);
          } else if (snapshots.hasError) {
            return Text('${snapshots.error}');
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget MapDetails(snapshots, locationValues, context) {
    var webservices = Provider.of<WebServices>(context, listen: false);
    var locationValues = Provider.of<LocationService>(context, listen: false);
    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        marker.clear();
        for (index_value in snapshots.data) {
          marker.add(Marker(
              infoWindow: InfoWindow(title: '${index_value.distance} Meters'),
              markerId: MarkerId(index_value.user.toString()),
              icon: custom_marker,
              position: LatLng(double.parse(index_value.Lan),
                  double.parse(index_value.Log))));
        }

        marker.add(Marker(
            markerId: MarkerId('current location'),
            icon: custom_user_marker,
            position: LatLng(locationValues.location_latitude,
                locationValues.location_longitude)));

        return Stack(
          children: <Widget>[
            Container(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  zoom: zoom_value,
                  target: LatLng(locationValues.location_latitude,
                      locationValues.location_longitude),
                ),
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                },
                markers: marker,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 40,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.blue[700],
                      inactiveTrackColor: Colors.blue[100],
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 5.0,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: Colors.lightBlueAccent,
                      overlayColor: Colors.blue.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.blue[700],
                      inactiveTickMarkColor: Colors.blue[100],
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.lightBlueAccent,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      value: range_value,
                      min: 0.0,
                      max: 100,
                      divisions: 20,
                      label: '$range_value',
                      onChanged: (value) {
                        setState(
                          () {
                            range_value = value;
                            bodywidget();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 210,
                alignment: Alignment.bottomCenter,
                child: PageView.builder(
                    onPageChanged: (index) async {
                      GoogleMapController controller = await _controller.future;
                      return controller.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              bearing: 45,
                              tilt: 50,
                              zoom: 17,
                              target: LatLng(
                                double.parse(snapshots.data[index].Lan),
                                double.parse(snapshots.data[index].Log),
                              ))));
                    },
                    itemCount: snapshots.data.length,
                    scrollDirection: Axis.horizontal,
                    controller: PageController(viewportFraction: 0.65),
                    itemBuilder: (context, index) {
                      if (snapshots.connectionState == ConnectionState.done) {
                        return FutureBuilder(
                            future: webservices
                                .location_profile(snapshots.data[index].id),
                            builder: (context, snapshot) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10, right: 15),
                                child: InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return VENDORPAGE(
                                              id: snapshots.data[index].id,
                                              lan: double.parse(
                                                  snapshots.data[index].Lan),
                                              log: double.parse(
                                                  snapshots.data[index].Log));
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color:
                                                Colors.black54.withOpacity(0.1),
                                            blurRadius: 1,
                                            offset: Offset(5, 4),
                                          )
                                        ]),
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              width: 300,
                                              height: 200.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      snapshot.data == null
                                                          ? ''
                                                          : snapshot
                                                              .data[0].pro_pic),
                                                  fit: BoxFit.fill,
                                                ),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: Colors.blue
                                                        .withOpacity(.1)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 300,
                                          height: 200,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CustomPaint(
                                              size: Size(300,
                                                  50), //You can Replace this with your desired WIDTH and HEIGHT
                                              painter: RPSCustomPainter(),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 170,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 8,
                                            ),
                                            child: Text(
                                              '${snapshots.data[index].distance.toStringAsFixed(1)} ' +
                                                  ' mi. ',
                                              // style: TextStyle(
                                              //     fontWeight: FontWeight.w300,
                                              //     color: Colors.white,
                                              //     fontSize: 19),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                              softWrap: false,
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 100,
                                          top: 140,
                                          child: Container(
                                            width: 150,
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${snapshot.data == null ? '' : snapshot.data[0].business_name.toString()}',
                                                  // style: TextStyle(
                                                  //     fontWeight:
                                                  //         FontWeight.bold,
                                                  //     fontSize: 15),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.black),

                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                                Text(
                                                  '${snapshot.data == null ? '' : snapshot.data[0].unique_detail.toString()}',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                                VendorRating(
                                                  snapshots.data[index].id,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget VendorRating(id) {
    var webservices = Provider.of<WebServices>(context, listen: false);
    return FutureBuilder(
        future: webservices.get_vendor_rating(vendor_id: id, context: context),
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

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = Color.fromARGB(218, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(size.width, size.height * 0.70);
    path_0.lineTo(size.width * 0.85, size.height * 0.70);
    path_0.lineTo(size.width * 0.75, size.height * 0.70);
    path_0.quadraticBezierTo(size.width * 0.53, size.height * 0.70,
        size.width * 0.45, size.height * 0.70);
    path_0.quadraticBezierTo(size.width * 0.12, size.height * 0.71,
        size.width * 0.10, size.height * 0.90);
    path_0.lineTo(size.width * 0.10, size.height);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(size.width, size.height * 0.70);
    path_0.close();

    canvas.drawPath(path_0, paint_0);

    Paint paint_1 = new Paint()
      ..color = Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_1 = Path();
    path_1.moveTo(0, size.height);
    path_1.lineTo(0, size.height * 0.80);
    path_1.lineTo(size.width * 0.20, size.height * 0.80);
    path_1.quadraticBezierTo(size.width * 0.28, size.height * 0.80,
        size.width * 0.35, size.height * 0.90);
    path_1.quadraticBezierTo(
        size.width * 0.37, size.height * 0.93, size.width * 0.40, size.height);
    path_1.lineTo(0, size.height);
    path_1.close();

    canvas.drawPath(path_1, paint_1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
