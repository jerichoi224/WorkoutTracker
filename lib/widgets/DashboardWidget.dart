import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:workout_tracker/dbModels/session_entry_model.dart';
import 'package:workout_tracker/util/StringTool.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';
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
  int overviewCount = 0;
  String overviewTime = "";
  List<_PieData> pie_data = [];
  String locale = "";

  bool firstTime = true;

  void initState() {
    super.initState();

    String? temp = widget.objectbox.getPref("locale");
    locale = temp != null ? temp : 'en';
  }

  updateInfo(){
    getUsername();
    getUserImage();
    getOverviewInfo();
    setState(() {});
  }

  void getOverviewInfo(){
    // reset variables
    overviewCount = 0;
    overviewTime = "";
    pie_data.clear();
    DateTime today = DateTime.now();

    List<SessionEntry> currentMonth = widget.objectbox.sessionList.where((element) => element.year == today.year && element.month == today.month).toList();
    overviewCount = currentMonth.length;

    Map partCount = new Map();
    int timeSum = 0;
    for(SessionEntry entry in currentMonth)
      {
        for(String part in entry.parts)
          if(partCount.keys.contains(part))
            partCount[part] += 1;
          else
            partCount[part] = 1;
    
        timeSum += entry.endTime - entry.startTime;
      }
    
    for(String part in partCount.keys)
      {
        String part_locale = PartType.values.firstWhere((element) => element.name == part).toLanguageString(locale);
        pie_data.add(_PieData(part_locale, partCount[part], part_locale + ": " + partCount[part].toString()));
      }

    timeSum ~/=60000;

    if(timeSum > 60)
      overviewTime += (timeSum ~/ 60).toString() + AppLocalizations.of(context)!.hour + " ";
    overviewTime += (timeSum % 60).toString() + " " + AppLocalizations.of(context)!.minute;

  }

  TextStyle contentStyle = TextStyle(
      fontSize: 14,
      color: Colors.black87,
      height: 1.5
  );

  Widget overviewTable()
  {
    List<TableRow> detailsInfo = [];
    detailsInfo.add(
        TableRow(
            children: [
              Text(
                  AppLocalizations.of(context)!.dashboard_month_session_count,
                  textAlign: TextAlign.left,
                  style: contentStyle
              ),
              Text(
                  overviewCount.toString(),
                  textAlign: TextAlign.left,
                  style: contentStyle
              ),
            ]
        )
    );
    detailsInfo.add(
        TableRow(
            children: [
              Text(
                  AppLocalizations.of(context)!.dashboard_month_session_time,
                  textAlign: TextAlign.left,
                  style: contentStyle
              ),
              Text(
                  overviewTime.toString(),
                  textAlign: TextAlign.left,
                  style: contentStyle
              ),
            ]
        )
    );

    return Table(
      border: TableBorder(),
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
      },
     children: detailsInfo,
    );
  }

  getUsername() async {
    String? getName = widget.objectbox.getPref('user_name');
    username = getName != null ? getName : "User";
  }

  getUserImage() async {
    String? profileImage = widget.objectbox.getPref('profile_image');
    if(profileImage == null || profileImage.isEmpty)
      {
        img_file = null;
        return;
      }

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
            },
            child: SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        openProfilePage(context);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.amberAccent,
                          child: CircleAvatar(
                            radius: 40,
                            child: (img_file != null) ?
                            ClipOval(
                                child:  img_file
                            ):
                            Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.black54,
                            ),
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
    // start the SecondScreen and wait for it to finish with a result
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddSessionEntryWidget(objectbox: widget.objectbox, fromRoutine:false, edit: false, id:0),
        ));

    if(result.runtimeType == bool && result)
      {
        updateInfo();
        setState(() {});
      }
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
      {
        updateInfo();
        setState(() {});
      }
  }

  void openProfilePage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSettingsWidget(objectbox: widget.objectbox,),
        ));

    if(result.runtimeType == bool && result)
    {
      updateInfo();
    }
  }

  Widget workoutPartChart()
  {
    if(pie_data.length == 0)
      return Container();
    return SfCircularChart(
        title: ChartTitle(text: AppLocalizations.of(context)!.dashboard_month_pie_chart_title),
        legend: Legend(isVisible: true),
        series: <PieSeries<_PieData, String>>[
          PieSeries<_PieData, String>(
              explode: true,
              explodeIndex: 0,
              dataSource: pie_data,
              xValueMapper: (_PieData data, _) => data.xData,
              yValueMapper: (_PieData data, _) => data.yData,
              dataLabelMapper: (_PieData data, _) => data.text,
              dataLabelSettings: DataLabelSettings(isVisible: true)),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    if(firstTime)
      {
        firstTime = false;
        updateInfo();
      }

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

                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: ListTile(
                              title: new Row(
                                children: <Widget>[
                                  new Flexible(
                                    child: overviewTable(),
                                  )
                                ],
                              )
                          ),
                        )
                      ),
                      workoutPartChart()
                    ]
                ),
              ),
            ],
          ),
        )
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  final String? text;
}