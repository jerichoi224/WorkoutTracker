import 'package:flutter/material.dart';
import 'package:workout_tracker/class/WorkoutCard.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/widgets/Routine/WorkoutListWidget.dart';

import 'package:workout_tracker/objectbox.g.dart';

class AddRoutineEntryWidget extends StatefulWidget {
//  DatabaseHelper dbHelper;

  AddRoutineEntryWidget({Key? key}) : super(key: key);
  @override
  State createState() => _AddRoutineEntryState();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class _AddRoutineEntryState extends State<AddRoutineEntryWidget> {
  late final store;
  late final workoutEntryBox;

  String caption = "";
  final RoutineNameController = TextEditingController();
  List<WorkoutEntry> WorkoutEntryList = [];
  List<WorkoutCard> WorkoutCardList = [];

  @override
  void initState() {
    super.initState();
    store = openStore();
    workoutEntryBox = store.box<WorkoutEntry>();
  }

  Widget AddButton(String caption, Function method)
  {
    return ListTile(
        title: new Row(
            mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
            children: <Widget>[
              new Icon(
                  Icons.add,
                color: Colors.black38
              ),
              new Flexible(
                child: new Text(caption,
                  style: TextStyle(
                    color: Colors.black38
                  ),
                )
            )
          ],
        ),
      onTap: () => {
        method()
      },
    );
  }

  void removeWorkout(int ind){
    WorkoutCardList.removeAt(ind);
    WorkoutEntryList.removeAt(ind);
    setState(() {});
  }

  void AddWorkout() async {
    // start the SecondScreen and wait for it to finish with a result
      final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutListWidget(workoutBox: workoutEntryBox,),
      ));

      if(result.runtimeType == WorkoutEntry)
      {
        WorkoutEntry workoutEntry = result as WorkoutEntry;
        WorkoutCard newCard = new WorkoutCard(workoutEntry);
        WorkoutCardList.add(newCard);
        setState(() {});
      }
  }

  Widget _BuildWorkoutCards(BuildContext context, int index) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.all(8.0),
        child: Column(
            children: <Widget>[
              ListTile(
                title: new Row(
                  children: <Widget>[
                    new Flexible(
                        child: new Text(WorkoutCardList[index].entry.caption.capitalize(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ],
                ),
                trailing: new Container(
                  child: new IconButton(
                      icon: new Icon(Icons.close),
                      onPressed:(){
                        WorkoutCardList.removeAt(index);
                        setState(() {
                        });
                      }
                  )
                  ,
                ),
              ),
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          Navigator.pop(context, false);
          return true;
        },
        child: new GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: new Scaffold(
                appBar: AppBar(
                  title: Text("Add Routine"),
                  backgroundColor: Colors.amberAccent,
                ),
                body: Builder(
                    builder: (context) =>
                        SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // System Values
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text("Routine Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    )
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    margin: EdgeInsets.all(8.0),
                                    child: Column(
                                        children: <Widget>[
                                          ListTile(
                                              title: new Row(
                                                children: <Widget>[
                                                  new Flexible(
                                                      child: new TextField(
                                                        controller: RoutineNameController,
                                                        decoration: InputDecoration(
                                                          border:InputBorder.none,
                                                          hintText: "Enter Name",
                                                        ),
                                                      )
                                                  )
                                                ],
                                              )
                                          ),
                                        ]
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text("Routine Details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    )
                                ),

                                ListView.builder(
                                  itemCount: WorkoutCardList.length,
                                  itemBuilder: _BuildWorkoutCards,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    margin: EdgeInsets.all(8.0),
                                    child: Column(
                                        children: <Widget>[
                                          AddButton("Add Workout", AddWorkout)
                                        ]
                                    )
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    color: Theme.of(context).colorScheme.primary,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ListTile(
                                              onTap:(){
                                                if(RoutineNameController.text.isEmpty) {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Please enter name for new workout'),
                                                  );

                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  return;
                                                }
                                                /*
                                                RoutineEntry newEntry = new RoutineEntry();
                                                newEntry.caption = RoutineNameController.text;
                                                newEntry.routineJson = "";
                                                widget.dbHelper.insertRoutineEntry(newEntry);
                                                */
                                                Navigator.pop(context, false);
                                              },
                                              title: Text("Add Routine",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                          )
                                        ]
                                    )
                                ),// Save Button
                              ],
                            )
                        )
                )
            )
        )
    );
  }
  @override
  void dispose() {
    super.dispose();
    store.close();
  }
}