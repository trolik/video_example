import 'package:flutter/material.dart';
import 'package:video_example/create/make_video.dart';
import 'package:video_example/db/repository.dart';
import 'package:video_example/home/home_screen.dart';
import 'package:video_example/utils/routes.dart';

void main() {
  Repository.instance.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video maker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        Routes.home: (context) {
          return HomeScreen();
        },
        Routes.makeVideo: (context) => MakeVideoScreen()
      },
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
