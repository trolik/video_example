import 'package:flutter/material.dart';
import 'package:video_example/db/entities.dart';

class VideoRow extends StatefulWidget {
  final Video video;

  VideoRow(this.video);

  @override
  _VideoRowState createState() => _VideoRowState();
}

class _VideoRowState extends State<VideoRow> {

  @override
  Widget build(BuildContext context) {
    return Text(widget.video.videoPath);
  }
}
