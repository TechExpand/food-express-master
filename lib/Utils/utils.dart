import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils with ChangeNotifier{

  XFile selected_image;
  XFile selected_menu_image1;
  XFile selected_menu_image2;
  XFile selected_menu_image3;
  final ImagePicker _picker = ImagePicker();

  Future selectimage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selected_image = image;
    notifyListeners();
  }




  Future selectimage1() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selected_menu_image1 = image;
    notifyListeners();
  }



  Future selectimage2() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selected_menu_image2 = image;
    notifyListeners();
  }



  Future selectimage3() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selected_menu_image3 = image;
    notifyListeners();
  }


  Future makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool view = false;

  changeView(value){
    view = value;
    notifyListeners();
  }

  Future storeData(String name, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, data);
  }

  Future getData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(name);
    return data;
  }
}
