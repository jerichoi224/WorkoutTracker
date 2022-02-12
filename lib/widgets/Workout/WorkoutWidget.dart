import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/widgets/UIComponents.dart';
import 'package:workout_tracker/widgets/Workout/AddEditWorkoutEntryWidget.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/StringTool.dart';
import 'package:workout_tracker/widgets/Workout/ViewWorkoutWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkoutWidget extends StatefulWidget {
  late ObjectBox objectbox;
  WorkoutWidget({Key? key, required this.objectbox}) : super(key: key);

  @override
  State createState() => _WorkoutState();
}

class _WorkoutState extends State<WorkoutWidget> {
  TextEditingController searchTextController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";
  String locale = "";
  List<String> partList = [];

  void initState() {
    super.initState();
    String? temp = widget.objectbox.getPref("locale");
    locale = temp != null ? temp : 'en';
  }

  // Navigate to AddWorkout screen
  void _addWorkoutEntry(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddWorkoutEntryWidget(objectbox: widget.objectbox, edit:false, id:0),
        ));

    if(result.runtimeType == bool && result)
      {
        setState(() {});
      }
  }

  Widget _popUpMenuButton(WorkoutEntry i) {
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
          i.visible = false;
          widget.objectbox.workoutBox.put(i);
          widget.objectbox.workoutList.remove(i);
          setState(() {});
        }
      },
    );
  }

  void _openEditWidget(WorkoutEntry workoutEntry) async {
    // start the SecondScreen and wait for it to finish with a   result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddWorkoutEntryWidget(objectbox: widget.objectbox, edit:true, id:workoutEntry.id),
        ));

    if(result)
      setState(() {});
  }

  void _openViewWidget(WorkoutEntry workoutEntry) async {
    // start the SecondScreen and wait for it to finish with a   result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewWorkoutWidget(objectbox: widget.objectbox, id:workoutEntry.id),
        ));
    if(result.runtimeType == bool && result)
      {
          setState(() {});
      }
  }

  String getFirstchar(String s){
    if(isKorean(s))
    {
      return getKoreanFirstVowel(s);
    }
    return s;
  }

  List<Widget> selectPartList()
  {
    List<Widget> tagList = [];

    for(int i = 0; i < PartType.values.length; i++)
    {
      PartType p = PartType.values[i];
      tagList.add(
          tag(p.toLanguageString(locale),
                  (){
                if(partList.contains(p.name))
                  partList.remove(p.name);
                else
                  partList.add(p.name);
                setState(() {});
              } ,
              partList.contains(p.name) ? Colors.amber : Colors.black12)
      );
    }
    return tagList;
  }

  List<Widget> workoutList(){
    List<Widget> workoutWidgetList = [];
    String firstChar = "";

    if(widget.objectbox.workoutList.length == 0)
      return List.from(
          [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
              AppLocalizations.of(context)!.workout_not_found,
                style: TextStyle(fontSize: 14),
              ),
            )
          ]);

    if(_isSearching)
      workoutWidgetList.add(
          Container(
              margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: Wrap(
                  alignment: WrapAlignment.center,
                  children: selectPartList()
              )

          )
      );

    widget.objectbox.workoutList.sort((a, b) => a.caption.toLowerCase().compareTo(b.caption.toLowerCase()));

    for(WorkoutEntry i in widget.objectbox.workoutList){
      if(searchTextController.text.isNotEmpty) {
        if(!i.caption.toLowerCase().contains(searchTextController.text.toLowerCase())
           &&!i.partList.contains(searchTextController.text.toLowerCase())
        // && !i.type.name.toLowerCase().contains(searchTextController.text.toLowerCase())
        )
          continue;
      }

      if(partList.isNotEmpty && setEquals(partList.toSet().difference(i.partList.toSet()), partList.toSet()))
        continue;

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
                  onTap: () {_openViewWidget(i);},
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
                            text: i.partList.length == 0 ? " " : " ("  + i.partList.map((e) => PartType.values.firstWhere((element) => element.name == e).toLanguageString(locale)).join(", ") + ")",
                            style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  subtitle: Text(WorkoutType.values.firstWhere((element) => element.name == i.type).toLanguageString(locale).capitalize(locale)),
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
            hintText: AppLocalizations.of(context)!.workout_search,
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
            _addWorkoutEntry(context);
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
                  title: _isSearching ? Container() : Text(AppLocalizations.of(context)!.workout_list),
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