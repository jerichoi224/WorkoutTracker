import 'package:workout_tracker/util/typedef.dart';
import 'package:workout_tracker/dbModels/ColumnNames.dart';

// data model class
class RoutineEntry {
  late int id;
  late String caption;
  late String routineJson;
  /*
  * {
  *   routine: [
  *     {
  *       id: WorkoutId,
  *       numSet: ####
  *       sets:
  *       [
  *         {
  *           metric:     XX,
  *           count:      XX,
  *         },
  *         ...
  *       ]
  *     },
  *     ....
  *   ]
  * }
  * */

  RoutineEntry();

  // convenience constructor to create a Word object
  RoutineEntry.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnId];
    caption = map[columnCaption];
    routineJson = map[columnRoutineJson];
  }

  // convenience method to create a Map from this object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnRoutineJson: routineJson,
      columnCaption: caption
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "{id: $id, caption: $caption, routine: $routineJson}";
  }
}
