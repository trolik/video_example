import 'package:video_example/db/entities.dart';
import 'package:video_example/db/repository.dart';

class HomeBloc {

  Stream<List<Video>> getVideos() {
    return Repository.instance.getVideos().asStream();
  }
}