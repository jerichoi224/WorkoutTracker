import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InstructionWidget extends StatefulWidget {
  final BuildContext parentCtx;
  late final objectbox;
  InstructionWidget({Key? key, required this.parentCtx, required this.objectbox});

  @override
  State createState() => _InstructionState();
}

class _InstructionState extends State<InstructionWidget>{
  final pageController = PageController(initialPage: 0);
  TextEditingController userName = new TextEditingController();
  int _currentIndex = 0;

  @override
  void initState(){
    super.initState();
  }

  finishSplash() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      nextPage();
      prefs.setBool('firstTime', false);
      prefs.setString('username', userName.text);
      addInitialWorkouts();
      await Future.delayed(const Duration(seconds: 2), (){});
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  nextPage() {
    setState(() {
      _currentIndex += 1;
      pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  showSnackBar(BuildContext context, String s){
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(s),
      duration: Duration(seconds: 3),
    ));
  }

  Widget introScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: Center(
              /*child: Image(
                image: AssetImage('assets/my_icon.png'),
                width: 150,
              )*/
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Center(
                child: Text(
                  "Welcome to Workout Tracker!",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
            )
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Center(
                child: Text(
                  "What's your name?",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
            )
        ),
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Center(
              child: ListTile(
                  title: new Row(
                    children: <Widget>[
                      Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Name',
                            ),
                            controller: userName,
                            textAlign: TextAlign.center,
                          )
                      )
                    ],
                  )
              ),
            )
        ),
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
            color: Colors.amber,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                      onTap:(){
                        if(userName.text.isEmpty) {
                          final snackBar = SnackBar(
                              content: const Text('Please enter your name'),
                            );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        finishSplash();
                      },
                      title: Text("Start",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      )
                  )
                ]
            )
        )
      ],
    );
  }


  Widget loadingScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Center(
              child: Text(
                  "Creating Database.\nPlease Wait.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16
                  )
              )
          ),
        ),
        SpinKitPouringHourGlassRefined(color: Colors.amberAccent),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> introPages = <Widget>[
      introScreen(context),
      loadingScreen(context)
    ];
    return Scaffold(
      body:
      Builder(
          builder: (context) => PageView(
              physics:new NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
                _currentIndex = index;
              },
              controller: pageController,
              children: introPages
          )
      ),
    );
  }

  void addInitialWorkouts() async{
    widget.objectbox.workoutBox.put(new WorkoutEntry(
        metric: MetricType.kg.name, type: WorkoutType.barbell.name,
        partList: [PartType.chest.name, PartType.tricep.name], caption: "Bench Press")
    );
    widget.objectbox.workoutBox.put(new WorkoutEntry(
        metric: MetricType.kg.name, type: WorkoutType.barbell.name,
        partList: [PartType.chest.name, PartType.tricep.name], caption: "Inclined Bench Press")
    );
    widget.objectbox.workoutBox.put(new WorkoutEntry(
        metric: MetricType.kg.name, type: WorkoutType.dumbbell.name,
        partList: [PartType.tricep.name], caption: "Tricep Extension")
    );
    widget.objectbox.workoutBox.put(new WorkoutEntry(
        metric: MetricType.kg.name, type: WorkoutType.dumbbell.name,
        partList: [PartType.bicep.name], caption: "Bicep Curl")
    );
    widget.objectbox.workoutBox.put(new WorkoutEntry(
        metric: MetricType.floor.name, type: WorkoutType.machine.name,
        partList: [PartType.cardio.name], caption: "Stairs")
    );
    widget.objectbox.workoutBox.put(new WorkoutEntry(
        metric: MetricType.km.name, type: WorkoutType.cardio.name,
        partList: [PartType.cardio.name], caption: "Treadmill")
    );
    widget.objectbox.workoutBox.put(new WorkoutEntry(
        metric: MetricType.kg.name, type: WorkoutType.machine.name,
        partList: [PartType.back.name], caption: "Wide Grip Lat-Pulldown")
    );
    widget.objectbox.workoutBox.put(new WorkoutEntry(
        metric: MetricType.kg.name, type: WorkoutType.machine.name,
        partList: [PartType.back.name], caption: "M-Torture Wide Pulldown Rear")
    );
    widget.objectbox.workoutBox.put(new WorkoutEntry(
        metric: MetricType.kg.name, type: WorkoutType.machine.name,
        partList: [PartType.back.name], caption: "T-Row Bar")
    );
    widget.objectbox.workoutBox.put(new WorkoutEntry(
        metric: MetricType.kg.name, type: WorkoutType.machine.name,
        partList: [PartType.core.name], caption: "Knee Raise")
    );

    widget.objectbox.workoutList = widget.objectbox.workoutBox.getAll();
    setState(() {
    });
  }
}