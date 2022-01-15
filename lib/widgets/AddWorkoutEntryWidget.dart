import 'package:flutter/material.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/db/database_helpers.dart';

class AddWorkoutEntryWidget extends StatefulWidget {
  DatabaseHelper dbHelper;

  AddWorkoutEntryWidget({Key key, this.dbHelper}) : super(key: key);
  @override
  State createState() => _AddWorkoutEntryState();
}

class _AddWorkoutEntryState extends State<AddWorkoutEntryWidget> {
  String part, type, metric, caption;
  final workoutNameController = TextEditingController();

  @override
  void initState() {
    part = PartType.other.name;
    type = WorkoutType.other.name;
    metric = MetricType.kg.name;
    caption = "";
    super.initState();
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
                  title: Text("Add Workout"),
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
                                    child: Text("Workout Name",
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
                                                    controller: workoutNameController,
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
                                                Text("Part"),
                                                Spacer(),
                                                DropdownButton<String>(
                                                  value: part,
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  onChanged: (value){
                                                    setState(() {part = value;});
                                                    },
                                                  underline: Container(
                                                    height: 2,
                                                  ),
                                                  selectedItemBuilder: (BuildContext context) {
                                                    return PartType.values.map<Widget>((PartType value) {
                                                      return Container(
                                                          alignment: Alignment.centerRight,
                                                          width: 100, // TODO: Find Proper Width
                                                          child: Text(value.name, textAlign: TextAlign.end)
                                                      );
                                                    }).toList();
                                                  },
                                                  items: PartType.values
                                                      .map<DropdownMenuItem<String>>((PartType value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value.name,
                                                      child: Text(value.name),
                                                    );
                                                  }).toList(),
                                                )
                                              ],
                                            )
                                        ), // Part Dropdown
                                        ListTile(
                                            title: new Row(
                                              children: <Widget>[
                                                Text("Type"),
                                                Spacer(),
                                                DropdownButton<String>(
                                                  value: type,
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  onChanged: (value){
                                                    setState(() {type = value;});
                                                  },
                                                  underline: Container(
                                                    height: 2,
                                                  ),
                                                  selectedItemBuilder: (BuildContext context) {
                                                    return WorkoutType.values.map<Widget>((WorkoutType value) {
                                                      return Container(
                                                          alignment: Alignment.centerRight,
                                                          width: 100, // TODO: Find Proper Width
                                                          child: Text(value.name, textAlign: TextAlign.end)
                                                      );
                                                    }).toList();
                                                  },
                                                  items: WorkoutType.values
                                                      .map<DropdownMenuItem<String>>((WorkoutType value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value.name,
                                                      child: Text(value.name),
                                                    );
                                                  }).toList(),
                                                )
                                              ],
                                            )
                                        ), // Type Dropdown
                                        ListTile(
                                            title: new Row(
                                              children: <Widget>[
                                                Text("Metric"),
                                                Spacer(),
                                                DropdownButton<String>(
                                                  value: metric,
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  onChanged: (value){
                                                    setState(() {metric = value;});
                                                  },
                                                  underline: Container(
                                                    height: 2,
                                                  ),
                                                  selectedItemBuilder: (BuildContext context) {
                                                    return MetricType.values.map<Widget>((MetricType value) {
                                                      return Container(
                                                          alignment: Alignment.centerRight,
                                                          width: 100, // TODO: Find Proper Width
                                                          child: Text(value.name, textAlign: TextAlign.end)
                                                      );
                                                    }).toList();
                                                  },
                                                  items: MetricType.values
                                                      .map<DropdownMenuItem<String>>((MetricType value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value.name,
                                                      child: Text(value.name),
                                                    );
                                                  }).toList(),
                                                )
                                              ],
                                            )
                                        ), // Metric Dropdown
                                      ],
                                    )
                                ),

                                Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    color: Color.fromRGBO(149, 213, 178, 1),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ListTile(
                                              onTap:(){
                                                if(workoutNameController.text.isEmpty) {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Please enter name for new workout'),
                                                  );

                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  return;
                                                }

                                                WorkoutEntry newEntry = new WorkoutEntry();
                                                newEntry.caption = workoutNameController.text;
                                                newEntry.type = WorkoutType.values.firstWhere((e) => e.toString() == 'WorkoutType.' + type);
                                                newEntry.part = PartType.values.firstWhere((e) => e.toString() == 'PartType.' + part);
                                                newEntry.metric = MetricType.values.firstWhere((e) => e.toString() == 'MetricType.' + metric);
                                                widget.dbHelper.insertWorkoutEntry(newEntry);

                                                Navigator.pop(context, false);
                                              },
                                              title: Text("Add Workout",
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