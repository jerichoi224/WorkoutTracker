import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/routine_entry_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/widgets/Session/AddSessionEntryWidget.dart';
import 'dart:math';

class RoutineListWidget extends StatefulWidget {
  late ObjectBox objectbox;
  RoutineListWidget({Key? key, required this.objectbox}) : super(key: key);

  @override
  State createState() => _RoutineListState();
}

class _RoutineListState extends State<RoutineListWidget> {
  void initState() {
    super.initState();
  }

  String workoutListToString(List<String> workoutIds) {
    List<String> workoutList = [];
    for (String id in workoutIds) {
      WorkoutEntry? tmp = widget.objectbox.workoutBox.get(int.parse(id));
      if (tmp != null) {
        workoutList.add("\t- " + tmp.caption);
      }
    }
    return workoutList.join("\n");
  }

  void startRoutineSession(BuildContext context, int id) async {
    // start the SecondScreen and wait for it to finish with a result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddSessionEntryWidget(objectbox: widget.objectbox, fromRoutine:true, edit:false, id:id),
        ));
    Navigator.pop(context, result);
  }

  List<Widget> routineList(BuildContext context) {
    List<Widget> routineWidgetList = [];

    if (widget.objectbox.routineList.length == 0)
      return List.from(
          [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                "No Routine Found.",
                style: TextStyle(fontSize: 14),
              ),
            )
          ]);

    widget.objectbox.routineList.sort((a, b) =>
        a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    for (RoutineEntry i in widget.objectbox.routineList) {
      // If alphabet changes, add caption
      routineWidgetList.add(
          new Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              color: Colors.white,
              child: new InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    startRoutineSession(context, i.id);
                  },
                  child: SizedBox(
                      height: max(47 + i.workoutIds.length * 15, 55),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: i.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          height: 1.2
                                      )
                                  ),
                                  // Workout Parts
                                  TextSpan(
                                      text: i.parts.length == 0 ? " " : " (" +
                                          i.parts.join(", ") + ")",
                                      style: TextStyle(color: Colors.black54)),
                                  TextSpan(
                                      text: "\n",
                                      style: TextStyle(color: Colors.black54)),
                                  // Workout Entries
                                  TextSpan(
                                      text: i.workoutIds.length == 0
                                          ? "(No Workout Found)"
                                          : workoutListToString(i.workoutIds),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                          height: 1.4
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  )
              )
          )
      );
    }
    return routineWidgetList;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Choose Routine"),
              backgroundColor: Colors.amberAccent,
            ),
            body:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: SingleChildScrollView(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: 0
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: routineList(context)
                            )
                        )
                    )
                )
              ],
            )
        )
    );
  }
}