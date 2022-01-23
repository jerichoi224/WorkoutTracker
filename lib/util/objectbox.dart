import 'package:workout_tracker/objectbox.g.dart';
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/dbModels/routine_entry_model.dart';
// https://github.com/objectbox/objectbox-dart/blob/main/objectbox/example/flutter/objectbox_demo/lib/objectbox.dart
/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  /// The Store of this app.
  late final Store store;

  late final Box<WorkoutEntry> workoutBox;
  late final Box<RoutineEntry> routineBox;

  ObjectBox._create(this.store) {
    workoutBox = Box<WorkoutEntry>(store);
    routineBox = Box<RoutineEntry>(store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }
}