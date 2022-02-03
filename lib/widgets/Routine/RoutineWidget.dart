import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/routine_entry_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/widgets/Routine/AddEditRoutineEntryWidget.dart';
import 'package:workout_tracker/widgets/Routine/ViewRoutineWidget.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoutineWidget extends StatefulWidget {
  late ObjectBox objectbox;
  RoutineWidget({Key? key, required this.objectbox}) : super(key: key);

  @override
  State createState() => _RoutineState();
}

class _RoutineState extends State<RoutineWidget>{
  void initState() {
    super.initState();
  }

  // Navigate to AddWorkout screen
  void _addRoutineEntry(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddRoutineEntryWidget(objectbox: widget.objectbox, edit: false, id: 0),
        ));
    if(result)
      setState(() {});
  }

  Widget _popUpMenuButton(RoutineEntry i) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text(AppLocalizations.of(context)!.edit),
          value: 0,
        ),
        PopupMenuItem(
          child: Text(AppLocalizations.of(context)!.delete),
          value: 1,
        ),
      ],

      onSelected: (selectedIndex) {
        // Edit
        if(selectedIndex == 0){
          _openEditWidget(i);
        }
        // Delete
        else if(selectedIndex == 1){
          widget.objectbox.routineBox.remove(i.id);
          widget.objectbox.routineList.remove(i);
        }
      },
    );
  }

  void _openEditWidget(RoutineEntry routineEntry) async {
    // start the SecondScreen and wait for it to finish with a result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddRoutineEntryWidget(objectbox: widget.objectbox, edit: true, id: routineEntry.id),
        ));
    if(result)
      setState(() {});
  }

  void _openViewWidget(int id) async {
    // start the SecondScreen and wait for it to finish with a   result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewRoutineEntryWidget(objectbox: widget.objectbox, id:id),
        ));
    if(result.runtimeType == bool && result)
    {
      setState(() {});
    }
  }

  String workoutListToString(List<String> workoutIds)
  {
    List<String> workoutList = [];
    for(String id in workoutIds)
      {
        WorkoutEntry? tmp = widget.objectbox.workoutBox.get(int.parse(id));
        if(tmp != null)
          {
            workoutList.add("\t- " + tmp.caption);
          }
      }
    return workoutList.join("\n");
  }

  List<Widget> routineList(){
    List<Widget> routineWidgetList = [];

    if(widget.objectbox.routineList.length == 0)
      return List.from(
          [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                AppLocalizations.of(context)!.routine_not_found,
                style: TextStyle(fontSize: 14),
              ),
            )
          ]);

    widget.objectbox.routineList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    for(RoutineEntry i in widget.objectbox.routineList){
      // If alphabet changes, add caption
      routineWidgetList.add(
          new Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              color: Colors.white,
              child: new InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {_openViewWidget(i.id);},
                  child: SizedBox(
                      height: max(47 + i.workoutIds.length * 15, 55),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                            child:RichText(
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
                                      text: i.parts.length == 0 ? " " : " ("  + i.parts.join(", ") + ")",
                                      style: TextStyle(color: Colors.black54)),
                                  TextSpan(
                                      text: "\n",
                                      style: TextStyle(color: Colors.black54)),
                                  // Workout Entries
                                  TextSpan(
                                      text: i.workoutIds.length == 0 ? "(No Workout Found)" : workoutListToString(i.workoutIds),
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
                          Flexible(child: Container()),
                          _popUpMenuButton(i)

                        ],
                      )
                  )
              )
          )
      );
    }
    return routineWidgetList;
  }

  List<Widget> _buildActions() {
    return <Widget>[
      /*
      IconButton(
        icon: const Icon(Icons.filter_list_rounded),
        onPressed: (){

        },
      ),
       */
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _addRoutineEntry(context);
          }
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                snap: false,
                floating: false,
                backgroundColor: Colors.amberAccent,
                expandedHeight: 100.0,
                actions: _buildActions(),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(AppLocalizations.of(context)!.routine_list),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                    routineList()
                ),
              ),
            ],
          ),
        )
    );
  }
}