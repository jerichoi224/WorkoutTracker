import 'package:objectbox/objectbox.dart';
import 'package:workout_tracker/util/typedef.dart';

@Entity()
class WorkoutEntry {
  int id = 0;
  String metric = MetricType.kg.name;
  String type = WorkoutType.other.name;
  List<String> partList = [];
  String caption = "";
  String description = "";
  int prevSessionId = 0;
  bool visible = true;

  WorkoutEntry();
}