import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/routine_entry_model.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/widgets/Routine/AddEditRoutineEntryWidget.dart';

class RoutineWidget extends StatefulWidget {
  late ObjectBox objectbox;
  RoutineWidget({Key? key, required this.objectbox}) : super(key: key);

  @override
  State createState() => _RoutineState();
}

class _RoutineState extends State<RoutineWidget>{
  List<RoutineEntry> RoutineList = [];
  void initState() {
    super.initState();
    updateRoutineList();
  }

  void updateRoutineList()
  {
    RoutineList = widget.objectbox.routineBox.getAll();
    setState(() {});
  }

  // Navigate to AddWorkout screen
  void _AddRoutineEntry(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddRoutineEntryWidget(objectbox: widget.objectbox, edit: false, id: 0),
        ));
    if(result)
      updateRoutineList();
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
          widget.objectbox.routineBox.remove(i.id);
          updateRoutineList();
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
      updateRoutineList();
  }

  List<Widget> routineList(){
    List<Widget> RoutineWidgetList = [];

    if(RoutineList.length == 0)
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

    RoutineList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    for(RoutineEntry i in RoutineList){
      // If alphabet changes, add caption
      RoutineWidgetList.add(
          new Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              color: Colors.white,
              child: new InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {},
                  child: SizedBox(
                      height: 47 + i.workoutList.length * 15.5,
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(10, 7, 0, 0),
                        dense: true,
                        title: RichText(
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
                              TextSpan(
                                  text: i.parts.length == 0 ? " " : " ("  + i.parts.join(", ") + ")",
                                  style: TextStyle(color: Colors.black54)),
                              TextSpan(
                                  text: "\n",
                                  style: TextStyle(color: Colors.black54)),
                              TextSpan(
                                  text: i.workoutList.length == 0 ? " " : i.workoutList.map((element) => "\t- " + element.caption).join("\n"),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      height: 1.4
                                  )
                              ),
                            ],
                          ),
                        ),
                        trailing: _popUpMenuButton(i)
                    )
                  )
              )
          )
      );
    }
    return RoutineWidgetList;
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