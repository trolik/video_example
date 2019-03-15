import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_example/db/entities.dart';
import 'package:video_example/db/repository.dart';

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

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<bool> startRecording() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String dirPath = "${docsDir.path}/Videos";

    await Directory(dirPath).create();

    String videoPath = "$dirPath/${_timestamp()}.mp4";

    if (isRecording) {
      print("ERROR: already recording");
      return false;
    }

    await cameraController.startVideoRecording(videoPath);

    _videoRecPath = videoPath;

    return true;
  }

  Future<String> stopRecording() async {
    if (!isRecording) {
      print("ERROR: not recording");
      return null;
    }

    await cameraController.stopVideoRecording();

    return _videoRecPath;
  }

  Future<bool> save(String videoPath) async {
    Video video = Video(videoPath: videoPath, thumbPath: "dumb", duration: 30);
    var result = await Repository.instance.addVideo(video);

    print("insert: $result");

    return true;
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