import 'dart:io';

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
    return Card(
      color: Colors.grey[200],
        child: InkWell(
          child: Padding(
              padding: EdgeInsets.all(4),
              child: _buildListTile()
          ),
          onTap: () {

          },
        )
      );
  }

  ListTile _buildListTile() {
    return ListTile(
      title: Text(widget.video.videoPath),
      subtitle: Text(widget.video.thumbPath),
      leading: Image.file(
        File(widget.video.thumbPath),
        width: 100,
        height: 100,
        fit: BoxFit.cover
      )
    );
  }
}
