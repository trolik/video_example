
class Video {
  final int id;
  final String videoPath;
  final String thumbPath;
  final DateTime date;
  final int duration;

  Video({this.id, this.videoPath, this.thumbPath, this.date, this.duration});

  factory Video.fromJson(Map <String, dynamic> map) {
    return Video(
      id: map["id"],
      videoPath: map["video_path"],
      thumbPath: map["thumb_path"],
      date: DateTime.fromMillisecondsSinceEpoch(map["date"]),
      duration: map["duration"]
    );
  }

  Map<String, dynamic> toJson() => {
    'video_path': videoPath,
    'thumb_path': thumbPath,
    'date': date.millisecondsSinceEpoch,
    'duration': duration
  };
}