
class Video {
  final int id;
  final String videoPath;
  final String thumbPath;
  final int duration;

  Video({this.id, this.videoPath, this.thumbPath, this.duration});

  factory Video.fromJson(Map <String, dynamic> map) {
    return Video(
      id: map["id"],
      videoPath: map["video_path"],
      thumbPath: map["thumb_path"],
      duration: map["duration"]
    );
  }

  Map<String, dynamic> toJson() => {
    'video_path': videoPath,
    'thumb_path': thumbPath,
    'duration': duration
  };
}