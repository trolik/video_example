import 'dart:async';

import 'package:camera/camera.dart';

class MakeVideoBloc {
  /// Available cameras
  List<CameraDescription> _cameras = [];
  /// Lens direction of currently selected camera
  CameraLensDirection _cameraLensDirection;

  String _videoRecPath;
  
  CameraController cameraController;

  StreamController<bool> _cameraInitializedStream = StreamController();
  /// Notify then camera is initialized
  Stream<bool> get cameraInitializedStream => _cameraInitializedStream.stream;

  Stream<List<CameraDescription>> getAvailableCameras() {
    return availableCameras()
        .catchError((e) {
          print(e);
          return [];
        })
        .then((cameras) {
          this._cameras = cameras;
          
          if (cameras.isNotEmpty) {
            selectCamera(cameras.first);
          }

          return cameras;
        })
        .asStream();
  }

  bool get isRecording => cameraController.value.isRecordingVideo;

  selectCamera(CameraDescription cameraDescription) async {
    _cameraLensDirection = cameraDescription.lensDirection;

    if (cameraController != null) {
      await cameraController.dispose();
    }
    
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

  Future<void> startRecording(String path) async {
    await cameraController.startVideoRecording(path);

    _videoRecPath = path;

    return;
  }

  Future<String> stopRecording() async {
    await cameraController.stopVideoRecording();

    return _videoRecPath;
  }

  switchCamera() {
    for (CameraDescription desc in _cameras) {
      if (desc.lensDirection != _cameraLensDirection) {
        selectCamera(desc);
        return;
      }
    }
  }

  dispose() async {
    await cameraController?.dispose();
  }
}