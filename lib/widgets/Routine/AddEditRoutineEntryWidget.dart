import 'package:flutter/material.dart';
import 'package:workout_tracker/class/WorkoutCard.dart';
import 'package:workout_tracker/dbModels/routine_entry_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/widgets/Routine/WorkoutListWidget.dart';
import 'package:workout_tracker/widgets/UIComponents.dart';

class AddRoutineEntryWidget extends StatefulWidget {
  late ObjectBox objectbox;
  late bool edit;
  late int id;
  AddRoutineEntryWidget({Key? key, required this.objectbox, required this.edit, required this.id}) : super(key: key);

  @override
  State createState() => _AddRoutineEntryState();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class _AddRoutineEntryState extends State<AddRoutineEntryWidget> {
  String caption = "";
  final routineNameController = TextEditingController();
  final descriptionController = TextEditingController();

  late RoutineEntry? newEntry;

  List<String> partList = [];
  List<WorkoutEntry> WorkoutEntryList = [];

  @override
  void initState() {
    super.initState();
    if(widget.edit)
    {
      newEntry = widget.objectbox.routineBox.get(widget.id);
      caption = newEntry!.name;
      routineNameController.text = caption;
      descriptionController.text = newEntry!.description;
      partList = newEntry!.parts;
      for(String i in newEntry!.workoutIds) {
        WorkoutEntry? tmp = widget.objectbox.workoutBox.get(int.parse(i));
        if(tmp != null)
          {
            WorkoutEntryList.add(tmp);
          }
      }

    }
    else
      newEntry = new RoutineEntry();
    setState(() {});
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

  void removeWorkout(int ind){
    WorkoutEntryList.removeAt(ind);
    setState(() {});
  }

  void addWorkout() async {
    // start the SecondScreen and wait for it to finish with a result
      final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutListWidget(objectbox: widget.objectbox, list: WorkoutEntryList,),
      ));

      if(result.runtimeType == WorkoutEntry)
      {
        WorkoutEntry workoutEntry = result as WorkoutEntry;
        WorkoutEntryList.add(workoutEntry);
        for(String part in workoutEntry.partList)
          if(!partList.contains(part))
            partList.add(part);
        setState(() {});
      }
  }

  Widget buildWorkoutCards(BuildContext context, int index) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.all(6.0),
        child: Column(
            children: <Widget>[
              ListTile(
                title: new Row(
                  children: <Widget>[
                    new Flexible(
                        child: new Text(WorkoutEntryList[index].caption.capitalize(),
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
                        removeWorkout(index);
                      }
                  )
                  ,
                ),
              ),
            ]
        )
    );
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
                  title: Text(widget.edit? "Edit Routine" : "Add Routine"),
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
                                    child: Text("Routine Name",
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
                                                        controller: routineNameController,
                                                        decoration: InputDecoration(
                                                          border:InputBorder.none,
                                                          hintText: "Enter Name",
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
                                  itemCount: WorkoutEntryList.length,
                                  itemBuilder: buildWorkoutCards,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    margin: EdgeInsets.all(8.0),
                                    child: Column(
                                        children: <Widget>[
                                          AddButton("Add Workout", addWorkout)
                                        ]
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text("Note",
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
                                                      child: new TextFormField(
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: null,
                                                        minLines: 3,
                                                        controller: descriptionController,
                                                        decoration: InputDecoration(
                                                          border:InputBorder.none,
                                                          hintText: "Add Note",
                                                        ),
                                                      )
                                                  )
                                                ],
                                              )
                                          ),
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
                                                if(routineNameController.text.isEmpty) {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Please enter name for new routine'),
                                                  );

                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  return;
                                                }
                                                newEntry!.name = routineNameController.text;
                                                newEntry!.description = descriptionController.text;
                                                newEntry!.workoutIds.clear();
                                                for(WorkoutEntry i in WorkoutEntryList)
                                                  newEntry!.workoutIds.add(i.id.toString());
                                                newEntry!.parts = partList;
                                                widget.objectbox.routineBox.put(newEntry!);
                                                widget.objectbox.routineList = widget.objectbox.routineBox.getAll();
                                                Navigator.pop(context, true);
                                              },
                                              title: Text(widget.edit ? "Save Changes" : "Add Routine",
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