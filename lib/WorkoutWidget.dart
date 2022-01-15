import 'package:flutter/material.dart';

class WorkoutWidget extends StatefulWidget {
  WorkoutWidget({Key key}) : super(key: key);

  @override
  State createState() => _WorkoutState();
}

class _WorkoutState extends State<WorkoutWidget>{

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text('Workout'),
      ],
    );
  }
}