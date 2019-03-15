import 'package:flutter/material.dart';
import 'package:video_example/db/entities.dart';

class ShareScreen extends StatefulWidget {
  final Video video;

  ShareScreen(this.video);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Share data"),
        ),
        body: Center(child: Text(widget.video.date.toString()))
    );
  }
}
