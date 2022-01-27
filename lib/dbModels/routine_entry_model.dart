import 'package:objectbox/objectbox.dart';

@Entity()
class RoutineEntry {
  int id = 0;
  String name = "";
  List<String> parts = [];
  String description = "";
  List<String> workoutIds = [];
}