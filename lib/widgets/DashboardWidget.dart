import 'package:flutter/material.dart';
import 'package:workout_tracker/util/StringTool.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/widgets/Session/AddSessionEntryWidget.dart';
import 'package:workout_tracker/widgets/Session/RoutineListWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:workout_tracker/widgets/Setting/ProfileSettingWidget.dart';

class DashboardWidget extends StatefulWidget {
  late ObjectBox objectbox;
  DashboardWidget({Key? key, required this.objectbox}) : super(key: key);

  @override
  State createState() => _DashboardState();
}

class _DashboardState extends State<DashboardWidget>{
  String username = "";
  Image? img_file;
  void initState() {
    super.initState();
    getUsername();
    getUserImage();
    setState(() {});
  }

  getUsername() async {
    String? getName = widget.objectbox.getPref('user_name');
    username = getName != null ? getName : "User";
  }

  getUserImage() async {
    String? profileImage = widget.objectbox.getPref('profile_image');
    if(profileImage == null)
      return;

    img_file = imageFromBase64String(profileImage);
  }

  Widget profileCard()
  {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
        color: Colors.white,
        child: new InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {
              openProfilePage(context);
            },
            child: SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      child: CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.amberAccent,
                        child: CircleAvatar(
                          radius: 40,
                          child: ClipOval(
                            child: (img_file != null)
                                ? img_file
                                : null,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child:RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: AppLocalizations.of(context)!.dashboard_welcome_back + "\n",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 17,
                                    height: 1.2
                                )
                            ),
                            TextSpan(
                                text: username + AppLocalizations.of(context)!.dashboard_post_name + "\n",
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
    );
  }

  void startNewSession(BuildContext context) async {
    setState(() {

    });
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

  void openProfilePage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSettingsWidget(objectbox: widget.objectbox,),
        ));

    if(result.runtimeType == bool && result)
    {
      getUsername();
      getUserImage();
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
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
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(AppLocalizations.of(context)!.dashboard),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                    [
                      profileCard(),
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
                                    child:Text(AppLocalizations.of(context)!.dashboard_start_workout,
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
                                          child:Text(AppLocalizations.of(context)!.dashboard_start_routine,
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
                          child: Text(AppLocalizations.of(context)!.dashboard_overview,
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
                                              text: AppLocalizations.of(context)!.dashboard_total_session_count + widget.objectbox.sessionList.length.toString(),
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