import 'package:flutter/material.dart';
import 'package:video_example/utils/routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Video maker"),
        ),
        body: Center(child: Text("list of videos")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var result = Navigator.of(context).pushNamed(Routes.makeVideo);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        )
    );
  }
}
