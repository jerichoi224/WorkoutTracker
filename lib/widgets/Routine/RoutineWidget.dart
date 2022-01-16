import 'package:flutter/material.dart';
import 'package:workout_tracker/db/database_helpers.dart';
import 'package:workout_tracker/widgets/Routine/AddRoutineEntryWidget.dart';
import 'package:workout_tracker/widgets/Routine/EditRoutineEntryWidget.dart';

class RoutineWidget extends StatefulWidget {
  DatabaseHelper dbHelper;
  RoutineWidget({Key key, this.dbHelper}) : super(key: key);

  @override
  State createState() => _RoutineState();
}

class _RoutineState extends State<RoutineWidget>{
  List<WorkoutEntry> WorkoutList;
  TextEditingController searchTextController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

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
  void _AddRoutineEntry(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddRoutineEntryWidget(dbHelper: widget.dbHelper),
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
          builder: (context) => EditRoutineEntryWidget(entry: workoutEntry),
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

  Widget _buildSearchField() {
    return Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
            child:TextField(
              controller: searchTextController,
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search Workout",
                border: InputBorder.none,
                filled: true,
                hintStyle: TextStyle(color: Colors.black12),
              ),
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              onChanged: (query) => updateSearchQuery(query),
            )
        )
    );
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

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      searchTextController.clear();
      updateSearchQuery("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Routines"),
              actions: _buildActions(),
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