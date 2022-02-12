import 'package:flutter/material.dart';
import 'package:workout_tracker/class/WorkoutCard.dart';
import 'package:workout_tracker/dbModels/session_entry_model.dart';
import 'package:workout_tracker/dbModels/session_item_model.dart';
import 'package:workout_tracker/dbModels/set_item_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/objectbox.g.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/widgets/Session/AddSessionEntryWidget.dart';
import 'package:workout_tracker/widgets/UIComponents.dart';
import 'package:workout_tracker/util/StringTool.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String locale = "";
  String distMetric = "";
  String weightMetric = "";

  bool modified = false;
  bool firstTime = true;

  TextStyle titleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
      height: 1.5
  );
  TextStyle contentStyle = TextStyle(
      fontSize: 14,
      color: Colors.black87,
      height: 1.5
  );

  @override
  void initState() {
    super.initState();
    String? temp = widget.objectbox.getPref("locale");
    locale = temp != null ? temp : 'en';
    temp = widget.objectbox.getPref("preferred_distance");
    distMetric = temp != null ? temp : 'km';
    temp = widget.objectbox.getPref("preferred_weight");
    weightMetric = temp != null ? temp : 'kg';
  }

  void updateInfo()
  {
    sessionEntry = widget.objectbox.sessionList.firstWhere((element) => element.id == widget.id);
    sessionNameController.text = sessionEntry!.name;
    startTime = sessionEntry!.startTime;
    endTime = sessionEntry!.endTime;
    partList = sessionEntry!.parts;

    timeRange = "";
    int duration = (endTime - startTime)~/60000;
    if(duration > 60)
      timeRange += (duration ~/ 60).toString() + AppLocalizations.of(context)!.hour + " ";
    timeRange += (duration % 60).toString() + " " + AppLocalizations.of(context)!.minute;
    setState(() {});
  }
  // List of Tags in partList
  List<Widget> selectedTagList()
  {
    List<Widget> tagList = [];

    for(int i = 0; i < partList.length; i++)
      tagList.add(tag(PartType.values.firstWhere((element) => element.name == partList[i]).toLanguageString(locale), (){}, Color.fromRGBO(210, 210, 210, 0.8)));

    return tagList;
  }

  void _deleteSession(SessionEntry entry)
  {
    // update list and previous session id for workout entries
    for(SessionItem item in entry.sets)
    {
      WorkoutEntry workoutEntry = widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId);
      widget.objectbox.sessionItemBox.remove(item.id);
      widget.objectbox.itemList.remove(item);

      if(workoutEntry.prevSessionId == item.id)
      {
        List<SessionItem> itemsForWorkout = widget.objectbox.sessionItemBox.query(
            SessionItem_.workoutId.equals(workoutEntry.id)
        ).build().find();

        if(itemsForWorkout.length == 0)
          workoutEntry.prevSessionId = -1;
        else
        {
          itemsForWorkout.sort((a, b) => b.time.compareTo(a.time));
          workoutEntry.prevSessionId = itemsForWorkout[0].id;
        }

        widget.objectbox.workoutBox.put(workoutEntry);
      }
    }

    widget.objectbox.sessionList.remove(entry);
    widget.objectbox.sessionBox.remove(entry.id);
    Navigator.pop(context, true);
  }


  Widget detailsText()
  {
    List<TableRow> detailsInfo = [];
    for(SessionItem item in sessionEntry!.sets)
    {
      WorkoutEntry workoutEntry = widget.objectbox.workoutList.firstWhere((element) => element.id == item.workoutId);
      detailsInfo.add(TableRow(children: [
        Text(workoutEntry.caption,
            textAlign: TextAlign.left,
            style: titleStyle
        ),
      ]));
      for(SetItem set in item.sets)
        {
          String setText = "\t\t\t";
          if(workoutEntry.metric != MetricType.duration.name)
            {
              setText += set.metricValue.toStringRemoveTrailingZero();
              setText += " " + workoutEntry.metric;

              // show num of reps
              if([MetricType.kg.name, MetricType.lb.name].contains(workoutEntry.metric))
                setText += " × " + set.countValue.toString();

              // show time
              if([MetricType.km.name, MetricType.miles.name, MetricType.floor.name].contains(workoutEntry.metric))
                if(set.countValue != 0)
                  {
                    String time = numToTimeText(set.countValue);
                    if(time.substring(0, 1) == "0")
                      time = time.substring(2, time.length);
                    setText += " (" + time + ")";
                  }
            }
          else
          {
            // Duration just shows Time
            String time = numToTimeText(set.countValue);
            if(time.substring(0, 1) == "0")
              time = time.substring(2, time.length);
            setText += time;
          }

          detailsInfo.add(TableRow(children: [
            Text(setText,
                textAlign: TextAlign.left,
                style: contentStyle
            ),
          ]));
        }
    }

    return Table(
      border: TableBorder(),
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
      },
      children: detailsInfo,
    );
  }

  Widget overviewText()
  {
    List<TableRow> overviewInfo = [];

    overviewInfo.add(TableRow(children: [
      Text(AppLocalizations.of(context)!.session_workout_count,
          textAlign: TextAlign.left,
          style: titleStyle

      ),
      Text(sessionEntry!.sets.length.toString(),
          textAlign: TextAlign.left,
          style: contentStyle
      ),
    ]));

    double weight = 0;
    double distance = 0;
    double floors = 0;
    for(SessionItem item in sessionEntry!.sets)
      {
        if([MetricType.kg.name, MetricType.lb.name].contains(item.metric))
          {
            for(SetItem set in item.sets)
              {
                if(weightMetric == MetricType.kg.name && item.metric == MetricType.lb.name)
                  weight += set.countValue * set.metricValue * 0.453592;
                else if(weightMetric == MetricType.lb.name && item.metric == MetricType.kg.name)
                  weight += set.countValue * set.metricValue * 2.20462;
                else
                  weight += set.countValue * set.metricValue;
              }
          }
        else if([MetricType.km.name, MetricType.miles.name].contains(item.metric))
          {
            for(SetItem set in item.sets)
            {
              if(distMetric == MetricType.km.name && item.metric == MetricType.miles.name)
                distance += set.metricValue * 1.60934;
              else if(distMetric == MetricType.miles.name && item.metric == MetricType.km.name)
                distance += set.metricValue * 0.621371;
              else
                distance += set.metricValue;
            }
          }
        else if(item.metric == MetricType.floor.name)
          {
            for(SetItem set in item.sets)
            {
              floors += set.metricValue;
            }
          }
      }

    if(weight != 0)
      overviewInfo.add(TableRow(children: [
        Text(AppLocalizations.of(context)!.session_total_weight,
          textAlign: TextAlign.left,
            style: titleStyle
        ),
        Text(weight.toStringRemoveTrailingZero() + " " + weightMetric,
          textAlign: TextAlign.left,
            style: contentStyle
        ),
      ]));
    if(distance != 0)
      overviewInfo.add(TableRow(children: [
        Text(AppLocalizations.of(context)!.session_total_distance,
            textAlign: TextAlign.left,
            style: titleStyle
        ),
        Text(distance.toStringRemoveTrailingZero() + " " + distMetric,
            textAlign: TextAlign.left,
            style: contentStyle
        ),
      ]));
    if(floors != 0)
      overviewInfo.add(TableRow(children: [
        Text(AppLocalizations.of(context)!.session_stairs,
            textAlign: TextAlign.left,
            style: titleStyle
        ),
        Text(floors.toStringRemoveTrailingZero() + " " + AppLocalizations.of(context)!.floors,
            textAlign: TextAlign.left,
            style: contentStyle
        ),
      ]));

    return Table(
      border: TableBorder(),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(110),
        1: FlexColumnWidth(),
      },
      children: overviewInfo,
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: (){
          _openEditWidget(sessionEntry!);
        },
      ),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _deleteSession(sessionEntry!);
          }
      ),
    ];
  }

  void _openEditWidget(SessionEntry entry) async {
    // start the SecondScreen and wait for it to finish with a   result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddSessionEntryWidget(objectbox: widget.objectbox, fromRoutine: false, edit:true, id:entry.id),
        ));

    if(result.runtimeType == bool && result)
    {
      modified = true;
      updateInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(firstTime)
    {
      firstTime = false;
      updateInfo();
    }

    return WillPopScope(
        onWillPop: () async{
          Navigator.pop(context, modified);
          return true;
        },
        child: new GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: new Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.session_info),
                  actions: _buildActions(),
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
                                          fontSize: 28,
                                          color: Colors.black87
                                      ),
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(sessionEntry!.startTime)) + "\t",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Icon(
                                                Icons.timer,
                                                size: 16,
                                               color: Colors.grey,
                                            ),
                                          ),
                                          TextSpan(
                                            text: timeRange,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey
                                            ),
                                          ),
                                        ],
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
                                    child: Text(AppLocalizations.of(context)!.dashboard_overview,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    )
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    margin: EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                        child: ListTile(
                                              title: new Row(
                                                children: <Widget>[
                                                  new Flexible(
                                                    child: overviewText(),
                                                  )
                                                ],
                                              )
                                          ),
                                    )
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
                                    margin: EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: ListTile(
                                          title: new Row(
                                            children: <Widget>[
                                              new Flexible(
                                                child: detailsText(),
                                              )
                                            ],
                                          )
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