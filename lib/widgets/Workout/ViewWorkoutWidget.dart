import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/widgets/UIComponents.dart';
import 'package:workout_tracker/widgets/Workout/AddEditWorkoutEntryWidget.dart';
class ViewWorkoutWidget extends StatefulWidget {
  late ObjectBox objectbox;
  late int id;
  ViewWorkoutWidget({Key? key, required this.objectbox, required this.id}) : super(key: key);
  @override
  State createState() => _ViewWorkoutWidget();
}

class _ViewWorkoutWidget extends State<ViewWorkoutWidget> {
  late WorkoutEntry? workoutEntry;

  @override
  void initState() {
    super.initState();
    updateInfo();
  }

  void updateInfo()
  {
    workoutEntry = widget.objectbox.workoutList.firstWhere((element) => element.id == widget.id);
  }

  // List of Tags in partList
  List<Widget> selectedTagList()
  {
    List<Widget> tagList = [];

    for(int i = 0; i < workoutEntry!.partList.length; i++)
      tagList.add(tag(workoutEntry!.partList[i], (){}, Color.fromRGBO(210, 210, 210, 0.8)));

    if(workoutEntry!.partList.length == 0)
      tagList.add(tag(" None ", (){}, Color.fromRGBO(230, 230, 230, 0.8)));
    return tagList;
  }

  void _openEditWidget(WorkoutEntry workoutEntry) async {
    // start the SecondScreen and wait for it to finish with a   result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddWorkoutEntryWidget(objectbox: widget.objectbox, edit:true, id:workoutEntry.id),
        ));

    if(result)
      {
        updateInfo();
        setState(() {});
      }
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: (){
          _openEditWidget(workoutEntry!);
        },
      ),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            workoutEntry!.visible = false;
            widget.objectbox.workoutBox.put(workoutEntry!);
            widget.objectbox.workoutList.remove(workoutEntry);
            Navigator.pop(context, true);
          }
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          Navigator.pop(context, false);
          return false;
        },
        child: new GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: new Scaffold(
                appBar: AppBar(
                  title: Text("Workout Info"),
                  backgroundColor: Colors.amberAccent,
                  actions: _buildActions(),
                ),
                body: Builder(
                    builder: (context) =>
                        SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // System Values
                                Container(
                                    padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                                    child: Text(workoutEntry!.caption,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                          color: Colors.black87
                                      ),
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 5, 10, 0),
                                  child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: selectedTagList()
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text("Workout Details",
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
                                                Text("Type"),
                                                Spacer(),
                                                Text(workoutEntry!.type.capitalize()),
                                              ],
                                            )
                                        ),
                                        ListTile(
                                            title: new Row(
                                              children: <Widget>[
                                                Text("Metric"),
                                                Spacer(),
                                                Text(workoutEntry!.metric.capitalize()),
                                              ],
                                            )
                                        ), // Metric Dropdown
                                      ],
                                    )
                                ),
                                if(workoutEntry!.description.isNotEmpty)
                                  Container(
                                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      child: Text("Note",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey
                                        ),
                                      )
                                  ),
                                if(workoutEntry!.description.isNotEmpty)
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
                                                        controller: TextEditingController()..text = workoutEntry!.description,
                                                        enabled: false,
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: null,
                                                        minLines: 4,
                                                        decoration: InputDecoration(
                                                          border:InputBorder.none,
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
                                    child: Text("Track Record",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    )
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