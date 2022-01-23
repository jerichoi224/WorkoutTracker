import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/routine_entry_model.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/widgets/Routine/AddRoutineEntryWidget.dart';
import 'package:workout_tracker/widgets/Routine/EditRoutineEntryWidget.dart';

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
          builder: (context) => AddRoutineEntryWidget(objectbox: widget.objectbox),
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
    final RoutineEntry modifiedEntry = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditRoutineEntryWidget(entry: routineEntry),
        )
    );

    if(modifiedEntry != null){
      updateRoutineList();
    }
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
                  onTap: () {
                    print("tapped");
                  },
                  child: ListTile(
                      dense: true,
                      title: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: i.name,
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