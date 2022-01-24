import 'package:flutter/material.dart';
import 'package:workout_tracker/class/WorkoutCard.dart';
import 'package:workout_tracker/dbModels/routine_entry_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/objectbox.g.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/widgets/Routine/WorkoutListWidget.dart';

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
  final RoutineNameController = TextEditingController();
  final descriptionController = TextEditingController();

  late RoutineEntry? newEntry;

  List<String> partList = [];
  List<WorkoutEntry> WorkoutEntryList = [];
  List<WorkoutCard> WorkoutCardList = [];

  @override
  void initState() {
    super.initState();
    if(widget.edit)
    {
      newEntry = widget.objectbox.routineBox.get(widget.id);
      caption = newEntry!.name;
      RoutineNameController.text = caption;
      descriptionController.text = newEntry!.description;
      partList = newEntry!.parts;
      for(WorkoutEntry i in newEntry!.workoutList) {
        WorkoutEntryList.add(i);
        WorkoutCard newCard = new WorkoutCard(i);
        WorkoutCardList.add(newCard);
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
    WorkoutCardList.removeAt(ind);
    WorkoutEntryList.removeAt(ind);
    setState(() {});
  }

  void AddWorkout() async {
    // start the SecondScreen and wait for it to finish with a result
      final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutListWidget(objectbox: widget.objectbox, list: WorkoutEntryList,),
      ));

      if(result.runtimeType == WorkoutEntry)
      {
        WorkoutEntry workoutEntry = result as WorkoutEntry;
        WorkoutCard newCard = new WorkoutCard(workoutEntry);
        WorkoutCardList.add(newCard);
        WorkoutEntryList.add(workoutEntry);
        setState(() {});
      }
  }

  Widget _BuildWorkoutCards(BuildContext context, int index) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.all(6.0),
        child: Column(
            children: <Widget>[
              ListTile(
                title: new Row(
                  children: <Widget>[
                    new Flexible(
                        child: new Text(WorkoutCardList[index].entry.caption.capitalize(),
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
                        WorkoutCardList.removeAt(index);
                        setState(() {
                        });
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
                      children: SelectPartList(setState)
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

  List<Widget> SelectPartList(setDialogState)
  {
    List<Widget> taglist = [];

    for(int i = 0; i < PartType.values.length; i++)
      {
        PartType p = PartType.values[i];
        taglist.add(tag(p.name, () => {partList.add(p.name)}, Colors.amberAccent, true, setDialogState));
      }

    return taglist;
  }

  List<Widget> SelectedTagList()
  {
    List<Widget> taglist = [];

    for(int i = 0; i < partList.length; i++)
      taglist.add(tag(partList[i], (){}, Colors.amberAccent, false, (){}));

    partList.length == 0 ?
      taglist.add(tag(" + Add Part  ", _openTagPopup, Color.fromRGBO(230, 230, 230, 0.8), false, (){})):
      taglist.add(tag("Edit Parts", _openTagPopup, Color.fromRGBO(255, 255, 255, 0), false, (){}));
    return taglist;
  }

  Widget tag(String caption, onTap, color, inDialog, setDialogState) {
    return Stack(
          children: [
            SizedBox(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 5.0,
                ),
                child: InkWell(
                  onTap: inDialog ? () {
                    if(partList.contains(caption))
                      partList.remove(caption);
                    else
                      partList.add(caption);
                    setState(() {});
                    setDialogState((){});
                  } : onTap,
                  borderRadius: BorderRadius.circular(20),
                  child:Container(
                    padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                    decoration: BoxDecoration(
                      color: !inDialog ? color :
                            partList.contains(caption) ?
                            Colors.amber : Colors.amberAccent,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(caption,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
                                                        controller: RoutineNameController,
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
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  children: SelectedTagList()
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
                                  itemCount: WorkoutCardList.length,
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
                                                if(RoutineNameController.text.isEmpty) {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Please enter name for new routine'),
                                                  );

                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  return;
                                                }
                                                newEntry!.name = RoutineNameController.text;
                                                newEntry!.description = descriptionController.text;
                                                newEntry!.workoutList.clear();
                                                for(WorkoutEntry i in WorkoutEntryList)
                                                  newEntry!.workoutList.add(i);
                                                newEntry!.parts = partList;
                                                widget.objectbox.routineBox.put(newEntry!);
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