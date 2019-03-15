import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_example/db/entities.dart';
import 'package:video_example/share/share_video.dart';
import 'package:video_example/utils/routes.dart';

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
        margin: EdgeInsets.all(10),
        color: Colors.grey[200],
        child: InkWell(
          child: Padding(
              padding: EdgeInsets.all(0),
              child: SizedBox(
                height: 120,
                child: _buildListTile()
              )
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShareScreen(widget.video))
          ),
        )
    );
  }

  ListTile _buildListTile() {
    return ListTile(
      title: Text(widget.video.date.toLocal().toString()),
      subtitle: Text("Duration: ${widget.video.duration} seconds"),
      leading: Container(padding: EdgeInsets.fromLTRB(0, 40, 0, 0), child: _image())
    );
  }

  Image _image() {
    return Image.file(
      File(widget.video.thumbPath),
      width: 100,
      height: 100,
      alignment: Alignment.center,
      fit: BoxFit.cover
    );
  }
}
