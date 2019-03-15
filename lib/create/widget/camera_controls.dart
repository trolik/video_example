import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_example/create/bloc/make_bloc.dart';
import 'package:video_example/create/widget/make_bloc_provider.dart';

class CameraControls extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraControls(this.cameras);

  @override
  _CameraControlsState createState() => _CameraControlsState();
}

class _CameraControlsState extends State<CameraControls> {
  MakeVideoBloc makeVideoBloc;

  @override
  Widget build(BuildContext context) {
    makeVideoBloc = MakeVideoBlocProvider.of(context);

    var widgets = <Widget>[
      IconButton(
        icon: Icon(Icons.camera,
          color: makeVideoBloc.isRecording ? Colors.red : Colors.black,
        ),
        onPressed: () => makeVideoBloc.isRecording ? stopVideoRecording() : startVideoRecording(),
      )
    ];

    if (widget.cameras.length > 1) {
      widgets.insert(0, IconButton(
        icon: Icon(Icons.switch_camera),
        onPressed: () => makeVideoBloc.switchCamera(),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: widgets,
    );
  }

  startVideoRecording() async {
    try {
      bool recording = await makeVideoBloc.startRecording();
      if (recording) {
        setState(() {});
      }
    } on CameraException catch (e) {
      print(e);
      showSnackBar(e.description);
    }
  }

  stopVideoRecording() async {
    try {
      var videoMetaInfo = await makeVideoBloc.stopRecording();
      if (videoMetaInfo != null) {
        makeVideoBloc.save(videoMetaInfo);
        setState(() {});
        showSnackBar('Video recorded to: ${videoMetaInfo}');
      }
    } on CameraException catch (e) {
      print(e);
      showSnackBar(e.description);
    }
  }

  void showSnackBar(String message) {
    print(message);
  }
}
