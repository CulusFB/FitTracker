import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/workout.dart';
import 'package:fit_tracker/DB/models/workout_tonage.dart';
import 'package:fit_tracker/src/home/widgets/graphs_month.dart';
import 'package:fit_tracker/src/themes/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key, required this.poolActivityId});
  final int poolActivityId;
  @override
  State<StatisticScreen> createState() => _StatisticsScreen();
}

enum DateRange { week, month, year, all }

class _StatisticsScreen extends State<StatisticScreen>
    with TickerProviderStateMixin {
  late final int poolActivityId;
  dynamic weekWorkouts = [];
  List<Workout> monthWorkouts = [];
  List<Workout> yearWorkouts = [];
  List<WorkoutData> tonnage = [];
  Set<DateRange> selection = {DateRange.month};
  late String poolActivityName;

  @override
  void initState() {
    poolActivityId = widget.poolActivityId;
    poolActivityName = DataManager.instance.getPoolActivityName(poolActivityId);
    getStatistics();
    super.initState();
  }

  dynamic getStatistics() async {
    final dataManager = DataManager.instance;
    weekWorkouts = await dataManager.getPoolActivityWeek(
        poolActivityId); //NOTE Сомнительное решение. Инкапсуляцию отменили угу.
    monthWorkouts = await dataManager
        .getPoolActivityMonth(poolActivityId); //NOTE Сомнительное решение
    yearWorkouts = await dataManager
        .getPoolActivityYear(poolActivityId); //NOTE Сомнительное решение
    tonnage = getTonnage(monthWorkouts);
    setState(() {});
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
  List<WorkoutData> getTonnage(List<Workout> workouts) {
    return workouts.map((workout) {
      double tonnage = workout.approachesList?.fold<double>(
              0, (sum, el) => sum + (el.repetition! * el.weight!)) ??
          0;
      return WorkoutData(workout.date.toString(), tonnage);
    }).toList();
  }

  String maxTonnage(List<WorkoutData> workouts) {
    double max = 0;
    for (var workout in workouts) {
      if (workout.tonnage > max) {
        max = workout.tonnage;
      }
    }
    return max.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                poolActivityName,
                style: TextRepetitionWeightTheme(),
              ),
            ),
            Center(
              child: SegmentedButton(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<DateRange>>[
                    ButtonSegment(value: DateRange.week, label: Text("Неделя")),
                    ButtonSegment(value: DateRange.month, label: Text("Месяц")),
                    ButtonSegment(value: DateRange.year, label: Text("Год")),
                    ButtonSegment(value: DateRange.all, label: Text("Всё"))
                  ],
                  onSelectionChanged: (Set<DateRange> newSelection) {
                    setState(() {
                      if (newSelection.first == DateRange.month) {
                        tonnage = getTonnage(monthWorkouts);
                      }
                      selection = newSelection;
                    });
                  },
                  selected: selection),
            ),
            Row(
              spacing: 10,
              children: [
                Text("Тоннаж",
                    style: GoogleFonts.roboto(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text("max ${maxTonnage(tonnage)}",
                    style: GoogleFonts.roboto(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            Expanded(
              child: monthWorkouts.isNotEmpty
                  ? GraphsMonth(workoutData: tonnage)
                  : SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
