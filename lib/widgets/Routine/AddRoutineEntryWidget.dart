import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/RoutineEntry.dart';
import 'package:workout_tracker/dbModels/WorkoutEntry.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/db/database_helpers.dart';
import 'package:workout_tracker/widgets/Routine/WorkoutListWidget.dart';

class AddRoutineEntryWidget extends StatefulWidget {
  DatabaseHelper dbHelper;

  AddRoutineEntryWidget({Key key, this.dbHelper}) : super(key: key);
  @override
  State createState() => _AddRoutineEntryState();
}

class _AddRoutineEntryState extends State<AddRoutineEntryWidget> {
  String caption;
  int workoutCard_id;
  final RoutineNameController = TextEditingController();

  List<Card> WorkoutList = [];

  @override
  void initState() {
    workoutCard_id = 0;
    caption = "";
    super.initState();
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

  void AddSet() {

  }

  void removeWorkout(String i){
    for(Card c in WorkoutList)
    {
      if(c.key == Key(i))
        {
          WorkoutList.remove(c);
          break;
        }
    }
    setState(() {});
  }

  void AddWorkout() async {
    // start the SecondScreen and wait for it to finish with a result
      final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutListWidget(dbHelper: widget.dbHelper),
      ));

      if(result.runtimeType == WorkoutEntry)
      {
        WorkoutEntry workoutEntry = result as WorkoutEntry;
        WorkoutList.add(
          Card(
              key: Key(workoutCard_id.toString()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.all(8.0),
              child: Column(
                  children: <Widget>[
                    ListTile(
                        title: new Row(
                          children: <Widget>[
                            new Flexible(
                                child: new Text(workoutEntry.caption,
                                style: TextStyle(
                                    color: Colors.black
                                ),
                              )
                            ),
                          ],
                        ),
                      trailing: new Container(
                        child: new IconButton(
                          icon: new Icon(Icons.close),
                          onPressed:()=> removeWorkout(workoutCard_id.toString())
                        )
                        ,
                      ),
                    ),
                    AddButton("Add Set", AddSet)
                  ]
              )
          )
        );
        setState(() {});
        workoutCard_id++;
      }
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
                                Column(children: WorkoutList,),
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

                                                RoutineEntry newEntry = new RoutineEntry();
                                                newEntry.caption = RoutineNameController.text;
                                                newEntry.routineJson = "";
                                                widget.dbHelper.insertRoutineEntry(newEntry);

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
}