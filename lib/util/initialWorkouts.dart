
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/typedef.dart';

List<WorkoutEntry> initList = [
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.barbell.name,
      partList: [PartType.chest.name, PartType.tricep.name],
      caption: "Bench Press"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.barbell.name,
      partList: [PartType.chest.name, PartType.tricep.name],
      caption: "Inclined Bench Press"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.dumbbell.name,
      partList: [PartType.tricep.name],
      caption: "Tricep Extension"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.dumbbell.name,
      partList: [PartType.bicep.name],
      caption: "Bicep Curl"
  ),
  WorkoutEntry(
      metric: MetricType.floor.name,
      type: WorkoutType.machine.name,
      partList: [PartType.cardio.name],
      caption: "Stairs"
  ),
  WorkoutEntry(
      metric: MetricType.km.name,
      type: WorkoutType.cardio.name,
      partList: [PartType.cardio.name],
      caption: "Treadmill"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.back.name],
      caption: "Wide Grip Lat-Pulldown"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.back.name],
      caption: "M-Torture Wide Pulldown Rear"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.back.name],
      caption: "T-Row Bar"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.machine.name,
      partList: [PartType.core.name],
      caption: "Knee Raise"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.other.name,
      partList: [PartType.core.name],
      caption: "Ab Wheel"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.dumbbell.name,
      partList: [PartType.shoulder.name],
      caption: "Arnold Press"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.back.name],
      caption: "Back Extension"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.tricep.name],
      caption: "Seated Dips"
  ),
];