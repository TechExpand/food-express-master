
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';


class AdmobService with ChangeNotifier{
 AdmobBannerSize bannerSize;
 AdmobInterstitial instatitialAd;

 String getBannerAdUnitId(){
    if (Platform.isIOS) {
      return 'ca-app-pub-1065880110189655/6603671564';
    } else if (Platform.isAndroid){
      return 'ca-app-pub-1065880110189655/6603671564';
    }
    return null;
  }



   String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-1065880110189655/4709728289';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-1065880110189655/4709728289';
    }
    return null;
  }
}

