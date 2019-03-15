
class Video {
  final int id;
  final String videoPath;
  final String thumbPath;
  final DateTime date;
  final int duration;

  Video({this.id, this.videoPath, this.thumbPath, this.date, this.duration});

  factory Video.fromJson(Map <String, dynamic> map) {
    return Video(
      id: map[VideoColumn.id],
      videoPath: map[VideoColumn.videoPath],
      thumbPath: map[VideoColumn.thumbPath],
      date: DateTime.fromMillisecondsSinceEpoch(map[VideoColumn.date]),
      duration: map[VideoColumn.duration]
    );
  }

  Map<String, dynamic> toJson() => {
  VideoColumn.videoPath: videoPath,
    VideoColumn.thumbPath: thumbPath,
    VideoColumn.date: date.millisecondsSinceEpoch,
    VideoColumn.duration: duration
  };
}

class VideoColumn {
  static final String id = "id";
  static final String videoPath = "video_path";
  static final String thumbPath = "thumb_path";
  static final String date = "date";
  static final String duration = "duration";
}