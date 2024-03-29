import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodtruck/Services/LocationService.dart';
import 'package:foodtruck/Services/Network.dart';
import 'package:foodtruck/screens/Login_SignupView/login.dart';
import 'package:foodtruck/screens/VendorView/ManageVendorSubScription.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:foodtruck/screens/VendorView/VENDORprofile.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Map_user extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold_key,
      drawer: SafeArea(
        child: SizedBox(
          width: 250,
          child: Drawer(
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Container(
                          width: 150,
                          height: 100,
                          child: Image.asset('assets/images/logotruck.png')),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return VENDORprofile();
                    }));
                  },
                  title: Text('Profile'),
                  leading: Icon(Icons.person),
                ),
                Divider(),
//                ListTile(
//                  title: Text('ABOUT APP'),
//                  leading: Icon(Icons.info_outline),
//                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            scaffold_key.currentState.openDrawer();
          },
          child: Image.asset(
            'assets/images/menuIcon.png',
            scale: 1.2,
          ),
        ),
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
        centerTitle: false,
        title: Text(
          'Current Users',
          style: TextStyle(color: Colors.blue),
          overflow: TextOverflow.visible,
        ),
      ),
      body: bodywidget(),
    );
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
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;
  var marker = Set<Marker>();
  var zoom_value = 12.0;
  var index_value;
  var range_value = 50.0;

  initState() {
    super.initState();
    _mapStyle = bodywidgetstate.loadString('assets/mapstyle.txt');
  }

  @override
  Widget build(BuildContext context) {
    var locationValues = Provider.of<LocationService>(context, listen: false);
    var webservices = Provider.of<WebServices>(context, listen: false);
    // TODO: implement build
    return WillPopScope(
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
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  onPressed: () {
                                    return exit(0);
                                  },

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
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },

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
      child: FutureBuilder(
          future: webservices.Vendor_Profile_Api(),
          builder: (context, snapshot_profile) {
            return snapshot_profile.hasData
                ? FutureBuilder(
                    future: webservices.get_vender_subscription_id(),
                    builder: (context, subscription_id_snapshot) {
                      return subscription_id_snapshot.hasData
                          ? FutureBuilder(
                              future: webservices.get_all_user_current_location(
                                context: context,
                                location_latitude:
                                    locationValues.location_latitude,
                                location_longtitude:
                                    locationValues.location_longitude,
                                range_value: range_value,
                                subscription_id: subscription_id_snapshot
                                    .data['subscription_id'],
                              ),
                              builder: (context, snapshots) {
                                if (snapshots.hasData) {
                                  if (snapshots.data ==
                                      'Subscribe to get online Users and Display your Menu') {
                                    return SubscriptionView(
                                        snapshots,
                                        locationValues,
                                        snapshot_profile.data[0].id);
                                  } else if (snapshots.data ==
                                          'Connection Error' ||
                                      snapshots.data == 'MENU IS UNAVAILABLE') {
                                    return ConnectionErrorView(
                                        snapshots, locationValues);
                                  } else {
                                    return CurrentUserView(
                                        snapshots, locationValues);
                                  }
                                } else if (snapshots.hasError) {
                                  return Text('${snapshots.error}');
                                }
                                return Center(child: CupertinoActivityIndicator(radius: 20,));
                              })
                          : Center(child: CupertinoActivityIndicator(radius: 20,));
                    })
                : Center(child: CupertinoActivityIndicator(radius: 20,));
          }),
    );
  }

  Widget CurrentUserView(snapshots, locationValues) {
    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        marker.clear();
        for (index_value in snapshots.data) {
          marker.add(Marker(
              markerId: MarkerId(index_value.user.toString()),
              icon: BitmapDescriptor.defaultMarker,
              position: LatLng(double.parse(index_value.Lan),
                  double.parse(index_value.Log))));
        }

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
                  controller.setMapStyle(_mapStyle);
                },
                markers: marker,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 250,
                  height: 100,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.8),
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
                    itemBuilder: (context, index) {
                      return Builder(
                        builder: (context) {
                          if (snapshots.connectionState ==
                              ConnectionState.done) {
                            return FittedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  width: 250,
                                  height: 140,
                                  child:  Card(
                                      color: Color(0xFF67b9fb).withOpacity(0.2),
                                      child: Container(
                                        width: 250,
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8),
                                              child: InkWell(
                                                onTap: () async {
                                                  GoogleMapController
                                                      controller =
                                                      await _controller.future;
                                                  return controller
                                                      .animateCamera(CameraUpdate
                                                          .newCameraPosition(
                                                              CameraPosition(
                                                                  bearing: 45,
                                                                  tilt: 50,
                                                                  zoom: 17,
                                                                  target:
                                                                      LatLng(
                                                                    double.parse(
                                                                        snapshots
                                                                            .data[index]
                                                                            .Lan),
                                                                    double.parse(
                                                                        snapshots
                                                                            .data[index]
                                                                            .Log),
                                                                  ))));
                                                },
                                                child: Container(
                                                  height: 80,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xff8acbff),
                                                        Color(0xff67b9fb)
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                    ),
                                                    shape: BoxShape.circle,
                                                    color: Colors.lightBlue,
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                      top: 5.0, bottom: 5),
                                                  child: Center(
                                                    child: Text(
                                                      'Focus\n View',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'Futura',
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 200,
                                              child: Divider(
                                                color: Colors.black,
                                                indent: 5,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8,
                                              ),
                                              child: Text(
                                                '${snapshots.data[index].distance} ' +
                                                    ' MILES AWAY',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 20),
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            );
                          } else {
                            return Center(child:CupertinoActivityIndicator(radius: 20,));
                          }
                        },
                      );
                    },
                  ),
                ),
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
          ],
        );
      },
    );
  }

  Widget ConnectionErrorView(snapshots, locationValues) {
    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Stack(
          children: <Widget>[
            Container(
              child: GoogleMap(
                markers: {
                  Marker(
                      markerId: MarkerId('user'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(locationValues.location_latitude,
                          locationValues.location_longitude))
                },
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  zoom: zoom_value,
                  target: LatLng(locationValues.location_latitude,
                      locationValues.location_longitude),
                ),
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                child: FittedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 120,
                      child:  Card(
                          child: Container(
                            width: 250,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8,
                                    top: 40,
                                  ),
                                  child: Text(
                                      '${snapshots.data}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget SubscriptionView(snapshots, locationValues, snapshotprofile) {
    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Stack(
          children: <Widget>[
            Container(
              child: GoogleMap(
                markers: {
                  Marker(
                      markerId: MarkerId('user'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(locationValues.location_latitude,
                          locationValues.location_longitude))
                },
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  zoom: zoom_value,
                  target: LatLng(locationValues.location_latitude,
                      locationValues.location_longitude),
                ),
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                child: FittedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 120,
                      child:  Card(
                          child: Container(
                            width: 250,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8,
                                  ),
                                  child: Text(
                                      '${snapshots.data}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                ),
                                ActionChip(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return managesubscription(
                                              snapshotprofile);
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
                                  elevation: 2,
                                  backgroundColor: Colors.lightBlue,
                                  label: Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0, bottom: 5),
                                    child: Text(
                                      'Subscribe',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  static loadString(String s) {}
}
