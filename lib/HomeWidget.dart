import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/services.dart';

import 'package:workout_tracker/DashboardWidget.dart';
import 'package:workout_tracker/CalendarWidget.dart';
import 'package:workout_tracker/RoutineWidget.dart';
import 'package:workout_tracker/WorkoutWidget.dart';
import 'package:workout_tracker/SettingsWidget.dart';

class HomeWidget extends StatefulWidget {
  final BuildContext parentCtx;

  HomeWidget({Key key, this.parentCtx});

  @override
  State createState() => _HomeState();

}

class _HomeState extends State<HomeWidget>{
  final pageController = PageController(initialPage: 1);
  int _currentIndex = 1;
  bool ready = false;

  @override
  void initState(){
    super.initState();
  }

  List<Widget> _children() => [
    CalendarWidget(),
    DashboardWidget(),
    RoutineWidget(),
    WorkoutWidget(),
  ];


  // Navigate to Settings screen
  void _pushSettings(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsWidget(),
        ));

    setState(() {});
  }

  changePage(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    final List<Widget> children = _children();

    // Minimum Splash Screen
    if(!ready) {
      new Timer(new Duration(milliseconds: 500), () {
        ready = true;
        setState(() {});
      });
    }

    // While Data is loading, show empty screen
    if(!ready) {
      return Scaffold(
          body: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                      child:
                      Text("HI")
                      /*Image(
                        image: AssetImage('assets/my_icon.png'),
                        width: 150,
                      )*/
                  ),
                ),
              ])
      );
    }

    // App Loads
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Tracker"),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _pushSettings(context);
              }
          )
        ],
      ),
      body: PageView(
          onPageChanged: (index) {
            FocusScope.of(context).unfocus();
            changePage(index);
          },
          controller: pageController,
          children: children
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
            title: new Text('Calendar'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.insert_chart_outlined),
            title: new Text('Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.repeat),
            title: new Text('Routine'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.fitness_center),
            title: new Text('Workout'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}