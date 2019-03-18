import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_example/db/entities.dart';

class Repository {
  static final Repository _repository = Repository();

  Database _database;

  static get instance => _repository;

  Future<void> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, "database.db");

    _database = await openDatabase(dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE ${Tables.video} ("
            "${VideoColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
            "${VideoColumn.videoPath} TEXT, "
            "${VideoColumn.thumbPath} TEXT, "
            "${VideoColumn.date} INTEGER, "
            "${VideoColumn.duration} INTEGER"
            ")");
      });

    print("Repository initialzed");
  }

  Future<int> addVideo(Video video) async {
    return await _database.insert(Tables.video, video.toJson());
  }

  Future<List<Video>> getVideos() async {
    await init();

    var results = await _database.query(Tables.video, orderBy: VideoColumn.date + " DESC");
    return results.map((map) => Video.fromJson(map)).toList();
  }
}

class Tables {
  static final String video = "VIDEO";
}