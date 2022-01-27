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
import 'package:intl/intl.dart';

class AddSessionEntryWidget extends StatefulWidget {
  late ObjectBox objectbox;
  late bool fromRoutine;
  late int id;
  AddSessionEntryWidget({Key? key, required this.objectbox, required this.fromRoutine, required this.id}) : super(key: key);

  @override
  State createState() => _AddSessionEntryState();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class _AddSessionEntryState extends State<AddSessionEntryWidget> {
  String defaultName = "";
  String startDate = "";
  final timeFormatter = new DateFormat('yyyy/MM/dd HH:mm');
  final dateFormatter = new DateFormat('yyyy/MM/dd');
  List<WorkoutEntry> workoutEntryList = [];
  List<WorkoutCard> workoutCardList = [];

  late SessionEntry? sessionEntry;
  final sessionNameController = TextEditingController();
  List<String> partList = [];
  int startTime = 0;
  int endTime = 0;
  int year = 0;
  int month = 0;
  List<SessionItem> sessionItems= [];


  @override
  void initState() {
    super.initState();
    sessionEntry = new SessionEntry();
    DateTime now = new DateTime.now();
    defaultName = dateFormatter.format(now) + " Workout";
    startDate = timeFormatter.format(now);
    startTime = now.millisecondsSinceEpoch;
    if(widget.fromRoutine)
      {
        RoutineEntry routineEntry = widget.objectbox.routineList.firstWhere((element) => element.id == widget.id);
        partList = routineEntry.parts;
        for(String strId in routineEntry.workoutIds)
          {
            int id = int.parse(strId);
            addWorkoutToList(widget.objectbox.workoutList.firstWhere((element) => element.id == id));
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
      tagList.add(tag(partList[i], _openTagPopup, Colors.amberAccent));

    if(partList.length == 0)
      tagList.add(tag(" + Add Part  ", _openTagPopup, Color.fromRGBO(230, 230, 230, 0.8)));
    return tagList;
  }

  void _openTagPopup()
  {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  scrollable: false,
                  title: Text('Choose Parts'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                        alignment: WrapAlignment.start,
                        children: selectPartList(setState)
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        child: Text("Close"),
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

  void AddSet(int cardIndex) {
    workoutCardList[cardIndex].addSet(0, 0);
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
      addWorkoutToList(result as WorkoutEntry);
      setState(() {});
    }
  }

  void addWorkoutToList(WorkoutEntry workoutEntry)
  {
    WorkoutCard newCard = new WorkoutCard(workoutEntry, 0);
    workoutCardList.add(newCard);
    workoutEntryList.add(workoutEntry);
    for(String part in workoutEntry.partList)
      if(!partList.contains(part))
        partList.add(part);
    AddSet(workoutCardList.length - 1);
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
              AddButton("Add Set", (){AddSet(index);})
            ]
        )
    );
  }

  Widget _BuildSets(BuildContext context, int index, int cardInd) {
    return ListTile(
      title: new Row(
        children: <Widget>[
          new Text("10 × 10",
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
            if(workoutCardList[cardInd].entry.metric == MetricType.kg.name || workoutCardList[cardInd].entry.metric == MetricType.none.name)
              new Text(" × "),
            if(workoutCardList[cardInd].entry.metric == MetricType.kg.name || workoutCardList[cardInd].entry.metric == MetricType.none.name)
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
                  title: Text("Add Workout Session"),
                  backgroundColor: Colors.amberAccent,
                ),
                body: Builder(
                    builder: (context) =>
                        SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // System Values
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text("Name",
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
                                                          hintText: defaultName,
                                                          hintStyle: TextStyle(
                                                            color: Colors.black26
                                                          ),
                                                        ),
                                                      )
                                                  )
                                                ],
                                              )
                                          ),
                                          ListTile(
                                              title: new Row(
                                                children: <Widget>[
                                                  Text("Start Time:\t"),
                                                  Expanded(child: Container()),
                                                  Text(startDate),
                                                ],
                                              )
                                          ),
                                        ]
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: Text("Workout Part",
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
                                    child: Text("Routine Details",
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
                                          AddButton("Add Workout", AddWorkout)
                                        ]
                                    )
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    color: Theme.of(context).colorScheme.primary,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ListTile(
                                              onTap:(){
                                                if(sessionNameController.text.isEmpty)
                                                  sessionNameController.text = defaultName;
                                                sessionEntry!.name = sessionNameController.text;
                                                sessionEntry!.parts = partList;

                                                sessionEntry!.startTime = startTime;
                                                if(endTime == 0)
                                                  endTime = DateTime.now().millisecondsSinceEpoch;
                                                sessionEntry!.endTime = endTime;
                                                sessionEntry!.year = DateTime.fromMillisecondsSinceEpoch(startTime).year;
                                                sessionEntry!.month = DateTime.fromMillisecondsSinceEpoch(startTime).month;
                                                sessionEntry!.day = DateTime.fromMillisecondsSinceEpoch(startTime).day;

                                                for(WorkoutCard i in workoutCardList)
                                                  {
                                                    SessionItem item = new SessionItem();
                                                    item.workoutId = i.entry.id;
                                                    item.time = endTime;
                                                    for(int j = 0; j < i.numSets; j++)
                                                      {
                                                        item.sets.add(SetItem(
                                                            metricValue: i.metricController[j].text.isNotEmpty ? int.parse(i.metricController[j].text) : 0,
                                                            countValue: i.countController[j].text.isNotEmpty ? int.parse(i.countController[j].text) : 0
                                                        ));
                                                      }
                                                    sessionEntry!.sets.add(item);
                                                    widget.objectbox.sessionItemBox.put(item);

                                                    WorkoutEntry workoutEntry = widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId);

                                                    if(workoutEntry.prevSessionId == 0 || widget.objectbox.itemList.firstWhere((element) => element.id == workoutEntry.prevSessionId).time < item.time)
                                                      {
                                                        workoutEntry.prevSessionId = item.id;
                                                        widget.objectbox.workoutBox.put(workoutEntry);
                                                      }
                                                  }
                                                widget.objectbox.workoutList = widget.objectbox.workoutBox.getAll().toList();
                                                widget.objectbox.sessionBox.put(sessionEntry!);
                                                widget.objectbox.sessionList.add(sessionEntry!);
                                                Navigator.pop(context, true);
                                              },
                                              title: Text("Finish Session",
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