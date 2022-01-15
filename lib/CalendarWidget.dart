import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  CalendarWidget({Key key}) : super(key: key);

  @override
  State createState() => _CalendarState();
}

class _CalendarState extends State<CalendarWidget>{

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