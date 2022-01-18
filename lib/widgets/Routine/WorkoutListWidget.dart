import 'package:flutter/material.dart';
import 'package:workout_tracker/db/database_helpers.dart';
import 'package:workout_tracker/widgets/Workout/AddWorkoutEntryWidget.dart';
import 'package:workout_tracker/dbModels/WorkoutEntry.dart';

import 'package:workout_tracker/util/languageTool.dart';

class WorkoutListWidget extends StatefulWidget {
  DatabaseHelper dbHelper;
  WorkoutListWidget({Key key, this.dbHelper}) : super(key: key);

  @override
  State createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutListWidget> {
  List<WorkoutEntry> WorkoutList;
  TextEditingController searchTextController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  void initState() {
    super.initState();

    WorkoutList = [];
    updateWorkoutList();
  }

  void updateWorkoutList()
  {
    widget.dbHelper.queryAllWorkout().then((entries){
      setState(() {
        WorkoutList = entries;
      });
    });
  }

  // Navigate to AddWorkout screen
  void _AddWorkoutEntry(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result

    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddWorkoutEntryWidget(dbHelper: widget.dbHelper),
        ));

    if(result)
      updateWorkoutList();

  }

  String getFirstchar(String s){
    if(isKorean(s))
    {
      return getKoreanFirstVowel(s);
    }
    return s;
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
                child: Text(getFirstchar(firstChar),
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
                    if(_isSearching)
                      Navigator.pop(context);
                    Navigator.pop(context, i);
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
              "No Workout Found.",
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
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (searchTextController == null ||
                searchTextController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _AddWorkoutEntry(context);
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
              title: _isSearching ? _buildSearchField() : Text("Workout List"),
              actions: _buildActions(),
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