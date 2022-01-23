import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/widgets/HomeWidget.dart';
import 'package:workout_tracker/widgets/InstructionWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Workout Tracker',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.amber,
        ),
        home: MainApp(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new HomeWidget(parentCtx: context),
          '/splash': (BuildContext context) => new InstructionWidget(),
        }
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  State createState() => _MainState();
}

class _MainState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    // TODO: Implement Instruction screen properly
    _seen = true;
    if (_seen) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/splash', (Route<dynamic> route) => false);
    }
  }

  Widget build(BuildContext context){
    new Timer(new Duration(milliseconds: 10), () {
      checkFirstSeen();
    });
    return Scaffold(
        body: new Container()
    );
  }
}