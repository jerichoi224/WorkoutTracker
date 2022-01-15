import 'package:flutter/material.dart';

class DashboardWidget extends StatefulWidget {
  DashboardWidget({Key key}) : super(key: key);

  @override
  State createState() => _DashboardState();
}

class _DashboardState extends State<DashboardWidget>{

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text('Dashboard'),
      ],
    );
  }
}