import 'package:flutter/material.dart';

class MakeVideoScreen extends StatefulWidget {
  @override
  _MakeVideoScreenState createState() => _MakeVideoScreenState();
}

class _MakeVideoScreenState extends State<MakeVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create you own video"),
        ),
        body: Center(child: Text("todo"))
    );
  }
}
