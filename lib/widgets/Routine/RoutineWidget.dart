import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/RoutineEntry.dart';
import 'package:workout_tracker/widgets/Routine/AddRoutineEntryWidget.dart';
import 'package:workout_tracker/widgets/Routine/EditRoutineEntryWidget.dart';

class RoutineWidget extends StatefulWidget {
  RoutineWidget({Key? key}) : super(key: key);

  @override
  State createState() => _RoutineState();
}

class _RoutineState extends State<RoutineWidget>{
  List<RoutineEntry> RoutineList = [];

  void initState() {
    super.initState();
  }

  // Navigate to AddWorkout screen
  void _AddRoutineEntry(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddRoutineEntryWidget(),
        ));
  }

  Widget _popUpMenuButton(RoutineEntry i) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("Edit"),
          value: 0,
        ),
        PopupMenuItem(
          child: Text("Delete"),
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
          RoutineList.remove(i);
          setState(() {
          });
        }
      },
    );
  }

  void _openEditWidget(RoutineEntry workoutEntry) async {
    // start the SecondScreen and wait for it to finish with a result
    final RoutineEntry modifiedEntry = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditRoutineEntryWidget(entry: workoutEntry),
        )
    );

    if(modifiedEntry != null){
      setState(() {});
    }
  }

  List<Widget> routineList(){
    List<Widget> RoutineWidgetList = [];
    int tmp = 0;
    String firstChar = "";

    RoutineList.sort((a, b) => a.caption.toLowerCase().compareTo(b.caption.toLowerCase()));

    for(RoutineEntry i in RoutineList){
      // If alphabet changes, add caption
      if(firstChar != i.caption[0].toUpperCase()){
        firstChar = i.caption[0].toUpperCase();
        RoutineWidgetList.add(
            Padding(
                padding: EdgeInsets.fromLTRB(15, 7, 0, 0),
                child: Text((firstChar),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                  ),
                )
            )
        );
      }
      RoutineWidgetList.add(
          new Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              color: Colors.white,
              child: new InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    print("tapped");
                  },
                  child: ListTile(
                      dense: true,
                      title: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: i.caption,
                                style: TextStyle(color: Colors.black)
                            ),
                            TextSpan(
                                text: " ("  + ")",
                                style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                      subtitle: Text(""),
                      trailing: _popUpMenuButton(i)
                  )
              )
          )
      );
    }
    return RoutineWidgetList.length > 0 ? RoutineWidgetList : List.from(
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
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.filter_list_rounded),
        onPressed: (){

        },
      ),
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _AddRoutineEntry(context);
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
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Routine List'),
//                  background: FlutterLogo(),
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