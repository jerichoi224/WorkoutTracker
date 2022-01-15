import 'package:flutter/material.dart';
import 'package:workout_tracker/db/database_helpers.dart';
import 'package:workout_tracker/widgets/EditWorkoutEntryWidget.dart';
import 'package:workout_tracker/widgets/AddWorkoutEntryWidget.dart';

class WorkoutWidget extends StatefulWidget {
  DatabaseHelper dbHelper;
  WorkoutWidget({Key key, this.dbHelper}) : super(key: key);

  @override
  State createState() => _WorkoutState();
}

class _WorkoutState extends State<WorkoutWidget> {
  List<WorkoutEntry> WorkoutList;
  final searchTextController = TextEditingController();

  void initState() {
    super.initState();

    WorkoutList = [];
    widget.dbHelper.queryAllWorkout().then((entries){
      setState(() {
        WorkoutList = entries;
      });
    });
  }

  // Navigate to AddWorkout screen
  void _AddWorkoutEntry(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddWorkoutEntryWidget(dbHelper: widget.dbHelper),
        ));

    widget.dbHelper.queryAllWorkout().then((entries){
      setState(() {
        WorkoutList = entries;
      });
    });
  }

  Widget _popUpMenuButton(WorkoutEntry i) {
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
          widget.dbHelper.deleteWorkout(i.id);
          WorkoutList.remove(i);
          setState(() {
          });
        }
      },
    );
  }

  void _openEditWidget(WorkoutEntry workoutEntry) async {
    // start the SecondScreen and wait for it to finish with a result
    final WorkoutEntry modifiedEntry = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditWorkoutEntryWidget(entry: workoutEntry),
        )
    );

    widget.dbHelper.updateWorkout(modifiedEntry);
    setState(() {});
  }

  List<Widget> workoutList(){
    List<Widget> WorkoutWidgetList = [];
    int tmp = 0;
    String firstChar = "";

    WorkoutList.sort((a, b) => a.caption.toLowerCase().compareTo(b.caption.toLowerCase()));

    for(WorkoutEntry i in WorkoutList){
      if(searchTextController.text.isNotEmpty) {
        if(!i.caption.toLowerCase().contains(searchTextController.text.toLowerCase())
           &&!i.part.name.toLowerCase().contains(searchTextController.text.toLowerCase())
        // && !i.type.name.toLowerCase().contains(searchTextController.text.toLowerCase())
        )
          continue;
      }
      // If alphabet changes, add caption
      if(firstChar != i.caption[0].toUpperCase()){
        firstChar = i.caption[0].toUpperCase();
        WorkoutWidgetList.add(
            Padding(
                padding: EdgeInsets.fromLTRB(15, 7, 0, 0),
                child: Text(firstChar,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                  ),
                )
            )
        );
      }
      WorkoutWidgetList.add(
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
                            text: " (" + i.part.name + ")",
                            style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  subtitle: Text(i.type.name),
                    trailing: _popUpMenuButton(i)
              )
          )
        )
      );
    }
    return WorkoutWidgetList.length > 0 ? WorkoutWidgetList : List.from(
        [Text("No Workout Entry Found.")]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Workout List"),
              actions: [
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _AddWorkoutEntry(context);
                    }
                ),
              ],
            ),
            body:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5),
                    child: new TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        hintText: "Search Workout",
                      ),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 0
                          ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: workoutList()
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