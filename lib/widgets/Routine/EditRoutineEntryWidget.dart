import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/RoutineEntry.dart';

class EditRoutineEntryWidget extends StatefulWidget {
  final RoutineEntry entry;

  EditRoutineEntryWidget({Key key, this.entry}) : super(key: key);

  @override
  State createState() => _EditRoutineState();
}

class _EditRoutineState extends State<EditRoutineEntryWidget> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          Navigator.pop(context, widget.entry);
          return true;
        },
        child: new Scaffold(
            appBar: AppBar(
              title: Text("Edit Entry"),
            ),
            body: Builder(
                builder: (context) =>
                    SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Text("Amount of Spending",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey
                                  ),
                                )
                            ),
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              margin: EdgeInsets.all(8.0),
                              child: ListTile(
                                  title: new Row(
                                    children: <Widget>[
                                      Flexible(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Spending Amount',
                                            ),
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.start,
                                          )
                                      )
                                    ],
                                  )
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Text("Description",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey
                                  ),
                                )
                            ),
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              margin: EdgeInsets.all(8.0),
                              child: ListTile(
                                  title: new Row(
                                    children: <Widget>[
                                      Flexible(
                                          child: TextField(
                                            style: TextStyle(height: 1.5),
                                            minLines: 3,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Enter what this spending was for',
                                            ),
                                            textAlign: TextAlign.start,
                                          )
                                      )
                                    ],
                                  )
                              ),
                            ),
                            Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                color: Color.fromRGBO(155, 195, 255, 1),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                          onTap:(){
                                            Navigator.pop(context, widget.entry);
                                          },
                                          title: Text("Save Changes",
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                      )
                                    ]
                                )
                            )
                          ],
                        )
                    )
            )
        )
    );
  }
}