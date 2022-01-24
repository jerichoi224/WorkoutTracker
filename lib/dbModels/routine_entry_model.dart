import 'package:objectbox/objectbox.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';

@Entity()
class RoutineEntry {
  int id = 0;
  String name = "";
  List<String> parts = [];
  String description = "";
  final workoutList = ToMany<WorkoutEntry>();
}