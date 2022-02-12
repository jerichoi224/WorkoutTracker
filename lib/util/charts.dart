import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:workout_tracker/dbModels/session_item_model.dart';
import 'package:workout_tracker/dbModels/set_item_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:workout_tracker/util/typedef.dart';

class WeightChartData {
  DateTime date = DateTime.now();
  double? maxVal = 0;
  double? avgVal = 0;

  WeightChartData(this.date, this.maxVal, this.avgVal);
}

class speedChartData {
  DateTime date = DateTime.now();
  double? total = 0;
  double? avgSpeed = 0;

  speedChartData(this.date, this.total, this.avgSpeed);
}

class CountChartData {
  DateTime date = DateTime.now();
  double? maxVal = 0;
  double? totalVal = 0;

  CountChartData(this.date, this.maxVal, this.totalVal);
}

Widget speedLineChart(List<SessionItem> sessions, BuildContext context, String metric)
{
  sessions.sort((a, b) => b.time.compareTo(a.time));
  sessions = sessions.reversed.toList();

  List<speedChartData> data= [];

  for(SessionItem sessionItem in sessions)
  {
    double sum = 0;
    double divSum = 0;
    int time = 0;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(sessionItem.time);
    for(SetItem setItem in sessionItem.sets)
    {
      sum += setItem.metricValue;
      if(setItem.countValue != 0)
        divSum += setItem.metricValue;
      time += setItem.countValue;
    }
    if(time == 0)
      data.add(speedChartData(date, sum, null));
    else
      data.add(speedChartData(date, sum, divSum/(time/3600)));
  }

  DateTime prevDay = data.first.date.subtract(Duration(days: 1));
  DateTime nextDay = data.last.date.add(Duration(days: 1));
  data.insert(0, speedChartData(new DateTime(prevDay.year, prevDay.month, prevDay.day), null, null));
  data.add(speedChartData(new DateTime(nextDay.year, nextDay.month, nextDay.day), null, null));

  List<LineSeries<speedChartData, DateTime>> datapoints = [
    LineSeries<speedChartData, DateTime>(
      name: AppLocalizations.of(context)!.workout_total_distance + "(" + metric + ")",
      // Bind data source
      dataSource: data,
      xValueMapper: (speedChartData dataPoint, _) => dataPoint.date,
      yValueMapper: (speedChartData dataPoint, _) => dataPoint.total,
      markerSettings: MarkerSettings(
          isVisible: true,
          height: 4,
          width: 4,
          shape: DataMarkerType.circle,
          borderWidth: 1
      ),
    ),
    LineSeries<speedChartData, DateTime>(
      // Bind data source
      name: AppLocalizations.of(context)!.workout_avg_speed + "(" + metric + "/hr" + ")",
      dataSource:  data,
      xValueMapper: (speedChartData dataPoint, _) => dataPoint.date,
      yValueMapper: (speedChartData dataPoint, _) => dataPoint.avgSpeed,
      markerSettings: MarkerSettings(
          isVisible: true,
          height: 4,
          width: 4,
          shape: DataMarkerType.circle,
          borderWidth: 1
      ),
    )
  ];

  return SfCartesianChart(
    primaryXAxis: DateTimeAxis(
        enableAutoIntervalOnZooming: true
    ),
    legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom
    ),
    margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
    tooltipBehavior: TooltipBehavior( enable: true),
    series: datapoints,
    zoomPanBehavior: ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    ),
  );
}

Widget weightLineChart(List<SessionItem> sessions, BuildContext context, String metric)
{
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

  DateTime prevDay = data.first.date.subtract(Duration(days: 1));
  DateTime nextDay = data.last.date.add(Duration(days: 1));
  data.insert(0, WeightChartData(new DateTime(prevDay.year, prevDay.month, prevDay.day), null, null));
  data.add(WeightChartData(new DateTime(nextDay.year, nextDay.month, nextDay.day), null, null));

  List<LineSeries<WeightChartData, DateTime>> datapoints = [
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

  return SfCartesianChart(
    primaryXAxis: DateTimeAxis(
        enableAutoIntervalOnZooming: true
    ),
    legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom
    ),
    margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
    tooltipBehavior: TooltipBehavior( enable: true),
    series: datapoints,
    zoomPanBehavior: ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    ),
  );
}

Widget countLineChart(List<SessionItem> sessions, BuildContext context, String metric)
{
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
      if(metric == MetricType.duration.name)
        {
          if(max < setItem.countValue)
            max = setItem.countValue.toDouble();
          sum += setItem.countValue;
        }
      else
      {
        if(max < setItem.metricValue)
          max = setItem.metricValue;
        sum += setItem.metricValue;
      }
    }
    data.add(CountChartData(date, max, sum));
  }

  DateTime prevDay = data.first.date.subtract(Duration(days: 1));
  DateTime nextDay = data.last.date.add(Duration(days: 1));
  data.insert(0, CountChartData(new DateTime(prevDay.year, prevDay.month, prevDay.day), null, null));
  data.add(CountChartData(new DateTime(nextDay.year, nextDay.month, nextDay.day), null, null));

  List<LineSeries<CountChartData, DateTime>> datapoints = [
    LineSeries<CountChartData, DateTime>(
      name: AppLocalizations.of(context)!.workout_max_count +
          " (" +
          (metric == MetricType.duration.name ? AppLocalizations.of(context)!.sec : metric) +
          ")",
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
      name: AppLocalizations.of(context)!.workout_total_count + " (" +
          (metric == MetricType.duration.name ? AppLocalizations.of(context)!.sec : metric) +
          ")",
      dataSource:  data,
      xValueMapper: (CountChartData dataPoint, _) => dataPoint.date,
      yValueMapper: (CountChartData dataPoint, _) => dataPoint.totalVal,
      yAxisName: 'totalYAxis',
      markerSettings: MarkerSettings(
          isVisible: true,
          height: 4,
          width: 4,
          shape: DataMarkerType.circle,
          borderWidth: 1
      ),
    )
  ];

  return SfCartesianChart(
    primaryXAxis: DateTimeAxis(
        enableAutoIntervalOnZooming: true
    ),
    axes: <ChartAxis>[
      NumericAxis(
          name: 'totalYAxis',
          opposedPosition: true,
          title: AxisTitle(
          )
      )
    ],
    legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom
    ),
    margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
    tooltipBehavior: TooltipBehavior( enable: true),
    series: datapoints,
    zoomPanBehavior: ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    ),
  );
}