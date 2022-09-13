import 'package:admob_flutter/admob_flutter.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:foodtruck/Services/LocationService.dart';
import 'package:foodtruck/Utils/utils.dart';
import 'package:foodtruck/Services/admob.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class menuitemdetail extends StatelessWidget {
  var menu_description;
  var vendor_phone;
  var menu_price;
  var menu_title;
  var menu_picture1;

  menuitemdetail(
      {this.menu_description,
      this.menu_title,
      this.menu_price,
      this.menu_picture1,
      this.vendor_phone});
  @override
  Widget build(BuildContext context) {
    var utils = Provider.of<Utils>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: Container(
          color: Colors.white,
          child: AdmobBanner(
            adUnitId: Provider.of<AdmobService>(context, listen: false)
                .getBannerAdUnitId(),
            adSize: AdmobBannerSize.BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
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
        centerTitle: true,
        title: Text(
          'Menu Item',
          style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: const Color(0xff2699fb),
              height: 1.7),
          overflow: TextOverflow.visible,
        ),
        leading: InkWell(
            onTap: () {
              return Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
      ),
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Carousel(
                  dotSize: 5,
                  dotSpacing: 15.0,
                  dotColor: Colors.white,
                  indicatorBgPadding: 5.0,
                  dotBgColor: Color(0xff2699fb).withOpacity(0.5),
                  images: [
                    NetworkImage(menu_picture1.toString()),
                  ],
                ),
                height: 200.0,
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${menu_title.toString()}',
                    style: GoogleFonts.poppins(
                        fontSize: 44,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff2699fb),
                        height: 1.7),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Menu Details',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff2699fb),
                        height: 1.7),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '\$${menu_price.toString()}',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff2699fb),
                        height: 1.7),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '${menu_description.toString()}',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff2699fb),
                        height: 1.7),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.all(0.0),
                  ),
                  onPressed: () {
                    return utils.makePhoneCall('tel:$vendor_phone');
                  },

                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff67b9fb), Color(0xff8acbff)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(23)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Contact Vendor",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.7),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
