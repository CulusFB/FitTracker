import 'package:fit_tracker/DB/models/workout.dart';
import 'package:fit_tracker/DB/models/workout_tonage.dart';

class TonnageWeightChartData {
  final List<Workout> workouts;

  TonnageWeightChartData({required this.workouts});
  List<WorkoutData> getTonnage() {
    return workouts.map((workout) {
      double tonnage = workout.approachesList?.fold<double>(
              0, (sum, el) => sum + (el.repetition! * el.weight!)) ??
          0;
      return WorkoutData(workout.date.toString(), tonnage);
    }).toList();
  }

  List<WorkoutData> getWeight() {
    return workouts.map((workout) {
      double weight = (workout.approachesList ?? []).fold<double>(
        0,
        (max, el) => (el.weight ?? 0) > max ? (el.weight ?? 0) : max,
      );
      return WorkoutData(workout.date.toString(), weight);
    }).toList();
  }

  String _getMax(List<WorkoutData> workouts) {
    double max = 0;
    for (var workout in workouts) {
      if (workout.value > max) {
        max = workout.value;
      }
    }
    return max.toString();
  }

  String maxTonnage() {
    return _getMax(getTonnage());
  }

  String maxWeight() {
    return _getMax(getWeight());
  }
}
