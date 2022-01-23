import 'package:flutter/material.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/widgets/Workout/EditWorkoutEntryWidget.dart';
import 'package:workout_tracker/widgets/Workout/AddWorkoutEntryWidget.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/languageTool.dart';

class WorkoutWidget extends StatefulWidget {
  late ObjectBox objectbox;
  WorkoutWidget({Key? key, required this.objectbox}) : super(key: key);

  @override
  State createState() => _WorkoutState();
}

class _WorkoutState extends State<WorkoutWidget> {
  List<WorkoutEntry> WorkoutList = [];
  TextEditingController searchTextController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  void initState() {
    super.initState();
    updateWorkoutList();
  }

  void updateWorkoutList()
  {
    WorkoutList = widget.objectbox.workoutBox.getAll();
    setState(() {});
  }

  // Navigate to AddWorkout screen
  void _AddWorkoutEntry(BuildContext context) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddWorkoutEntryWidget(objectbox: widget.objectbox),
        ));

    if(result)
      updateWorkoutList();

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
          widget.objectbox.workoutBox.remove(i.id);
          updateWorkoutList();
        }
      },
    );
  }

  void _openEditWidget(WorkoutEntry workoutEntry) async {
    // start the SecondScreen and wait for it to finish with a   result
     bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditWorkoutEntryWidget(workoutBox: widget.objectbox.workoutBox, entry: workoutEntry),
        )
    );

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
    List<Widget> workoutWidgetList = [];
    String firstChar = "";

    if(WorkoutList.length == 0)
      return List.from(
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

    WorkoutList.sort((a, b) => a.caption.toLowerCase().compareTo(b.caption.toLowerCase()));

    for(WorkoutEntry i in WorkoutList){
      if(searchTextController.text.isNotEmpty) {
        if(!i.caption.toLowerCase().contains(searchTextController.text.toLowerCase())
           &&!i.part.toLowerCase().contains(searchTextController.text.toLowerCase())
        // && !i.type.name.toLowerCase().contains(searchTextController.text.toLowerCase())
        )
          continue;
      }
      // If alphabet changes, add caption
      if(firstChar != i.caption[0].toUpperCase()){
        firstChar = i.caption[0].toUpperCase();
        workoutWidgetList.add(
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
      workoutWidgetList.add(
          new Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              color: Colors.white,
              child: new InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {},
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
                            text: " (" + i.part + ")",
                            style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  subtitle: Text(i.type),
                    trailing: _popUpMenuButton(i)
              )
          )
        )
      );
    }
    return workoutWidgetList;
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
            if (searchTextController.text.isEmpty) {
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
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

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
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                snap: false,
                floating: false,
                backgroundColor: Colors.amberAccent,
                expandedHeight: _isSearching ? 0 : 100.0,
                actions: _buildActions(),
                title: _isSearching ? _buildSearchField() : Container(),
                flexibleSpace: FlexibleSpaceBar(
                  title: _isSearching ? Container() : Text("Workout List"),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                    workoutList()
                  //
                ),
              ),
            ],
          ),
        )
    );
  }
}