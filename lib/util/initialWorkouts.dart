
import 'package:workout_tracker/dbModels/workout_entry_model.dart';
import 'package:workout_tracker/util/typedef.dart';

List<WorkoutEntry> initList = [
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
      caption: "Assisted Pull Up"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.back.name],
      caption: "Back Extension"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.barbell.name,
      partList: [PartType.chest.name, PartType.tricep.name],
      caption: "Bench Press"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.dumbbell.name,
      partList: [PartType.bicep.name],
      caption: "Bicep Curl"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.other.name,
      partList: [PartType.core.name],
      caption: "Bicycle Crunch"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.other.name,
      partList: [PartType.core.name],
      caption: "Burpee"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.other.name,
      partList: [PartType.back.name],
      caption: "Chin Up"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.other.name,
      partList: [PartType.core.name],
      caption: "Crunch"
  ),
  WorkoutEntry(
      metric: MetricType.km.name,
      type: WorkoutType.cardio.name,
      partList: [PartType.cardio.name],
      caption: "Cycling"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.barbell.name,
      partList: [PartType.leg.name, PartType.back.name],
      caption: "Deadlift"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.barbell.name,
      partList: [PartType.chest.name],
      caption: "Decline Bench Press"
  ),
  WorkoutEntry(
      metric: MetricType.duration.name,
      type: WorkoutType.cardio.name,
      partList: [PartType.cardio.name],
      caption: "Elliptical Machine"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.other.name,
      partList: [PartType.core.name],
      caption: "Flat Knee Raise"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.other.name,
      partList: [PartType.core.name],
      caption: "Flat Leg Raise"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.dumbbell.name,
      partList: [PartType.shoulder.name],
      caption: "Front Raise"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.dumbbell.name,
      partList: [PartType.bicep.name],
      caption: "Hammer Curl"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.other.name,
      partList: [PartType.core.name],
      caption: "Hanging Knee Raise"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.other.name,
      partList: [PartType.core.name],
      caption: "Hanging Leg Raise"
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
      partList: [PartType.bicep.name],
      caption: "Incline Curl"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.chest.name],
      caption: "Iso-Lateral Chest Press"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.cardio.name,
      partList: [PartType.cardio.name],
      caption: "Jump Rope"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.machine.name,
      partList: [PartType.core.name],
      caption: "Knee Raise"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.back.name],
      caption: "Lat Pulldown"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.shoulder.name],
      caption: "Lateral Raise"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.leg.name],
      caption: "Leg Extension"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.leg.name],
      caption: "Leg Press"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.leg.name],
      caption: "Leg Curl"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.back.name],
      caption: "M-Torture Wide Pulldown Rear"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.dumbbell.name,
      partList: [PartType.shoulder.name],
      caption: "Overhead Press"
  ),
  WorkoutEntry(
      metric: MetricType.duration.name,
      type: WorkoutType.other.name,
      partList: [PartType.core.name],
      caption: "Plank"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.machine.name,
      partList: [PartType.back.name],
      caption: "Pull Up"
  ),
  WorkoutEntry(
      metric: MetricType.reps.name,
      type: WorkoutType.other.name,
      partList: [PartType.chest.name],
      caption: "Push Up"
  ),
  WorkoutEntry(
      metric: MetricType.km.name,
      type: WorkoutType.cardio.name,
      partList: [PartType.cardio.name],
      caption: "Running (Treadmill)"
  ),
  WorkoutEntry(
      metric: MetricType.km.name,
      type: WorkoutType.cardio.name,
      partList: [PartType.cardio.name],
      caption: "Running"
  ),
  WorkoutEntry(
      metric: MetricType.floor.name,
      type: WorkoutType.machine.name,
      partList: [PartType.cardio.name],
      caption: "Stairs"
  ),
  WorkoutEntry(
      metric: MetricType.duration.name,
      type: WorkoutType.other.name,
      partList: [PartType.core.name],
      caption: "Side Plank"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.leg.name],
      caption: "Squat"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.tricep.name],
      caption: "Seated Dips"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.dumbbell.name,
      partList: [PartType.tricep.name],
      caption: "Triceps Extension"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.back.name],
      caption: "T-Row Bar"
  ),
  WorkoutEntry(
      metric: MetricType.kg.name,
      type: WorkoutType.machine.name,
      partList: [PartType.back.name],
      caption: "Wide Grip Lat-Pulldown"
  ),
];