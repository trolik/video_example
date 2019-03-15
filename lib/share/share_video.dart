import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_example/db/entities.dart';

class ShareScreen extends StatefulWidget {
  final Video video;

  ShareScreen(this.video);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  static const shareMethodChannel = const MethodChannel('samples.flutter.io/share_file');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Share video"),
        ),
        body: Center(
            child: RaisedButton(
                child: Text("share"),
                onPressed: () => shareIt()
            )
        )
    );
  }

  shareIt() async {
    try {
      await shareMethodChannel.invokeMethod("share", {"text": "Hello, world!"});
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
