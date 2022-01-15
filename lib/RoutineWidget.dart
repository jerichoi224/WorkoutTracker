import 'package:flutter/material.dart';

class RoutineWidget extends StatefulWidget {
  RoutineWidget({Key key}) : super(key: key);

  @override
  State createState() => _RoutineState();
}

class _RoutineState extends State<RoutineWidget>{

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text('Routine'),
      ],
    );
  }
}