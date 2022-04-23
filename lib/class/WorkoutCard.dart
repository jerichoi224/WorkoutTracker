// Class used in Routines. A Single Class is a Single Workout Entry in a routine.
import 'package:flutter/widgets.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/StringTool.dart';
import 'package:workout_tracker/util/typedef.dart';

class WorkoutCard {
  int id = 0;
  late WorkoutEntry entry;
  int numSets = 0;
  List<double> metricList = [];
  List<int> countList = [];
  List<TextEditingController> metricController = [];
  List<TextEditingController> countController = [];

  WorkoutCard(WorkoutEntry workoutEntry, int id)
  {
    this.id = id;
    entry = workoutEntry;
  }

  void addSet(double metric, int count, [double prev_metric =-1, int prev_count = -1])
  {
    if(metric == -1 && prev_metric != -1)
      metric = prev_metric;
    if(count == -1 && prev_count != -1)
      count = prev_count;

    numSets += 1;
    metricList.add(metric);
    countList.add(count);
    TextEditingController metricTextController = new TextEditingController();
    TextEditingController countTextController = new TextEditingController();
    if(metric != -1)
        metricTextController.text  = metric.toStringRemoveTrailingZero();

    if(count != -1)
      countTextController.text  = count.toString();

    if([MetricType.km.name, MetricType.miles.name, MetricType.duration.name, MetricType.floor.name].contains(entry.metric))
      {
        if(count == -1)
          countTextController.text = "0:00:00";
        else
          countTextController.text = numToTimeText(count);
      }
    metricController.add(metricTextController);
    countController.add(countTextController);
  }

  void remove(int ind)
  {
    numSets -= 1;
    metricList.removeAt(ind);
    countList.removeAt(ind);
    metricController.removeAt(ind);
    countController.removeAt(ind);
  }
}