import 'package:flutter/material.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/widgets/Session/AddSessionEntryWidget.dart';
import 'package:workout_tracker/widgets/Session/RoutineListWidget.dart';

class DashboardWidget extends StatefulWidget {
  late ObjectBox objectbox;

  DashboardWidget({Key? key, required this.objectbox}) : super(key: key);

  @override
  State createState() => _DashboardState();
}

class _DashboardState extends State<DashboardWidget>{

  void initState() {
    super.initState();
  }

  Widget profileCard()
  {
    return Container(
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          color: Colors.white,
          child: new InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {},
              child: ListTile(
                leading: SizedBox(
                    height: 120,
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.brown.shade800,
                      child: const Text('AH'),
                    ),
                ),
                dense: true,
                title: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "Name",
                          style: TextStyle(color: Colors.black)
                      ),
                    ],
                  ),
                ),
                subtitle: Text("Description"),
            )
          )
        )
    );
  }

  void startNewSession(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddSessionEntryWidget(objectbox: widget.objectbox, fromRoutine:false, edit: false, id:0),
        ));

    if(result.runtimeType == bool && result)
      setState(() {});
  }

  void startRoutineSession(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    int i = widget.objectbox.sessionList.length;
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoutineListWidget(objectbox: widget.objectbox),
        ));
    if(result.runtimeType == bool && result)
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double circleBorderWidth = 8.0;

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
                expandedHeight: 100.0,
//                actions: _buildActions(),
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Dashboard'),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                    [
                      new Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                          color: Colors.white,
                          child: new InkWell(
                              borderRadius: BorderRadius.circular(10.0),
                              onTap: () {},
                              child: SizedBox(
                                  height: 100,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black26,
                                          radius: 40,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                        child:RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Welcome back,\n",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 17,
                                                      height: 1.2
                                                  )
                                              ),
                                              TextSpan(
                                                  text: "[UserName]\n",
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 22,
                                                      height: 1.2
                                                  )
                                              ),
                                              // Workout Parts
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              )
                          )
                      ),
                      Row(
                        children: [
                          Expanded(child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            margin: EdgeInsets.fromLTRB(5, 5, 2, 5),
                            color: Colors.amber,
                            child: new InkWell(
                                borderRadius: BorderRadius.circular(10.0),
                                onTap: (){startNewSession(context);},
                                child: SizedBox(
                                  height: 50,
                                  child: Center(
                                    child:Text("Start Workout",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )
                                  ),
                                )
                              )
                            ),
                          ),
                          Expanded(
                            child:
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                color: Colors.amberAccent,
                                margin: EdgeInsets.fromLTRB(2, 5, 5, 5),
                                child: new InkWell(
                                    borderRadius: BorderRadius.circular(10.0),
                                    onTap: (){startRoutineSession(context);},
                                    child: SizedBox(
                                      height: 50,
                                      child: Center(
                                          child:Text("Start Routine",
                                            style: TextStyle(
                                            fontSize: 16,
                                            ),
                                          )
                                      ),
                                    )
                                )
                            )
                          ),
                        ],
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
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              color: Colors.white,
                              child: new InkWell(
                                borderRadius: BorderRadius.circular(10.0),
                                onTap: (){},
                                child: SizedBox(
                                  height: 120,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Total Session Count: " + widget.objectbox.sessionList.length.toString(),
                                              style: TextStyle(color: Colors.black)
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                )
                              )
                            ),
                          ),
                        ]
                      )
                    ]
                ),
              ),
            ],
          ),
        )
    );
  }
}