import 'package:fit_tracker/DB/DataManager.dart';
import 'package:fit_tracker/DB/models/Workout.dart';
import 'package:fit_tracker/src/home/widgets/GraphsMonth.dart';
import 'package:fit_tracker/src/themes/TextStyleTheme.dart';
import 'package:flutter/material.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key, required this.poolActivityId});
  final int poolActivityId;
  @override
  State<StatisticScreen> createState() => _StatisticsScreen(poolActivityId: poolActivityId);
}

enum DateRange { week, month, year, all }

class _StatisticsScreen extends State<StatisticScreen> with TickerProviderStateMixin {
  _StatisticsScreen({required this.poolActivityId});
  final int poolActivityId;
  dynamic weekWorkouts = [];
  dynamic monthWorkouts = [];
  List<Workout> yearWorkouts = [];
  Set<DateRange> selection = {DateRange.month};
  late String poolActivityName;
  
  @override
  void initState() {
    poolActivityName = DataManager.instance.getPoolActivityName(poolActivityId);
    getStatistics();
    super.initState();
  }

  dynamic getStatistics() async {
    final dataManager = DataManager.instance;
    weekWorkouts = await dataManager.getPoolActivityWeek(poolActivityId); //NOTE Сомнительное решение. Инкапсуляцию отменили угу.
    monthWorkouts = await dataManager.getPoolActivityMonth(poolActivityId); //NOTE Сомнительное решение
    yearWorkouts = await dataManager.getPoolActivityYear(poolActivityId); //NOTE Сомнительное решение
    setState(() {});
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      selection = newSelection;
                    });
                  },
                  selected: selection),
            ),
            Expanded(
              child: monthWorkouts.isNotEmpty
                  ? GraphsMonth(monthWorkouts: monthWorkouts)
                  : SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
