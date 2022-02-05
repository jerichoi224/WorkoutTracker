import 'package:flutter/material.dart';
import 'package:workout_tracker/class/WorkoutCard.dart';
import 'package:workout_tracker/dbModels/routine_entry_model.dart';
import 'package:workout_tracker/dbModels/session_entry_model.dart';
import 'package:workout_tracker/dbModels/session_item_model.dart';
import 'package:workout_tracker/dbModels/set_item_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/widgets/Routine/WorkoutListWidget.dart';
import 'package:workout_tracker/widgets/UIComponents.dart';
import 'package:collection/collection.dart';
import 'package:workout_tracker/util/StringTool.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddSessionEntryWidget extends StatefulWidget {
  late ObjectBox objectbox;
  late bool fromRoutine, edit;
  late int id;
  AddSessionEntryWidget({Key? key, required this.objectbox, required this.fromRoutine, required this.edit, required this.id}) : super(key: key);

  @override
  State createState() => _AddSessionEntryState();
}

class _AddSessionEntryState extends State<AddSessionEntryWidget> {
  String defaultName = "";
  String startDate = "";
  String endDate = "";
  List<WorkoutEntry> workoutEntryList = [];
  List<WorkoutCard> workoutCardList = [];
  bool setTime = false;
  late RoutineEntry? routineEntry;
  late SessionEntry? sessionEntry;
  final sessionNameController = TextEditingController();
  List<String> partList = [];
  int startTime = 0;
  int endTime = 0;
  int year = 0;
  int month = 0;


  @override
  void initState() {
    super.initState();
    if(widget.edit)
      {
        setTime = true;
        sessionEntry = widget.objectbox.sessionList.firstWhere((element) => element.id == widget.id);
        sessionNameController.text = sessionEntry!.name;
        startTime = sessionEntry!.startTime;
        endTime = sessionEntry!.endTime;
        startDate = timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(startTime));
        endDate = timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(endTime));
        partList = sessionEntry!.parts;
        for(SessionItem item in sessionEntry!.sets)
          {
            addWorkoutToList(widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId), false);
            for(SetItem setItem in item.sets)
              {
                AddSet(workoutCardList.length - 1, setItem.metricValue, setItem.countValue);
              }
          }
      }
    else {
      sessionEntry = new SessionEntry();
      DateTime now = new DateTime.now();
      defaultName = dateFormatter.format(now);
      startDate = timeFormatter.format(now);
      endDate = timeFormatter.format(now);
      startTime = now.millisecondsSinceEpoch;
      endTime = now.millisecondsSinceEpoch;
      if (widget.fromRoutine) {
        routineEntry = widget.objectbox.routineList.firstWhere((
            element) => element.id == widget.id);
        partList = routineEntry!.parts;
        for (String strId in routineEntry!.workoutIds) {
          int id = int.parse(strId);
          addWorkoutToList(
              widget.objectbox.workoutList.firstWhere((element) => element.id ==
                  id), true);
        }
      }
    }
  }

  List<Widget> selectPartList(setDialogState)
  {
    List<Widget> tagList = [];

    for(int i = 0; i < PartType.values.length; i++)
    {
      PartType p = PartType.values[i];
      tagList.add(
          tag(p.name,
              (){
                  if(partList.contains(p.name))
                    partList.remove(p.name);
                  else
                    partList.add(p.name);
                  setState(() {});
                  setDialogState((){});
                } ,
              partList.contains(p.name) ? Colors.amber : Colors.black12)
      );
    }
    return tagList;
  }

  // List of Tags in partList
  List<Widget> selectedTagList()
  {
    List<Widget> tagList = [];

    for(int i = 0; i < partList.length; i++)
      tagList.add(tag(partList[i], (){_openTagPopup(context);}, Colors.amberAccent));

    if(partList.length == 0)
      tagList.add(tag(" + " + AppLocalizations.of(context)!.add_part + "  ", (){_openTagPopup(context);}, Color.fromRGBO(230, 230, 230, 0.8)));
    return tagList;
  }

  void _openTagPopup(BuildContext buildContext)
  {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  scrollable: false,
                  title: Text(AppLocalizations.of(buildContext)!.choose_parts),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                        alignment: WrapAlignment.start,
                        children: selectPartList(setState)
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        child: Text(AppLocalizations.of(buildContext)!.close),
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        }
                    )
                  ],
                );
              }
          );
        }
    );
  }

  Widget AddButton(String caption, Function method)
  {
    return ListTile(
      title: new Row(
        mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
        children: <Widget>[
          new Icon(
              Icons.add,
              color: Colors.black38
          ),
          new Flexible(
              child: new Text(caption,
                style: TextStyle(
                    color: Colors.black38
                ),
              )
          )
        ],
      ),
      onTap: () => {
        method()
      },
    );
  }

  void AddSet(int cardIndex, double metric, int count) {
    workoutCardList[cardIndex].addSet(metric, count);
    setState(() {});
  }

  void removeWorkout(int ind){
    workoutCardList.removeAt(ind);
    workoutEntryList.removeAt(ind);
    setState(() {});
  }

  void AddWorkout() async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutListWidget(objectbox: widget.objectbox, list: workoutEntryList,),
        ));

    if(result.runtimeType == WorkoutEntry)
    {
      addWorkoutToList(result as WorkoutEntry, true);
      setState(() {});
    }
  }

  void addWorkoutToList(WorkoutEntry workoutEntry, bool addSet)
  {
    WorkoutCard newCard = new WorkoutCard(workoutEntry, 0);
    workoutCardList.add(newCard);
    workoutEntryList.add(workoutEntry);
    for(String part in workoutEntry.partList)
      if(!partList.contains(part))
        partList.add(part);
    if(addSet)
      AddSet(workoutCardList.length - 1, 0, 0);
  }

  Widget _BuildWorkoutCards(BuildContext context, int index) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.all(8.0),
        child: Column(
            children: <Widget>[
              ListTile(
                title: new Row(
                  children: <Widget>[
                    new Flexible(
                        child: new Text(workoutCardList[index].entry.caption.capitalize(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ],
                ),
                trailing: new Container(
                  child: new IconButton(
                      icon: new Icon(Icons.close),
                      onPressed:(){
                        workoutCardList.removeAt(index);
                        workoutEntryList.removeAt(index);
                        setState(() {
                        });
                      }
                  )
                  ,
                ),
              ),
              ListView.builder(
                itemCount: workoutCardList[index].numSets,
                itemBuilder: (BuildContext context, int ind) {
                  return _BuildSets(context, ind, index);
                },
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
              AddButton(AppLocalizations.of(context)!.session_add_set, (){AddSet(index, 0, 0);})
            ]
        )
    );
  }

  Widget _BuildSets(BuildContext context, int index, int cardInd) {
    WorkoutEntry workoutEntry = workoutCardList[cardInd].entry;
    String prev = " - " ;
    if(workoutEntry.prevSessionId != 0)
      {
        SessionItem? sessionItem = widget.objectbox.itemList.firstWhereOrNull((element) => element.id == workoutEntry.prevSessionId);
        if(sessionItem != null)
          {
            if(sessionItem.sets.length > index)
            {
              prev = sessionItem.sets[index].metricValue.toStringRemoveTrailingZero();
              if(workoutCardList[cardInd].entry.metric != MetricType.none.name)
                prev += " " + workoutCardList[cardInd].entry.metric;
              if([MetricType.kg.name, MetricType.none.name].contains(workoutCardList[cardInd].entry.metric))
                prev += " × " + sessionItem.sets[index].countValue.toString();
            }
          }
      }
    return ListTile(
      title: new Row(
        children: <Widget>[
          new Text(prev,
            style: TextStyle(
              color: Colors.black38
            ),
          ),
          new Expanded(child: Container()),
          new Container(
            width: 65,
            height: 40,
            child: new TextField(
              cursorColor: Colors.black54,
              maxLength: 4,
              keyboardType: TextInputType.number,
              controller: workoutCardList[cardInd].metricController[index],
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide.none,
                    //borderSide: const BorderSide(),
                  ),
                  counterText: "",
                  fillColor: Color.fromRGBO(240, 240, 240, 1),
                  filled: true
              ),
            ),
          ),
            if(workoutCardList[cardInd].entry.metric != MetricType.none.name)
              new Text(" " + workoutCardList[cardInd].entry.metric),
            if([MetricType.kg.name, MetricType.none.name].contains(workoutCardList[cardInd].entry.metric))
              new Text(" × "),
            if([MetricType.kg.name, MetricType.none.name].contains(workoutCardList[cardInd].entry.metric))
              new Container(
                width: 65,
                height: 40,
                child: new TextField(
                  cursorColor: Colors.black54,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  controller: workoutCardList[cardInd].countController[index],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide.none,
                        //borderSide: const BorderSide(),
                      ),
                      counterText: "",
                      fillColor: Color.fromRGBO(240, 240, 240, 1),
                      filled: true
                  ),
                ),
              ),
        ],
      ),
      trailing: new Container(
        child: new IconButton(
            icon: new Icon(Icons.close),
            onPressed:(){
              workoutCardList[cardInd].remove(index);
              setState(() {
              });
            }
        )
        ,
      ),
    );
  }

  // Save current session and pop screen.
  saveSession()
  {
    if(endTime < startTime) {
      final snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.session_time_msg),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if(sessionNameController.text.isEmpty)
      {
        if(widget.fromRoutine)
          sessionNameController.text = defaultName + " " + routineEntry!.name;
        else
          sessionNameController.text = defaultName + " " + AppLocalizations.of(context)!.workout;

      }
    sessionEntry!.name = sessionNameController.text;
    sessionEntry!.parts = partList;

    sessionEntry!.startTime = startTime;
    if(endTime == 0)
      endTime = DateTime.now().millisecondsSinceEpoch;
    sessionEntry!.endTime = endTime;
    sessionEntry!.year = DateTime.fromMillisecondsSinceEpoch(startTime).year;
    sessionEntry!.month = DateTime.fromMillisecondsSinceEpoch(startTime).month;
    sessionEntry!.day = DateTime.fromMillisecondsSinceEpoch(startTime).day;

    List<SessionItem> tempList = [];
    for(WorkoutCard cardItem in workoutCardList)
    {
      if(cardItem.numSets == 0)
        continue;
/*
      // remove invalid sets
      for(int i = cardItem.numSets - 1; i >=0; i--)
        {
          if(cardItem.metricController[i].text.isEmpty && cardItem.countController[i].text.isEmpty)
            cardItem.remove(i);
          else if(![MetricType.km.name, MetricType.floor.name, MetricType.reps.name].contains(cardItem.entry.metric)  && cardItem.metricController[i].text.isEmpty)
            cardItem.remove(i);
          else if (cardItem.entry.metric == MetricType.kg.name && cardItem.countController[i].text.isEmpty)
            cardItem.remove(i);
        }
*/
      // if there's an invalid WorkoutCard, skip it.
      bool skip = true;
      for(int i = 0; i < cardItem.numSets; i++) {
        if ((cardItem.metricController[i].text.isNotEmpty && cardItem.countController[i].text.isNotEmpty) ||
            ([MetricType.km.name, MetricType.floor.name, MetricType.reps.name].contains(cardItem.entry.metric) && cardItem.metricController[i].text.isNotEmpty) ||
            (cardItem.entry.metric == MetricType.kg.name && cardItem.countController[i].text.isNotEmpty)
        )
        {
          skip = false;
          break;
        }
      }
      if(skip)
        continue;

      // Create SessionItem from WorkoutCard
      SessionItem item = new SessionItem();
      item.workoutId = cardItem.entry.id;
      item.time = endTime;
      item.metric = cardItem.entry.metric;
      for(int j = 0; j < cardItem.numSets; j++)
      {
        if ((cardItem.metricController[j].text.isNotEmpty && cardItem.countController[j].text.isNotEmpty) ||
            ([MetricType.km.name, MetricType.floor.name, MetricType.reps.name].contains(cardItem.entry.metric) && cardItem.metricController[j].text.isNotEmpty) ||
            (cardItem.entry.metric == MetricType.kg.name && cardItem.countController[j].text.isNotEmpty)
        )
          item.sets.add(SetItem(
              metricValue: cardItem.metricController[j].text.isNotEmpty ? double.parse(cardItem.metricController[j].text) : 0,
              countValue: cardItem.countController[j].text.isNotEmpty ? int.parse(cardItem.countController[j].text) : 0
          ));
      }
      tempList.add(item);
      widget.objectbox.sessionItemBox.put(item);
      widget.objectbox.itemList.add(item);

      // update workout Entry Previous Session Ids.
      WorkoutEntry workoutEntry = widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId);
      List<SessionItem> itemsForWorkout = widget.objectbox.itemList.where((element) => element.workoutId == workoutEntry.id).toList();

      if(itemsForWorkout.length == 0)
        workoutEntry.prevSessionId = -1;
      else
      {
        itemsForWorkout.sort((a, b) => b.time.compareTo(a.time));
        workoutEntry.prevSessionId = itemsForWorkout[0].id;
      }
      widget.objectbox.workoutBox.put(workoutEntry);
    }

    // if there's nothing to add return.
    if(tempList.length == 0)
    {
      final snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.session_add_workout_msg),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // if editing, remove previous items.
    List<SessionItem> removeItems = [];
    if(widget.edit)
    {
      // remove and remap previous session for the workouts.
      // if the session being changed is the previous session for the workout
      // look for the previous again.
      for(SessionItem item in sessionEntry!.sets)
      {
        removeItems.add(item);
      }
    }
    sessionEntry!.sets.clear();

    // add the new session
    for(SessionItem item in tempList)
      sessionEntry!.sets.add(item);

    // Add Session to DB
    widget.objectbox.sessionBox.put(sessionEntry!);

    // update list and previous session id for workout entries
    for(SessionItem item in removeItems)
    {
      WorkoutEntry workoutEntry = widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId);
      widget.objectbox.sessionItemBox.remove(item.id);
      widget.objectbox.itemList.remove(item);
      if(workoutEntry.prevSessionId == item.id || workoutEntry.prevSessionId == -1)
      {
        List<SessionItem> itemsForWorkout = widget.objectbox.itemList.where((element) => element.workoutId == workoutEntry.id && element.id != item.id).toList();
        if(itemsForWorkout.length == 0)
          workoutEntry.prevSessionId = -1;
        else
          {
            itemsForWorkout.sort((a, b) => b.time.compareTo(a.time));
            workoutEntry.prevSessionId = itemsForWorkout[0].id;
          }
        widget.objectbox.workoutBox.put(workoutEntry);
      }
    }

    // update all lists that changed.
    if(!widget.edit)
      widget.objectbox.sessionList.add(sessionEntry!);
    widget.objectbox.itemList = widget.objectbox.sessionItemBox.getAll();
    print(widget.objectbox.sessionList.length);
    Navigator.pop(context, true);
  }

  Widget _popUpMenuButton() {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text(AppLocalizations.of(context)!.session_set_time_manually),
          value: 0,
        ),
      ],

      onSelected: (selectedIndex) {
        if(selectedIndex == 0){
          setState(() {
            setTime = true;
          });
        }
      },
    );
  }

  Future<int> _selectDate(BuildContext context, int time) async {
    DateTime original = DateTime.fromMillisecondsSinceEpoch(time);
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: original,
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2101)
    );
    if(pickedDate == null)
      return 0;

    TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(original),
        );
    if(pickedTime == null)
      return 0;

    DateTime picked = new DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);

    return picked.millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          Navigator.pop(context, false);
          return true;
        },
        child: new GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: new Scaffold(
                appBar: AppBar(
                  title: Text(widget.edit ? AppLocalizations.of(context)!.session_edit_session : AppLocalizations.of(context)!.session_add_session),
                  backgroundColor: Colors.amberAccent,
                ),
                body: Builder(
                    builder: (context) =>
                        SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text(AppLocalizations.of(context)!.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    )
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    margin: EdgeInsets.all(8.0),
                                    child: Column(
                                        children: <Widget>[
                                          ListTile(
                                              title: new Row(
                                                children: <Widget>[
                                                  new Flexible(
                                                      child: new TextField(
                                                        controller: sessionNameController,
                                                        decoration: InputDecoration(
                                                          border:InputBorder.none,
                                                          hintText: widget.fromRoutine ?  defaultName + " " + routineEntry!.name : defaultName + " " + AppLocalizations.of(context)!.workout,
                                                          hintStyle: TextStyle(
                                                            color: Colors.black26
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                  if(!setTime)
                                                    _popUpMenuButton()
                                                ],
                                              )
                                          ),
                                          ListTile(
                                            title: new Row(
                                              children: <Widget>[
                                                Text(AppLocalizations.of(context)!.session_start_time),
                                                Expanded(child: Container()),
                                                InkWell(
                                                  onTap: () async {
                                                    int newTime = await _selectDate(context, startTime);
                                                    if(newTime != 0)
                                                      setState(() {
                                                        startTime = newTime;
                                                        startDate = timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(startTime));
                                                      });
                                                  },
                                                  child: Text(startDate),
                                                )
                                              ],
                                            )
                                          ),
                                          if(setTime)
                                            ListTile(
                                              title: new Row(
                                                children: <Widget>[
                                                  Text(AppLocalizations.of(context)!.session_end_time),
                                                  Expanded(child: Container()),
                                                  InkWell(
                                                    onTap: () async {
                                                      int newTime = await _selectDate(context, endTime);
                                                      if(newTime != 0)
                                                        setState(() {
                                                        endTime = newTime;
                                                        endDate = timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(endTime));
                                                      });
                                                    },
                                                    child: Text(endDate),
                                                  )
                                                ],
                                              )
                                            ),
                                        ]
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: Text(AppLocalizations.of(context)!.workout_part,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: selectedTagList()
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text(AppLocalizations.of(context)!.routine_details,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    )
                                ),

                                ListView.builder(
                                  itemCount: workoutCardList.length,
                                  itemBuilder: _BuildWorkoutCards,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    margin: EdgeInsets.all(8.0),
                                    child: Column(
                                        children: <Widget>[
                                          AddButton(AppLocalizations.of(context)!.workout_add_workout, AddWorkout)
                                        ]
                                    )
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    margin: EdgeInsets.fromLTRB(8, 0, 8, 20),
                                    color: Theme.of(context).colorScheme.primary,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ListTile(
                                              onTap:(){
                                                saveSession();
                                                },
                                              title: Text(widget.edit ? AppLocalizations.of(context)!.save_changes : AppLocalizations.of(context)!.session_finish_session,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                          )
                                        ]
                                    )
                                ),// Save Button
                              ],
                            )
                        )
                )
            )
        )
    );
  }
}