import 'package:flutter/material.dart';
import 'package:video_example/create/make_video.dart';
import 'package:video_example/home/home_screen.dart';
import 'package:video_example/utils/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video maker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        Routes.home: (context) => HomeScreen(),
        Routes.makeVideo: (context) => MakeVideoScreen(),
        //Routes.share: (context) => ShareScreen()
      },
    );
  }
}
