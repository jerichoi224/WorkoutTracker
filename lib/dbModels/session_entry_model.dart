import 'package:objectbox/objectbox.dart';
import 'package:workout_tracker/dbModels/session_item_model.dart';

@Entity()
class SessionEntry {
  int id = 0;
  String name = "";
  List<String> parts = [];
  int startTime = 0;
  int endTime = 0;
  int year = 0;
  int month = 0;
  int day = 0;
  String description = "";
  final sets = ToMany<SessionItem>();
}