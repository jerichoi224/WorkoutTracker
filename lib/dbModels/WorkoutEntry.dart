import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/dbModels/ColumnNames.dart';
// data model class
class WorkoutEntry {
  int id;
  MetricType metric;
  WorkoutType type;
  PartType part;
  String caption;
  String description;
  String prevSessionJson;

  WorkoutEntry();

  // convenience constructor to create a Word object
  WorkoutEntry.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    caption = map[columnCaption];
    description = map[columnDescription];
    prevSessionJson = map[columnPreviousSessionJson];
    type = WorkoutType.values.firstWhere((e) => e.name == map[columnWorkoutType]);
    part = PartType.values.firstWhere((e) => e.name == map[columnPart]);
    metric = MetricType.values.firstWhere((e) => e.name == map[columnMetric]);
  }

  // convenience method to create a Map from this object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnWorkoutType: type.name,
      columnPart: part.name,
      columnMetric: metric.name,
      columnCaption: caption,
      columnDescription: description,
      columnPreviousSessionJson: prevSessionJson,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "{id: $id, caption: $caption, type: ${type.name}, part: ${part.name}, metric: ${metric.name}, description: $description}";
  }
}
