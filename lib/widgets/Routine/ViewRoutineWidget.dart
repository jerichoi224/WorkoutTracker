import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/routine_entry_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/widgets/Routine/AddEditRoutineEntryWidget.dart';
import 'package:workout_tracker/widgets/UIComponents.dart';
import 'package:workout_tracker/util/StringTool.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewRoutineEntryWidget extends StatefulWidget {
  late ObjectBox objectbox;
  late int id;
  ViewRoutineEntryWidget({Key? key, required this.objectbox, required this.id}) : super(key: key);

  @override
  State createState() => _ViewRoutineEntryState();
}

class _ViewRoutineEntryState extends State<ViewRoutineEntryWidget> {
  late RoutineEntry? routineEntry;

  List<String> partList = [];
  List<WorkoutEntry> WorkoutEntryList = [];

  @override
  void initState() {
    super.initState();

    routineEntry = widget.objectbox.routineBox.get(widget.id);
    partList = routineEntry!.parts;
    for(String i in routineEntry!.workoutIds) {
      WorkoutEntry? tmp = widget.objectbox.workoutBox.get(int.parse(i));
      if (tmp != null) {
        WorkoutEntryList.add(tmp);
      }
    }

    setState(() {});
  }

  void updateInfo()
  {
    routineEntry = widget.objectbox.routineList.firstWhere((element) => element.id == widget.id);
  }

  Widget buildWorkoutCards(BuildContext context, int index) {
    return ListTile(
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
    );
  }

  // List of Tags in partList
  List<Widget> selectedTagList()
  {
    List<Widget> tagList = [];

    for(int i = 0; i < routineEntry!.parts.length; i++)
      tagList.add(tag(routineEntry!.parts[i], (){}, Color.fromRGBO(210, 210, 210, 0.8)));
    return tagList;
  }

  void _openEditWidget(RoutineEntry entry) async {
    // start the SecondScreen and wait for it to finish with a   result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddRoutineEntryWidget(objectbox: widget.objectbox, edit:true, id:entry.id),
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
          _openEditWidget(routineEntry!);
        },
      ),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            widget.objectbox.routineList.removeWhere((element) => element.id == routineEntry!.id);
            widget.objectbox.routineBox.remove(routineEntry!.id);
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
          return true;
        },
        child: new GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: new Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.routine_details),
                  backgroundColor: Colors.amberAccent,
                  actions: _buildActions(),
                ),
                body: Builder(
                    builder: (context) =>
                        SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                                    child: Text(routineEntry!.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                          color: Colors.black87
                                      ),
                                    )
                                ),
                                if(routineEntry!.parts.length > 0)
                                    Container(
                                    margin: EdgeInsets.fromLTRB(20, 5, 10, 0),
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
                                Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    margin: EdgeInsets.all(6.0),
                                    child: Column(
                                      children: <Widget>[
                                        ListView.builder(
                                          itemCount: WorkoutEntryList.length,
                                          itemBuilder: buildWorkoutCards,
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                        ),
                                      ]
                                    )
                                ),
                                if(routineEntry!.description.isNotEmpty)
                                  Container(
                                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      child: Text(AppLocalizations.of(context)!.note,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey
                                        ),
                                      )
                                  ),
                                if(routineEntry!.description.isNotEmpty)
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
                                                        controller: TextEditingController()..text = routineEntry!.description,
                                                        maxLines: null,
                                                        minLines: 3,
                                                        enabled: false,
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
                              ],
                            )
                        )
                )
            )
        )
    );
  }
}