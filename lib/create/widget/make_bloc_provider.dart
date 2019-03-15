import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_example/create/bloc/make_bloc.dart';

class MakeVideoBlocProvider extends StatefulWidget {
  final MakeVideoBloc bloc;
  final Widget child;

  MakeVideoBlocProvider({Key key, @required this.bloc, @required this.child}) : super(key: key);

  @override
  _MakeVideoBlocProviderState createState() => _MakeVideoBlocProviderState();

  static MakeVideoBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MakeVideoBlocProvider) as _MakeVideoBlocProvider).bloc;
  }
}

class _MakeVideoBlocProviderState extends State<MakeVideoBlocProvider> {
  @override
  Widget build(BuildContext context) {
    return _MakeVideoBlocProvider(bloc: widget.bloc, child: widget.child);
  }
}

class _MakeVideoBlocProvider extends InheritedWidget {
  final MakeVideoBloc bloc;

  _MakeVideoBlocProvider({Key key, @required this.bloc, @required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MakeVideoBlocProvider old) {
    return bloc != old.bloc;
  }
}
