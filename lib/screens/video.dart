import 'package:foodtruck/Utils/utils.dart';
import 'package:foodtruck/screens/UserView/Map_user.dart';
import 'package:foodtruck/screens/VendorView/MAp_vendor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatefulWidget {
  @override
  String user;
  VideoApp(this.user);
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    var data = Provider.of<Utils>(context, listen: false);
    _controller = VideoPlayerController.network(
        'https://foodtruck.express/xfte/fte-instructions_1.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodTruck Express',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:27.0),
                child: FloatingActionButton(
                    onPressed: ()async{
//                      SharedPreferences prefs = await SharedPreferences.getInstance();
//                      var user = prefs.getString('user');
                      return Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return widget.user == 'user'
                                ? Map_vendor()
                                : Map_user(); //SignUpAddress();
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation,
                              child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                            (route) => false,
                      );
                    },
                    child: Text('Next>>')
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}