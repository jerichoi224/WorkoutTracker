import 'package:flutter/material.dart';
import 'package:workout_tracker/widgets/DashboardWidget.dart';
import 'package:workout_tracker/widgets/CalendarWidget.dart';
import 'package:workout_tracker/widgets/Routine/RoutineWidget.dart';
import 'package:workout_tracker/widgets/Workout/WorkoutWidget.dart';
import 'package:workout_tracker/widgets/Setting/SettingsWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeWidget extends StatefulWidget {
  final BuildContext parentCtx;
  late final objectbox;
  HomeWidget({Key? key, required this.parentCtx, required this.objectbox});

  @override
  State createState() => _HomeState();

}

class _HomeState extends State<HomeWidget>{
  final List<Widget> screens = [];
//  DatabaseHelper dbHelper = DatabaseHelper();
  final pageController = PageController(initialPage: 2);
  int _currentIndex = 2;
  bool ready = false;
  String? username = "";

  @override
  void initState(){
    super.initState();
  }

  List<Widget> _children() => [
    WorkoutWidget(objectbox: widget.objectbox),
    RoutineWidget(objectbox: widget.objectbox),
    DashboardWidget(objectbox: widget.objectbox),
    CalendarWidget(objectbox: widget.objectbox),
    SettingsWidget(objectbox: widget.objectbox),
  ];

  changePage(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    ready = true;
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
                      Text("Loading data")
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
      body: PageView(
          onPageChanged: (index) {
            FocusScope.of(context).unfocus();
            changePage(index);
          },
          controller: pageController,
          children: _children()
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(widget.parentCtx).colorScheme.secondary,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.fitness_center),
            label: AppLocalizations.of(context)!.workout,
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.repeat),
            label: AppLocalizations.of(context)!.routine,
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.insert_chart_outlined),
            label: AppLocalizations.of(context)!.dashboard,
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
            label: AppLocalizations.of(context)!.calendar,
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}