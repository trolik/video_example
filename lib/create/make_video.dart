import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video_example/create/bloc/make_bloc.dart';
import 'package:video_example/create/widget/make_bloc_provider.dart';
import 'package:video_example/create/widget/camera_controls.dart';

class MakeVideoScreen extends StatefulWidget {
  @override
  _MakeVideoScreenState createState() => _MakeVideoScreenState();
}

class _MakeVideoScreenState extends State<MakeVideoScreen> {
  MakeVideoBloc _makeVideoBloc;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _makeVideoBloc = MakeVideoBloc();
  }

  @override
  Widget build(BuildContext context) {
    return MakeVideoBlocProvider(
      bloc: _makeVideoBloc,
      child: _buildScaffold(),
    );
  }

  Scaffold _buildScaffold() {
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

      return _buildCameraWidgets(cameras);
    } else if (snapshot.hasError) {
      return Center(child: Text(snapshot.error));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2)
      ),
    );
  }

  Widget _buildCameraWidgets(List<CameraDescription> cameras) {
    return StreamBuilder<bool>(
      stream: _makeVideoBloc.cameraInitializedStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var initialized = snapshot.data;

          if (initialized) {
            return Column(children: <Widget>[
              AspectRatio(
                aspectRatio: _makeVideoBloc.cameraController.value.aspectRatio,
                child: CameraPreview(_makeVideoBloc.cameraController),
              ),
              CameraControls(cameras)
            ]);
          } else {
            return Center(
                child: Text(
                    "Permissions weren't granted or initialization failed",
                    style: TextStyle(fontSize: 20)
                )
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}