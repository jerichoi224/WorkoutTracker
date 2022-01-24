import 'package:objectbox/objectbox.dart';
import 'package:workout_tracker/dbModels/routine_entry_model.dart';
import 'package:workout_tracker/dbModels/session_item_model.dart';

@Entity()
class SetItem {
  int id = 0;
  int metricValue = 0;
  int countValue = 0;

  SetItem({
    required this.metricValue,
    required this.countValue
  });
}