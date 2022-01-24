import 'package:objectbox/objectbox.dart';
import 'package:workout_tracker/dbModels/set_item_model.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';

@Entity()
class SessionItem {
  int id = 0;
  int time = 0;

  final sets = ToMany<SetItem>();
}