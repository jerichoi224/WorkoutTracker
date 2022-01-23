import 'package:objectbox/objectbox.dart';
import 'package:workout_tracker/dbModels/session_item_model.dart';
import 'package:workout_tracker/util/typedef.dart';

@Entity()
class WorkoutEntry {
  int id = 0;
  String metric = MetricType.kg.name;
  String type = WorkoutType.other.name;
  String part = PartType.other.name;
  String caption = "";
  String description = "";
  final prevSession = ToOne<SessionItem>();

  WorkoutEntry();
}