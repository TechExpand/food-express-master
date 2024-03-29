import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodtruck/Model/currentuserlocation.dart';
import 'package:foodtruck/Model/currentvendorlocation.dart';
import 'package:foodtruck/Model/locationprofilemenudetails.dart';
import 'package:foodtruck/Model/rating.dart';
import 'package:foodtruck/Model/vendorprofile.dart';
import 'package:foodtruck/Services/LocationService.dart';
import 'package:foodtruck/Utils/utils.dart';
import 'package:foodtruck/screens/UserView/Map_user.dart';
import 'package:foodtruck/screens/VendorView/MAp_vendor.dart';
import 'package:foodtruck/screens/VendorView/SubscribePage.dart';
import 'package:foodtruck/screens/VendorView/VENDORSIGNUP_INFO.dart';
import 'package:foodtruck/screens/VendorView/VENDORprofile.dart';
import 'package:foodtruck/screens/VendorView/VendorMenuPage.dart';
import 'package:foodtruck/screens/video.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebServices extends ChangeNotifier {
  var vendor_signup_res;
  var token;
  var user_signup_res;
  var vendor_profile_res;
  var user_profile_res;
  var vendor_login_res;
  var vendor_menu_data = List();
  var location_menu_data = List();
  var vendor_info_res;
  var user_login_res;
  var vendor_sub_res;
  var update_online_offline_res;
  var login_state = false;
  var login_state_second = false;
  var login_state_third = false;
  var value;
  var isLoading = false;
  final box = GetStorage();

  void Login_SetState() {
    if (login_state == false) {
      login_state = true;
    } else {
      login_state = false;
    }
    notifyListeners();
  }

  void Login_SetState_Second() {
    if (login_state_second = false) {
      login_state_second = true;
    } else {
      login_state_second = false;
    }
    notifyListeners();
  }

  void Login_SetState_third() {
    if (login_state_third == false) {
      login_state_third = true;
    } else {
      login_state_third = false;
    }
    notifyListeners();
  }

//"""GET REQUEST ""

  Future location_profile(id) async {
    try {
      var res = await http.get(
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/locationprofile/${id.toString()}'),
          headers: {
            "Accept": "application/json",
            "Authorization": '${token['auth_token']}'
          });
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body) as List;
        List<LocationProfileDetail> location_profile_objects = body
            .map((location_profile_json) =>
                LocationProfileDetail.fromJson(location_profile_json))
            .toList();

        return location_profile_objects;
      } else {
        throw 'Cant get profile details';
      }
    } catch (e) {}
  }

  Future location_menu(id, subscription_id) async {
    print(subscription_id);
    print(id);
    try {
      var res = await http.get(
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/locationmenu/id=${id.toString()}/sub_id=${subscription_id.toString()}/'),
          headers: {
            "Accept": "application/json",
            "Authorization": '${token['auth_token']}'
          });
      print(res.body);
      print(res.body);
      print(res.body);
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        if (body == 'VENDOR MENU IS UNAVAILABLE') {
          return body;
        } else if (body == 'Connection Error') {
          var body = jsonDecode(res.body);
          return body;
        } else {
          var body = jsonDecode(res.body) as List;
          List<LocationMenuDetail> location_menu_objects = body
              .map((location_menu_json) =>
                  LocationMenuDetail.fromJson(location_menu_json))
              .toList();
          return location_menu_objects;
        }
      }
    } catch (e) {}
  }

  Future Vendor_Profile_Menu() async {
    try {
      var res = await http.get(
          Uri.parse('https://app.foodtruck.express/foodtruck-vendor/menu/'),
          headers: {
            "Accept": "application/json",
            "Authorization": 'Token ${token['auth_token']}'
          });
      if (res.statusCode == 200) {
        var body = res.body;
        var data = jsonDecode(body);
        var result = data['results'] as List;
        List<LocationMenuDetail> vendor_menu_objects = result
            .map((vendor_menu_json) =>
                LocationMenuDetail.fromJson(vendor_menu_json))
            .toList();
        return vendor_menu_objects;
      }
    } catch (e) {}
  }

  Future Vendor_InfoApi(
      {business_name, unique_detail, detail, phone, path, context}) async {
    try {
      var upload = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/createprofile/'));
      var file = await http.MultipartFile.fromPath('pro_pic', path);

      upload.files.add(file);
      upload.fields['business_name'] = business_name.toString();
      upload.fields['unique_detail'] = unique_detail.toString();
      upload.fields['detail'] = detail.toString();
      upload.fields['phone'] = phone.toString();
      upload.fields['lanlog'] = '';
      upload.fields['user'] = '';
      upload.headers['authorization'] = 'Token ${token['auth_token']}';

      final stream = await upload.send();
      vendor_info_res = await http.Response.fromStream(stream);

      var body = jsonDecode(vendor_info_res.body);
      if (vendor_info_res.statusCode == 200 ||
          vendor_info_res.statusCode == 201) {
        Login_SetState();
        showDialog(
          barrierDismissible: false,
            builder: (context) => WillPopScope(
              onWillPop: ()async{
                return false;
              },
              child: AlertDialog(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    content: Container(
                      height: 350,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Icon(Icons.monetization_on,
                                size: 90, color: Color(0xFF67b9fb)),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            width: 250,
                            child: Text(
                              'Would you like to upgrade your subscription which allows customers to view all your '
                              'uploaded menu items and also allow you view customers locations',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Container(
                            width: 250,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Material(
                                  borderRadius: BorderRadius.circular(26),
                                  elevation: 2,
                                  child: Container(
                                    height: 40,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Color(0xFFE60016)),
                                        borderRadius: BorderRadius.circular(26)),
                                    child: TextButton(
                                      onPressed: () {
                                        // Navigator.of(context).pop();
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                          return Map_user();
                                        }));
                                      },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFFE60016),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(26)),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(26)),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 190.0, minHeight: 53.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "No Thanks",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
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
                                    height: 40,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: BorderRadius.circular(26)),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                          return SubscribePage();
                                        }));
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xFFE60016),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(26)),
                                        padding: EdgeInsets.all(0.0),
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(26)),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 190.0, minHeight: 53.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Sign me up!",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
            context: context);
      } else if (vendor_info_res.statusCode == 400) {
        Login_SetState();
        showDialog(
            builder: (context) => AlertDialog(
                  title: Center(
                    child: Text('Check Credentials',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ),
            context: context);
      }
      return vendor_info_res;
    } catch (e) {
      Login_SetState();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  Future Vendor_Subscribe(
      {cvc, expiry_year, expiry_month, card_number, context}) async {
    try {
      var vendor_sub_res = await http.get(
        Uri.parse(
            'https://app.foodtruck.express/foodtruck-vendor/createsubscription/card_number=$card_number&exp_month=$expiry_month&exp_year=$expiry_year&cvc=$cvc/'),
        headers: {
          "Accept": "application/json",
          "Authorization": 'Token ${token['auth_token']}'
        },
      );

      if (vendor_sub_res.statusCode == 200 ||
          vendor_sub_res.statusCode == 201) {
        Login_SetState();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Map_user();
        }));
      } else if (vendor_sub_res.statusCode == 400) {
        Login_SetState();
        showDialog(
            builder: (context) => AlertDialog(
                  title: Center(
                    child: Text('Check Credentials',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ),
            context: context);
      }
      return vendor_sub_res;
    } catch (e) {
      Login_SetState();

      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it $e',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  Future Update_Vendor_to_Online_Offline({
    bool online_offline,
    lan,
    log,
    id,
    online_offline_value,
    color_value,
    scaffoldKey,
    context,
  }) async {
    try {
      var upload = http.MultipartRequest(
          'PUT',
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/vendorlanlog/${id}/'));
      upload.fields['online'] = online_offline.toString();
      upload.fields['Lan'] = lan.toString();
      upload.fields['Log'] = log.toString();
      upload.fields['user'] = '';
      upload.headers['authorization'] = 'Token ${token['auth_token']}';

      final stream = await upload.send();
      update_online_offline_res = await http.Response.fromStream(stream);

      var body = jsonDecode(update_online_offline_res.body);
      if (update_online_offline_res.statusCode == 200 ||
          update_online_offline_res.statusCode == 201) {
        Login_SetState();
        scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text(
          'You are now ${online_offline_value}',
          textAlign: TextAlign.center,
        )));
      } else if (update_online_offline_res.statusCode == 400 ||
          update_online_offline_res.statusCode == 500 ||
          update_online_offline_res.statusCode == 401) {
        Login_SetState();
        showDialog(
            builder: (context) => AlertDialog(
                  title: Center(
                    child: Icon(
                      Icons.signal_cellular_connected_no_internet_4_bar,
                      color: Colors.red,
                    ),
                  ),
                  content: Text('failed'),
                ),
            context: context);
      }
      return update_online_offline_res;
    } catch (e) {
      Login_SetState();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  Future Vendor_Profile_Api() async {
    var vendor_profile_res = await http.get(
        Uri.parse('https://app.foodtruck.express/foodtruck-vendor/profile/'),
        headers: {
          "Accept": "application/json",
          "Authorization": 'Token ${token['auth_token']}'
        });
    if (vendor_profile_res.statusCode == 200) {
      var body = jsonDecode(vendor_profile_res.body) as List;
      List<VendorProfile> vendor_profile_objects = body
          .map((vendor_profile_json) =>
              VendorProfile.fromJson(vendor_profile_json))
          .toList();

      return vendor_profile_objects;
    } else {
      throw 'Cant get vendor profile';
    }
  }

  Future User_Profile_Api() async {
    user_profile_res = await http.get(
        Uri.parse('https://user.foodtruck.express/foodtruck/users/me/'),
        headers: {
          "Accept": "application/json",
          "Authorization": 'Token ${token['auth_token']}'
        });
    if (user_profile_res.statusCode == 200) {
      var body = jsonDecode(user_profile_res.body);
      return body;
    } else {
      throw 'Cant get user profile';
    }
  }

  Future get_all_vendor_current_location(
      {context, location_latitude, location_longtitude, range_value}) async {
    try {
      var res = await http.get(
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/currentvendorslanlog/lan=${location_latitude}&log=${location_longtitude}&range_value=${range_value}/'),
          headers: {
            "Accept": "application/json",
            "Authorization": '${token['auth_token'].toString()}',
          });

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body) as List;
        List<CurrentVendorlocation> vendor_current_location_objects = body
            .map((vendor_current_location_json) =>
                CurrentVendorlocation.fromJson(vendor_current_location_json))
            .toList();
        notifyListeners();
        return vendor_current_location_objects;
      }
    } catch (e) {}
  }

  Future get_current_vendor_location() async {
    var current_vendor_location = await http.get(
        Uri.parse(
            'https://app.foodtruck.express/foodtruck-vendor/vendorlanlog/'),
        headers: {
          "Accept": "application/json",
          "Authorization": 'Token ${token['auth_token']}'
        });


    print(current_vendor_location.statusCode);
    print(current_vendor_location.statusCode);
    print(current_vendor_location.statusCode);
    if (current_vendor_location.statusCode == 200) {
      var body = jsonDecode(current_vendor_location.body) as List;
      List<CurrentVendorlocation> current_vendor_location_objects = body
          .map((current_vendor_location_json) =>
              CurrentVendorlocation.fromJson(current_vendor_location_json))
          .toList();

      return current_vendor_location_objects;
    } else {
      throw 'Cant get vendor location';
    }
  }

  Future get_all_user_current_location(
      {context,
      location_latitude,
      location_longtitude,
      range_value,
      subscription_id}) async {
    //var locationValues = Provider.of<LocationService>(context, listen: false);
    var res = await http.get(
        Uri.parse(
            'https://user.foodtruck.express/foodtruck/currentuserlanlog/lan=${location_latitude}&log=${location_longtitude}&range_value=${range_value}&sub_id=${subscription_id}/'),
        headers: {
          "Accept": "application/json",
          "Authorization": '${token['auth_token']}'
        });

    var body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      if (body == 'Subscribe to get online Users and Display your Menu') {
        return body;
      } else if (body == 'Connection Error') {
        return body;
      } else {
        var body = jsonDecode(res.body) as List;
        List<CurrentUserlocation> user_current_location_objects = body
            .map((user_current_location_json) =>
                CurrentUserlocation.fromJson(user_current_location_json))
            .toList();
        notifyListeners();
        return user_current_location_objects;
      }
    } else {
      throw body;
    }
  }

  Future get_vendor_rating({
    context,
    vendor_id,
  }) async {
    try {
      var res = await http.get(
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/rating/$vendor_id/'),
          headers: {
            "Accept": "application/json",
            "Authorization": '${token['auth_token']}'
          });

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body) as List;
        List<Rating> vendor_rating_objects = body
            .map((vendor_rating_json) => Rating.fromJson(vendor_rating_json))
            .toList();
        notifyListeners();
        return vendor_rating_objects;
      }
    } catch (e) {
      return 'failed to get rating';
    }
  }

  Future get_current_user_location() async {
    var current_user_location = await http.get(
        Uri.parse('https://user.foodtruck.express/foodtruck/userlanlog/'),
        headers: {
          "Accept": "application/json",
          "Authorization": 'Token ${token['auth_token']}'
        });

    print(current_user_location.statusCode);
    print(current_user_location.statusCode);
    print(current_user_location.statusCode);

    if (current_user_location.statusCode == 200) {
      var body = jsonDecode(current_user_location.body) as List;
      List<CurrentUserlocation> current_user_location_objects = body
          .map((current_user_location_json) =>
              CurrentUserlocation.fromJson(current_user_location_json))
          .toList();

      return current_user_location_objects;
    } else {
      throw 'Cant get user location';
    }
  }

  Future get_vender_subscription_id() async {
    var vender_subscription = await http.get(
        Uri.parse(
            'https://app.foodtruck.express/foodtruck-vendor/user/subscription/'),
        headers: {
          "Accept": "application/json",
          "Authorization": 'Token ${token['auth_token']}'
        });
    if (vender_subscription.statusCode == 200) {
      var body = jsonDecode(vender_subscription.body);
      return body[0];
    } else {
      return 'Cant get user subscription';
    }
  }

  Future get_vender_subscription_status(sub_id) async {
    var vender_subscription = await http.get(
        Uri.parse(
            'https://app.foodtruck.express/foodtruck-vendor/subscription/status/sub_id=${sub_id.toString()}'),
        headers: {
          "Accept": "application/json",
          "Authorization": '${token['auth_token']}'
        });
    if (vender_subscription.statusCode == 200) {
      var body = jsonDecode(vender_subscription.body);
      return body;
    } else {
      return 'Cant get user subscription status';
    }
  }

  Future reactivate_subscription(id) async {
    try {
      var vender_subscription = await http.get(
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/createsubscription/'),
          headers: {
            "Accept": "application/json",
            "Authorization": 'Token ${token['auth_token']}'
          });
      var body = jsonDecode(vender_subscription.body);
      await http.put(
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/profile/${id}/'),
          body: {
            'subcription_id': body['subcription_id'],
          },
          headers: {
            "Accept": "application/json",
            "Authorization": 'Token ${token['auth_token']}'
          });
      if (vender_subscription.statusCode == 200) {
        Login_SetState();

        return body['success'];
      } else {
        Login_SetState();
        return 'subscription failed';
      }
    } catch (e) {
      Login_SetState();
    }
  }

  Future cancel_subscription() async {
    try {
      var vender_subscription = await http.get(
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/cancelsubscription/'),
          headers: {
            "Accept": "application/json",
            "Authorization": 'Token ${token['auth_token']}'
          });
      if (vender_subscription.statusCode == 200) {
        Login_SetState();
        var body = jsonDecode(vender_subscription.body);
        return body;
      } else {
        Login_SetState();
        return token['auth_token'].toString();
      }
    } catch (e) {
      Login_SetState();
    }
  }

  Future Set_Default_Payment_Card(
      {card_number, exp_month, exp_year, cvc, context}) async {
    try {
      var vender_subscription = await http.get(
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/addnewcard/card_number=${card_number}&exp_month=${exp_month}&exp_year=${exp_year}&cvc=${cvc}/'),
          headers: {
            "Accept": "application/json",
            "Authorization": 'Token ${token['auth_token']}'
          });

      if (vender_subscription.statusCode == 200) {
        Login_SetState();
        var body = jsonDecode(vender_subscription.body);
        return body;
      }
    } catch (e) {
      Login_SetState();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

////"""POST REQUEST ""
//
//
//
//// sign up request

//
//
//
//
  Future<dynamic> login_before_submit_location_vendor(
      {email, password, context}) async {
    var locationValues = Provider.of<LocationService>(context, listen: false);
    try {
      var upload = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/token/login/'));
      upload.fields['password'] = password.toString();
      upload.fields['email'] = email.toString();
      final stream = await upload.send();
      var response = await http.Response.fromStream(stream);
      token = json.decode(response.body);
    } catch (e) {}
  }

  Future send_vendor_location(context) async {
    var locationValues = Provider.of<LocationService>(context, listen: false);
    try {
      var upload_loc = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/vendorlanlog/'));
      upload_loc.fields['Lan'] = locationValues.location_latitude.toString();
      upload_loc.fields['Log'] = locationValues.location_longitude.toString();
      upload_loc.fields['online'] = 'True';
      upload_loc.fields['user'] = '';
      upload_loc.headers['authorization'] = 'Token ${token['auth_token']}';
      final stream_loc = await upload_loc.send();
      var response_loc = await http.Response.fromStream(stream_loc);
      return '${response_loc.body}';
    } catch (e) {}
  }

  Future Update_User_Location({id, context}) async {
    var locationValues = Provider.of<LocationService>(context, listen: false);
    try {
      var upload = http.MultipartRequest(
          'PUT',
          Uri.parse(
              'https://user.foodtruck.express/foodtruck/userlanlog/${id}/'));
      upload.fields['online'] = 'true';
      upload.fields['Lan'] = locationValues.location_latitude.toString();
      upload.fields['Log'] = locationValues.location_longitude.toString();
      upload.fields['user'] = '';
      upload.headers['authorization'] = 'Token ${token['auth_token']}';
      final stream = await upload.send();
      var update_user_location_res = await http.Response.fromStream(stream);
      print(update_user_location_res.body);
      print(update_user_location_res.body);
      print(update_user_location_res.body);
      var body = jsonDecode(update_user_location_res.body);
      if (update_user_location_res.statusCode == 200 ||
          update_user_location_res.statusCode == 201) {
        return 'User Location Updated';
      } else {
        return 'Location not updated';
      }
      return update_user_location_res;
    } catch (e) {}
  }

  Future Update_Vendor_Location({id, context}) async {
    var locationValues = Provider.of<LocationService>(context, listen: false);
    try {
      var upload = http.MultipartRequest(
          'PUT',
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/vendorlanlog/${id}/'));
      upload.fields['online'] = 'true';
      upload.fields['Lan'] = locationValues.location_latitude.toString();
      upload.fields['Log'] = locationValues.location_longitude.toString();
      upload.fields['user'] = '';
      upload.headers['authorization'] = 'Token ${token['auth_token']}';

      final stream = await upload.send();
      var update_vendor_location_res = await http.Response.fromStream(stream);

      print(update_vendor_location_res.body);
      print(update_vendor_location_res.body);
      print(update_vendor_location_res.body);

      var body = jsonDecode(update_vendor_location_res.body);
      if (update_vendor_location_res.statusCode == 200 ||
          update_vendor_location_res.statusCode == 201) {
        return 'Vendor Location Updated';
      } else {
        'return ${update_vendor_location_res.body}';
      }
      return update_vendor_location_res;
    } catch (e) {
      print('cant update oo');
    }
  }

  Future<dynamic> login_before_submit_location_user(
      {email, password, context}) async {
    var locationValues = Provider.of<LocationService>(context, listen: false);

    try {
      var upload = http.MultipartRequest('POST',
          Uri.parse('https://user.foodtruck.express/foodtruck/token/login/'));
      upload.fields['password'] = password.toString();
      upload.fields['email'] = email.toString();
      final stream = await upload.send();
      var response = await http.Response.fromStream(stream);

      token = json.decode(response.body);
    } catch (e) {}
  }

  Future send_user_location(context) async {
    var locationValues = Provider.of<LocationService>(context, listen: false);
    try {
      var upload_loc = http.MultipartRequest('POST',
          Uri.parse('https://user.foodtruck.express/foodtruck/userlanlog/'));
      upload_loc.fields['Lan'] = locationValues.location_latitude.toString();
      upload_loc.fields['Log'] = locationValues.location_longitude.toString();
      upload_loc.fields['online'] = 'True';
      upload_loc.fields['user'] = '';
      upload_loc.headers['authorization'] = 'Token ${token['auth_token']}';
      final stream_loc = await upload_loc.send();
      var response_loc = await http.Response.fromStream(stream_loc);
      return '{response_loc.body}';
    } catch (e) {}
  }

  Future Signup_VendorApi(
      {username, password, email, re_password, context}) async {
    try {
      var upload = http.MultipartRequest('POST',
          Uri.parse('https://app.foodtruck.express/foodtruck-vendor/users/'));

      upload.fields['password'] = password.toString();
      upload.fields['email'] = email.toString();
      upload.fields['username'] = 'foodtruck.express.' + '$email';

      final stream = await upload.send();
      vendor_signup_res = await http.Response.fromStream(stream);

      var body = jsonDecode(vendor_signup_res.body);
      if (vendor_signup_res.statusCode == 200 ||
          vendor_signup_res.statusCode == 201) {
        box.write('token', token);
        box.write('user', 'vendor');
        Login_SetState();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VENDORSIGNUP22();
        }));
      } else if (vendor_signup_res.statusCode == 400) {
        Login_SetState();
        showDialog(
            builder: (context) => AlertDialog(
                  title: Center(
                    child: Text('Check Credentials',
                        style: TextStyle(color: Colors.blue)),
                  ),
                  content: Container(
                      width: 280,
                      height: 130,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: body['email'] == null
                                ? Icon(Icons.check, color: Colors.green)
                                : Text(body['email'][0].toString(),
                                    style: TextStyle(color: Colors.blue)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: body['password'] == null
                                ? Icon(Icons.check, color: Colors.green)
                                : Text(body['password'][0].toString(),
                                    style: TextStyle(color: Colors.blue)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: body['non_field_errors'] == null
                                ? Icon(Icons.check, color: Colors.green)
                                : Text(body['non_field_errors'][0].toString(),
                                    style: TextStyle(color: Colors.blue)),
                          )
                        ],
                      )),
                ),
            context: context);
      }
      return vendor_signup_res;
    } catch (e) {
      Login_SetState();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  Future Signup_UserApi({password, email, context}) async {
    try {
      var upload = http.MultipartRequest(
          'POST', Uri.parse('https://user.foodtruck.express/foodtruck/users/'));
      upload.fields['username'] = 'foodtruck.express.' + '$email';
      upload.fields['password'] = password.toString();
      upload.fields['email'] = email.toString();

      final stream = await upload.send();
      user_signup_res = await http.Response.fromStream(stream);

      var body = jsonDecode(user_signup_res.body);
      if (user_signup_res.statusCode == 200 ||
          user_signup_res.statusCode == 201) {
        box.write('token', token);
        box.write('user', 'user');
        Login_SetState();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Map_vendor();
        }));
      } else if (user_signup_res.statusCode == 400) {
        Login_SetState();
        showDialog(
            builder: (context) => AlertDialog(
                  title: Center(
                    child: Text('Check Credentials',
                        style: TextStyle(color: Colors.blue)),
                  ),
                  content: Container(
                      width: 280,
                      height: 130,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: body['email'] == null
                                ? Icon(Icons.check, color: Colors.green)
                                : Text(body['email'][0].toString(),
                                    style: TextStyle(color: Colors.blue)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: body['password'] == null
                                ? Icon(Icons.check, color: Colors.green)
                                : Text(body['password'][0].toString(),
                                    style: TextStyle(color: Colors.blue)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: body['non_field_errors'] == null
                                ? Icon(Icons.check, color: Colors.green)
                                : Text(body['non_field_errors'][0].toString(),
                                    style: TextStyle(color: Colors.blue)),
                          )
                        ],
                      )),
                ),
            context: context);
      }
      return user_signup_res;
    } catch (e) {
      Login_SetState();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  Future Login_VendorApi({password, email, context}) async {
    try {
      var upload = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/token/login/'));
      upload.fields['password'] = password.toString();
      upload.fields['email'] = email.toString();
      final stream = await upload.send();
      vendor_login_res = await http.Response.fromStream(stream);
      token = json.decode(vendor_login_res.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var video = prefs.getString('video');
      if (vendor_login_res.statusCode == 200 ||
          vendor_login_res.statusCode == 201) {
        box.write('token', token);
        box.write('user', 'vendor');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return video == 'video' ? Map_user() : VideoApp('vendor');
        }));
        Login_SetState();
      } else if (vendor_login_res.statusCode == 400 ||
          vendor_login_res.statusCode == 500) {
        showDialog(
            builder: (context) => AlertDialog(
                  title: Center(
                    child: Text('Check Credentials',
                        style: TextStyle(color: Colors.blue)),
                  ),
                  content: Text('unable to login with provided credentials',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      } else if (vendor_login_res.statusCode == 404) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('no response! try again',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);

        Login_SetState();
      }

      return token;
    } catch (e) {
      Login_SetState();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  initializeValues() {
    token = box.read('token');
    notifyListeners();
  }

  Future Login_UserApi({password, email, context}) async {
    try {
      var upload = http.MultipartRequest('POST',
          Uri.parse('https://user.foodtruck.express/foodtruck/token/login/'));
      upload.fields['password'] = password.toString();
      upload.fields['email'] = email.toString();
      final stream = await upload.send();
      user_login_res = await http.Response.fromStream(stream);
      token = json.decode(user_login_res.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var video = prefs.getString('video');

      if (user_login_res.statusCode == 200 ||
          user_login_res.statusCode == 201) {
        box.write('token', token);
        box.write('user', 'user');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return video == 'video' ? Map_vendor() : VideoApp('user');
        }));
        Login_SetState();
      } else if (user_login_res.statusCode == 400 ||
          user_login_res.statusCode == 500) {
        showDialog(
            builder: (context) => AlertDialog(
                  title: Center(
                    child: Text('Check Credentials',
                        style: TextStyle(color: Colors.blue)),
                  ),
                  content: Text('unable to login with provided credentials',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      } else if (user_login_res.statusCode == 404) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('no response! try again',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      }

      return token;
    } catch (e) {
      Login_SetState();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  Future Update_Menu_Details(
      {id, context, menu_description, menu_title, menu_price}) async {
    try {
      var upload = http.MultipartRequest(
          'PUT',
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/menu/${id}/'));
      upload.fields['menu_description'] = menu_description.toString();
      upload.fields['menu_title'] = menu_title.toString();
      upload.fields['menu_price'] = menu_price;
      upload.fields['lanlog'] = '';
      upload.fields['user'] = '';
      upload.headers['authorization'] = 'Token ${token['auth_token']}';
      final stream = await upload.send();
      var update_menu_res = await http.Response.fromStream(stream);
      var body = json.decode(update_menu_res.body);

      if (update_menu_res.statusCode == 200 ||
          update_menu_res.statusCode == 201) {
        Navigator.pop(context);
        Login_SetState();
      } else if (update_menu_res.statusCode == 400 ||
          update_menu_res.statusCode == 500 ||
          update_menu_res.statusCode == 405) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('process unable to finish',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      } else if (update_menu_res.statusCode == 404) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('no response! try again',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      }

      return update_menu_res;
    } catch (e) {
      Login_SetState();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  Future Update_Profile_Details({
    id,
    context,
    phone,
    business_name,
    unique_detail,
    detail,
  }) async {
    try {
      var upload = http.MultipartRequest(
          'PUT',
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/profile/${id}/'));
      upload.fields['phone'] = phone.toString();
      upload.fields['business_name'] = business_name.toString();
      upload.fields['unique_detail'] = unique_detail;
      upload.fields['detail'] = detail;
      upload.fields['lanlog'] = '';
      upload.fields['user'] = '';
      upload.headers['authorization'] = 'Token ${token['auth_token']}';
      final stream = await upload.send();
      var update_profile_res = await http.Response.fromStream(stream);
      var body = json.decode(update_profile_res.body);

      if (update_profile_res.statusCode == 200 ||
          update_profile_res.statusCode == 201) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return VENDORprofile();
        }));
        Login_SetState_third();
      } else if (update_profile_res.statusCode == 400 ||
          update_profile_res.statusCode == 500 ||
          update_profile_res.statusCode == 405) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('process unable to finish',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState_third();
      } else if (update_profile_res.statusCode == 404) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('no response! try again',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState_third();
      }

      return update_profile_res;
    } catch (e) {
      Login_SetState_third();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  Future Add_Menu(
      {context, image1, menu_title, menu_description, menu_price}) async {
    try {
      var upload = http.MultipartRequest('POST',
          Uri.parse('https://app.foodtruck.express/foodtruck-vendor/menu/'));
      var file = await http.MultipartFile.fromPath('menu_picture1', image1);
      upload.files.add(file);
      upload.fields['menu_title'] = menu_title.toString();
      upload.fields['menu_description'] = menu_description.toString();
      upload.fields['menu_price'] = '$menu_price';
      upload.fields['lanlog'] = '';
      upload.fields['user'] = '';
      upload.headers['authorization'] = 'Token ${token['auth_token']}';
      final stream = await upload.send();
      var upload_menu_res = await http.Response.fromStream(stream);
      var body = json.decode(upload_menu_res.body);

      if (upload_menu_res.statusCode == 200 ||
          upload_menu_res.statusCode == 201) {
        Navigator.pop(context);
        Login_SetState();
      } else if (upload_menu_res.statusCode == 400 ||
          upload_menu_res.statusCode == 500 ||
          upload_menu_res.statusCode == 405 ||
          upload_menu_res.statusCode == 404) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('process unable to finish',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      } else if (upload_menu_res.statusCode == 404) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('no response! try again',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      }

      return body;
    } catch (e) {
      Login_SetState();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  Future Delete_Menu({id, context}) async {
    try {
      var upload = http.MultipartRequest(
          'DELETE',
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/menu/$id/'));
      upload.headers['authorization'] = 'Token ${token['auth_token']}';
      final stream = await upload.send();
      var update_menu_res = await http.Response.fromStream(stream);

      if (update_menu_res.statusCode == 200 ||
          update_menu_res.statusCode == 201 ||
          update_menu_res.statusCode == 204) {
        Navigator.pop(context);
        Login_SetState();
      } else if (update_menu_res.statusCode == 400 ||
          update_menu_res.statusCode == 500 ||
          update_menu_res.statusCode == 405) {
        Navigator.pop(context);
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('process unable to finish',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      } else if (update_menu_res.statusCode == 404) {
        Navigator.pop(context);
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('no response! try again',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      }
    } catch (e) {
      Login_SetState();
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text('Working on it', style: TextStyle(color: Colors.blue)),
          ),
          content: Text('There was a Problem Encountered'),
        ),
      );
    }
  }

  Future Update_Profile_Pic({id, context, pro_pic = ''}) async {
    try {
      var upload = http.MultipartRequest(
          'PUT',
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/profile/${id}/'));
      var file = await http.MultipartFile.fromPath('pro_pic', pro_pic);
      upload.files.add(file);
      upload.fields['lanlog'] = '';
      upload.fields['user'] = '';
      upload.headers['authorization'] = 'Token ${token['auth_token']}';
      final stream = await upload.send();
      var update_menu_res = await http.Response.fromStream(stream);
      var body = json.decode(update_menu_res.body);

      if (update_menu_res.statusCode == 200 ||
          update_menu_res.statusCode == 201) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return VENDORprofile();
        }));
        Login_SetState();
      } else if (update_menu_res.statusCode == 400 ||
          update_menu_res.statusCode == 500 ||
          update_menu_res.statusCode == 405) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('process unable to finish',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      } else if (update_menu_res.statusCode == 404) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('no response! try again',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      }

      return update_menu_res;
    } catch (e) {
      Login_SetState();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  Future Update_Menu_Images({id, context, image1 = ''}) async {
    try {
      var upload = http.MultipartRequest(
          'PUT',
          Uri.parse(
              'https://app.foodtruck.express/foodtruck-vendor/menu/${id}/'));
      var file = await http.MultipartFile.fromPath('menu_picture1', image1);
      upload.files.add(file);
      upload.fields['lanlog'] = '';
      upload.fields['user'] = '';
      upload.headers['authorization'] = 'Token ${token['auth_token']}';
      final stream = await upload.send();
      var update_menu_res = await http.Response.fromStream(stream);
      var body = json.decode(update_menu_res.body);

      if (update_menu_res.statusCode == 200 ||
          update_menu_res.statusCode == 201) {
        Navigator.pop(context);
        Login_SetState_Second();
      } else if (update_menu_res.statusCode == 400 ||
          update_menu_res.statusCode == 500 ||
          update_menu_res.statusCode == 405) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('process unable to finish',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState_Second();
      } else if (update_menu_res.statusCode == 404) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('no response! try again',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState_Second();
      }

      return update_menu_res;
    } catch (e) {
      Login_SetState_Second();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }

  Future PostRating({context, rate, lanlog, scaffoldKey}) async {
    try {
      var upload = http.MultipartRequest('POST',
          Uri.parse('https://app.foodtruck.express/foodtruck-vendor/rating/'));
      upload.fields['rate'] = rate.toString();
      upload.fields['lanlog'] = lanlog.toString();

      final stream = await upload.send();
      var upload_rate_res = await http.Response.fromStream(stream);
      var body = json.decode(upload_rate_res.body);

      if (upload_rate_res.statusCode == 200 ||
          upload_rate_res.statusCode == 201) {
        Login_SetState_third();
        scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text(
          'You Have Rated this Vendor',
          textAlign: TextAlign.center,
        )));
      } else if (upload_rate_res.statusCode == 400 ||
          upload_rate_res.statusCode == 500 ||
          upload_rate_res.statusCode == 405) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('process unable to finish',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState();
      } else if (upload_rate_res.statusCode == 404) {
        showDialog(
            builder: (context) => AlertDialog(
                  content: Text('no response! try again',
                      style: TextStyle(color: Colors.blue)),
                ),
            context: context);
        Login_SetState_third();
      }
    } catch (e) {
      Login_SetState_third();
      showDialog(
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text('Working on it',
                      style: TextStyle(color: Colors.blue)),
                ),
                content: Text('There was a Problem Encountered'),
              ),
          context: context);
    }
  }
}
