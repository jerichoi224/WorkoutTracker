import 'package:flutter/material.dart';
import 'package:workout_tracker/dbModels/session_item_model.dart';
import 'package:workout_tracker/dbModels/set_item_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:workout_tracker/util/StringTool.dart';
import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/widgets/UIComponents.dart';
import 'package:workout_tracker/widgets/Workout/AddEditWorkoutEntryWidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewWorkoutWidget extends StatefulWidget {
  late ObjectBox objectbox;
  late int id;
  ViewWorkoutWidget({Key? key, required this.objectbox, required this.id}) : super(key: key);
  @override
  State createState() => _ViewWorkoutWidget();
}

class _ViewWorkoutWidget extends State<ViewWorkoutWidget> {
  late WorkoutEntry? workoutEntry;
  String locale = "";

  List<SessionItem> sessions = [];

  @override
  void initState() {
    super.initState();
    updateInfo();
    String? temp = widget.objectbox.getPref("locale");
    locale = temp != null ? temp : 'en';

    sessions = widget.objectbox.itemList.where((element) => element.workoutId == workoutEntry!.id).toList();
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
      tagList.add(tag(PartType.values.firstWhere((element) => element.name == workoutEntry!.partList[i]).toLanguageString(locale), (){}, Color.fromRGBO(210, 210, 210, 0.8)));
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

  List<LineSeries<WeightChartData, DateTime>> _createWeightChartData() {
    sessions.sort((a, b) => b.time.compareTo(a.time));
    sessions = sessions.reversed.toList();

    List<WeightChartData> data= [];

    for(SessionItem sessionItem in sessions)
      {
        double max = -1;
        double sum = 0;
        DateTime date = DateTime.fromMillisecondsSinceEpoch(sessionItem.time);
        for(SetItem setItem in sessionItem.sets)
          {
            if(max < setItem.metricValue)
              max = setItem.metricValue;
            sum += setItem.metricValue;
          }
        data.add(WeightChartData(date, max, sum/sessionItem.sets.length));
      }

    data.insert(0, WeightChartData(data[0].date.subtract(Duration(days: 1)), null, null));
    data.add(WeightChartData(data.last.date.add(Duration(days: 1)), null, null));

    return <LineSeries<WeightChartData, DateTime>>[
      LineSeries<WeightChartData, DateTime>(
        name: AppLocalizations.of(context)!.workout_max_weight,
        // Bind data source
          dataSource: data,
          xValueMapper: (WeightChartData dataPoint, _) => dataPoint.date,
          yValueMapper: (WeightChartData dataPoint, _) => dataPoint.maxVal,
          markerSettings: MarkerSettings(
            isVisible: true,
            height: 4,
            width: 4,
            shape: DataMarkerType.circle,
            borderWidth: 1
          ),
      ),
      LineSeries<WeightChartData, DateTime>(
        // Bind data source
          name: AppLocalizations.of(context)!.workout_avg_weight,
          dataSource:  data,
          xValueMapper: (WeightChartData dataPoint, _) => dataPoint.date,
          yValueMapper: (WeightChartData dataPoint, _) => dataPoint.avgVal,
          markerSettings: MarkerSettings(
              isVisible: true,
              height: 4,
              width: 4,
              shape: DataMarkerType.circle,
              borderWidth: 1
          ),
      )
    ];
  }

  List<LineSeries<CountChartData, DateTime>> _createCountChartData() {
    sessions.sort((a, b) => b.time.compareTo(a.time));
    sessions = sessions.reversed.toList();

    List<CountChartData> data= [];
    for(SessionItem sessionItem in sessions)
    {
      double max = -1;
      double sum = 0;
      DateTime date = DateTime.fromMillisecondsSinceEpoch(sessionItem.time);
      for(SetItem setItem in sessionItem.sets)
      {
        if(max < setItem.metricValue)
          max = setItem.metricValue;
        sum += setItem.metricValue;
      }
      data.add(CountChartData(date, max, sum));
    }

    data.insert(0, CountChartData(data[0].date.subtract(Duration(days: 1)), null, null));
    data.add(CountChartData(data.last.date.add(Duration(days: 1)), null, null));

    return <LineSeries<CountChartData, DateTime>>[
      LineSeries<CountChartData, DateTime>(
        name: AppLocalizations.of(context)!.workout_max_count + " (" + workoutEntry!.metric + ")",
        // Bind data source
        dataSource: data,
        xValueMapper: (CountChartData dataPoint, _) => dataPoint.date,
        yValueMapper: (CountChartData dataPoint, _) => dataPoint.maxVal,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 4,
            width: 4,
            shape: DataMarkerType.circle,
            borderWidth: 1
        ),
      ),
      LineSeries<CountChartData, DateTime>(
        // Bind data source
        name: AppLocalizations.of(context)!.workout_total_count + " (" + workoutEntry!.metric + ")",
        dataSource:  data,
        xValueMapper: (CountChartData dataPoint, _) => dataPoint.date,
        yValueMapper: (CountChartData dataPoint, _) => dataPoint.totalVal,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 4,
            width: 4,
            shape: DataMarkerType.circle,
            borderWidth: 1
        ),
      )
    ];
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
                  title: Text(AppLocalizations.of(context)!.workout_details),
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
                                if(workoutEntry!.partList.length > 0)
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 5, 10, 0),
                                    child: Wrap(
                                        alignment: WrapAlignment.start,
                                        children: selectedTagList()
                                    ),
                                  ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text(AppLocalizations.of(context)!.workout_details,
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
                                                Text(AppLocalizations.of(context)!.type),
                                                Spacer(),
                                                Text(workoutEntry!.type.capitalize()),
                                              ],
                                            )
                                        ),
                                        ListTile(
                                            title: new Row(
                                              children: <Widget>[
                                                Text(AppLocalizations.of(context)!.metric),
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
                                      child: Text(AppLocalizations.of(context)!.note,
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
                                if(sessions.length != 0)
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text(AppLocalizations.of(context)!.workout_track_record,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    )
                                  ),
                                if(sessions.length > 0)
                                  if(workoutEntry!.metric == MetricType.kg.name)
                                    Container(
                                      child: SfCartesianChart(
                                          primaryXAxis: DateTimeAxis(
                                              enableAutoIntervalOnZooming: true
                                          ),
                                          legend: Legend(
                                            isVisible: true,
                                            position: LegendPosition.bottom
                                          ),
                                        margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
                                        tooltipBehavior: TooltipBehavior( enable: true),
                                          series: _createWeightChartData(),
                                          zoomPanBehavior: ZoomPanBehavior(
                                            enablePinching: true,
                                            zoomMode: ZoomMode.x,
                                            enablePanning: true,
                                          ),
                                      )
                                    )
                                else if([MetricType.km.name, MetricType.floor.name, MetricType.reps.name].contains(workoutEntry!.metric))
                                    Container(
                                        child: SfCartesianChart(
                                          primaryXAxis: DateTimeAxis(
                                              enableAutoIntervalOnZooming: true
                                          ),
                                          legend: Legend(
                                              isVisible: true,
                                              position: LegendPosition.bottom
                                          ),
                                          margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
                                          tooltipBehavior: TooltipBehavior( enable: true),
                                          series: _createCountChartData(),
                                          zoomPanBehavior: ZoomPanBehavior(
                                            enablePinching: true,
                                            zoomMode: ZoomMode.x,
                                            enablePanning: true,
                                          ),
                                        )
                                    )
                              ],
                            )
                        )
                )
            )
        )
    );
  }
}

class WeightChartData {
  DateTime date = DateTime.now();
  double? maxVal = 0;
  double? avgVal = 0;

  WeightChartData(this.date, this.maxVal, this.avgVal);
}

class CountChartData {
  DateTime date = DateTime.now();
  double? maxVal = 0;
  double? totalVal = 0;

  CountChartData(this.date, this.maxVal, this.totalVal);
}