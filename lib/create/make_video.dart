import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_example/create/make_bloc.dart';
import 'package:video_player/video_player.dart';

class MakeVideoScreen extends StatefulWidget {
  @override
  _MakeVideoScreenState createState() => _MakeVideoScreenState();
}

class _MakeVideoScreenState extends State<MakeVideoScreen> {
  MakeVideoBloc _makeVideoBloc;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  VideoPlayerController _videoController;


  @override
  void initState() {
    super.initState();

    _makeVideoBloc = MakeVideoBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Create you own video"),
        ),
        body: StreamBuilder<List<CameraDescription>>(
          stream: _makeVideoBloc.getAvailableCameras(),
          builder: (context, snapshot) {
            return _build(context, snapshot);
          },
        )
    );
  }

  Widget _build(BuildContext context, AsyncSnapshot<List<CameraDescription>> snapshot) {
    if (snapshot.hasData) {
      var cameras = snapshot.data;

      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.red),
              child: _buildCameraPreview(),
            ),
          ),
          _buildControls(cameras)
        ],
      );
    } else if (snapshot.hasError) {
      return Center(child: Text(snapshot.error));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildCameraPreview() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _makeVideoBloc.cameraInitializedStream,
      builder: (context, snapshot) {
        var initialized = snapshot.data;

        if (initialized) {
          return AspectRatio(
            aspectRatio: _makeVideoBloc.cameraController.value.aspectRatio,
            child: CameraPreview(_makeVideoBloc.cameraController),
          );
        } else {
          return Container(width: 0, height: 0);
        }
      },
    );
  }

  Widget _buildControls(List<CameraDescription> cameras) {

    var widgets = <Widget>[
      IconButton(
        icon: Icon(Icons.camera,
          color: _makeVideoBloc.isRecording ? Colors.red : Colors.black,
        ),
        onPressed: () => _makeVideoBloc.isRecording ? stopVideoRecording() : startVideoRecording(),
      )
    ];

    if (cameras.length > 1) {
      widgets.insert(0, IconButton(
        icon: Icon(Icons.switch_camera),
        onPressed: () => _makeVideoBloc.switchCamera(),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: widgets,
    );
  }

  startVideoRecording() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String dirPath = "${docsDir.path}/Videos";
    await Directory(dirPath).create();
    String videoPath = "$dirPath/${timestamp()}.mp4";

    if (_makeVideoBloc.isRecording) {
      print("ERROR: already recording");
      return;
    }

    try {
      await _makeVideoBloc.startRecording(videoPath);

      showSnackBar("start video recording to: $videoPath");
    } on CameraException catch (e) {
      print(e);
      showSnackBar(e.description);
    }
  }

  stopVideoRecording() async {
    if (!_makeVideoBloc.isRecording) {
      print("ERROR: not recording");
      return;
    }

    //setState(() {});

    try {
      var videoPath = await _makeVideoBloc.stopRecording();

      showSnackBar('Video recorded to: $videoPath');
    } on CameraException catch (e) {
      print(e);
      showSnackBar(e.description);
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2)
      ),
    );
  }
}