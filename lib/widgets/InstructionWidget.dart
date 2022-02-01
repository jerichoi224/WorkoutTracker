import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/initialWorkouts.dart';
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
    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          },
        child: new Scaffold(
            body: Column(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
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
            )
        )
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
    for(WorkoutEntry entry in initList)
      {
        widget.objectbox.workoutBox.put(entry);
      }

    widget.objectbox.workoutList = widget.objectbox.workoutBox.getAll();
    setState(() {
    });
  }
}