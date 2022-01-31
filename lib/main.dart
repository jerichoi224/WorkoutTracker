import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/widgets/HomeWidget.dart';
import 'package:workout_tracker/widgets/InstructionWidget.dart';


late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();

  runApp(MyApp());
}

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
          '/home': (BuildContext context) => new HomeWidget(parentCtx: context, objectbox: objectbox),
          '/splash': (BuildContext context) => new InstructionWidget(parentCtx: context, objectbox: objectbox),
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
    bool firstTime = (prefs.getBool('firstTime') ?? true);

    if (!firstTime) {
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
      body: Center(
        child: Container(
          child:Text("Splash")
        )
      )
    );
  }
}