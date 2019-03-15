import 'package:flutter/material.dart';
import 'package:video_example/db/entities.dart';
import 'package:video_example/home/bloc/home_bloc.dart';
import 'package:video_example/home/widget/video_widget.dart';
import 'package:video_example/utils/routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _homeBloc;


  @override
  void initState() {
    super.initState();

    _homeBloc = HomeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Video maker"),
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var result = Navigator.of(context).pushNamed(Routes.makeVideo);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        )
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<Video>>(
      stream: _homeBloc.getVideos(),
      builder: (builder, snapshot) {
        if (snapshot.hasData) {
          return _buildVideosList(snapshot.data);
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildVideosList(List<Video> videos) {
    return ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return VideoRow(videos.elementAt(index));
        });
  }
}
