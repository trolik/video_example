import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_example/db/entities.dart';
import 'package:video_example/db/repository.dart';
import 'package:thumbnails/thumbnails.dart';

class MakeVideoBloc {
  /// Available cameras
  List<CameraDescription> _cameras = [];
  /// Lens direction of currently selected camera
  CameraLensDirection _cameraLensDirection;

  String _videoRecPath;
  DateTime _startRecording;
  
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
    await Directory(await _getVideosDirectoryPath()).create();
    String videoPath = "$_getVideosDirectoryPath/${_timestamp()}.mp4";

    if (isRecording) {
      print("ERROR: already recording");
      return false;
    }

    await cameraController.startVideoRecording(videoPath);

    _startRecording = DateTime.now();
    _videoRecPath = videoPath;

    return true;
  }

  Future<VideoRecordMetaInformation> stopRecording() async {
    if (!isRecording) {
      print("ERROR: not recording");
      return null;
    }

    await cameraController.stopVideoRecording();

    var duration = DateTime.now().difference(_startRecording);

    return VideoRecordMetaInformation(_videoRecPath, _startRecording, duration.inSeconds);
  }

  _getVideosDirectoryPath() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    return join(docsDir.path, "Videos");
  }

  Future<bool> save(VideoRecordMetaInformation metaInformation) async {
    var thumbPath = await Thumbnails.getThumbnail(videoFile: metaInformation.path, thumbnailFolder: _getVideosDirectoryPath(), quality: 30, imageType: ThumbFormat.PNG);
    print("thumb: $thumbPath");

    Video video = Video(videoPath: metaInformation.path, thumbPath: thumbPath, duration: metaInformation.duration, date: metaInformation.date);
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

class VideoRecordMetaInformation {
  final String path;
  final DateTime date;
  final int duration;

  VideoRecordMetaInformation(this.path, this.date, this.duration);

  @override
  String toString() {
    return "{path: $path, date: $date, duration: $duration}";
  }
}