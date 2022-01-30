import 'package:flutter/material.dart';
import 'package:workout_tracker/class/WorkoutCard.dart';
import 'package:workout_tracker/dbModels/session_entry_model.dart';
import 'package:workout_tracker/dbModels/session_item_model.dart';
import 'package:workout_tracker/dbModels/set_item_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/widgets/Routine/WorkoutListWidget.dart';
import 'package:workout_tracker/widgets/UIComponents.dart';
import 'package:workout_tracker/util/languageTool.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class ViewSessionEntryWidget extends StatefulWidget {
  late ObjectBox objectbox;
  late int id;
  ViewSessionEntryWidget({Key? key, required this.objectbox, required this.id}) : super(key: key);

  @override
  State createState() => _ViewSessionEntryState();
}

class _ViewSessionEntryState extends State<ViewSessionEntryWidget> {
  List<WorkoutEntry> workoutEntryList = [];
  List<WorkoutCard> workoutCardList = [];

  final timeFormatter = new DateFormat('yyyy/MM/dd HH:mm');
  String timeRange = "";
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

    sessionEntry = widget.objectbox.sessionList.firstWhere((element) => element.id == widget.id);
    sessionNameController.text = sessionEntry!.name;
    startTime = sessionEntry!.startTime;
    endTime = sessionEntry!.endTime;
    partList = sessionEntry!.parts;
    timeRange = timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(startTime)) + " - " + timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(endTime));

    for(SessionItem item in sessionEntry!.sets)
    {
      addWorkoutToList(widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId), false);
      for(SetItem setItem in item.sets)
      {
        AddSet(workoutCardList.length - 1, setItem.metricValue, setItem.countValue);
      }
    }

  }

  List<Widget> selectPartList(setDialogState) {
    List<Widget> tagList = [];

    for (int i = 0; i < PartType.values.length; i++) {
      PartType p = PartType.values[i];
      tagList.add(
          tag(p.name,
                  () {
                if (partList.contains(p.name))
                  partList.remove(p.name);
                else
                  partList.add(p.name);
                setState(() {});
                setDialogState(() {});
              },
              partList.contains(p.name) ? Colors.amber : Colors.black12)
      );
    }
    return tagList;
  }

  // List of Tags in partList
  List<Widget> selectedTagList()
  {
    List<Widget> tagList = [];

    for(int i = 0; i < sessionEntry!.parts.length; i++)
      tagList.add(tag(sessionEntry!.parts[i], (){}, Color.fromRGBO(210, 210, 210, 0.8)));
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
              AddButton("Add Set", (){AddSet(index, 0, 0);})
            ]
        )
    );
  }

  String overViewText()
  {
    String overview = "";
    overview += "Workout Count: " + sessionEntry!.sets.length.toString();

    return overview;
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
          prev = sessionItem.sets[index].metricValue.toString();
          if(workoutCardList[cardInd].entry.metric != MetricType.none.name)
            prev += " " + workoutCardList[cardInd].entry.metric;
          if(workoutCardList[cardInd].entry.metric == MetricType.kg.name || workoutCardList[cardInd].entry.metric == MetricType.none.name)
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
                  title: Text("Session Info"),
                  backgroundColor: Colors.amberAccent,
                ),
                body: Builder(
                    builder: (context) =>
                        SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                                    child: Text(sessionEntry!.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                          color: Colors.black87
                                      ),
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text(timeRange,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    )
                                ),
                                if(sessionEntry!.parts.length > 0)
                                    Container(
                                    margin: EdgeInsets.fromLTRB(20, 5, 10, 0),
                                    child: Wrap(
                                        alignment: WrapAlignment.start,
                                        children: selectedTagList()
                                    ),
                                  ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text("Overview",
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
                                                      child: new Text(
                                                          overViewText(),
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 14
                                                        ),
                                                      )
                                                  )
                                                ],
                                              )
                                          ),
                                        ]
                                    )
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
                              ],
                            )
                        )
                )
            )
        )
    );
  }
}