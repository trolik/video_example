import 'dart:async';

import 'package:camera/camera.dart';

class MakeVideoBloc {
  CameraController cameraController;

  StreamController<bool> _cameraInitializedStream = StreamController();
  Stream<bool> get cameraInitializedStream => _cameraInitializedStream.stream;

  Stream<List<CameraDescription>> getAvailableCameras() {
    return availableCameras()
        .catchError((e) {
          print(e);
          return [];
        })
        .then((cameras) {
          if (cameras.isNotEmpty) {
            selectCamera(cameras.first);
          }

          return cameras;
        })
        .asStream();
  }

  selectCamera(CameraDescription cameraDescription) async {
    cameraController = CameraController(cameraDescription, ResolutionPreset.medium);

    cameraController.addListener(() {
      print("listener ${cameraController.value}");
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print(e);
      _cameraInitializedStream.add(true);
    }

    _cameraInitializedStream.add(true);
  }

  dispose() async {
    await cameraController?.dispose();
  }
}