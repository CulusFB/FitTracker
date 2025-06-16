import 'package:fit_tracker/DB/DataManager.dart';
import 'package:fit_tracker/DB/models/Workout.dart';
import 'package:fit_tracker/src/home/widgets/GraphsMonth.dart';
import 'package:fit_tracker/src/home/widgets/GraphsWeek.dart';
import 'package:fit_tracker/src/themes/TextStyleTheme.dart';
import 'package:flutter/material.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key, required this.poolActivityId});
  final int poolActivityId;
  @override
  State<StatisticScreen> createState() =>
      _StatisticsScreen(poolActivityId: poolActivityId);
}

enum dateRange { week, month, year, all }

class _StatisticsScreen extends State<StatisticScreen>
    with TickerProviderStateMixin {
  _StatisticsScreen({required this.poolActivityId});
  final int poolActivityId;
  dynamic weekWorkouts = [];
  dynamic monthWorkouts = [];
  List<Workout> yearWorkouts = [];
  Set<dateRange> selection = {dateRange.month};
  late String poolActivityName;
  @override
  void initState() {
    poolActivityName = DataManager.instance.getPoolActivityName(poolActivityId);
    getStatistics();
    super.initState();
  }

  getStatistics() async {
    weekWorkouts =
        await DataManager.instance.getPoolActivityWeek(poolActivityId);
    monthWorkouts =
        await DataManager.instance.getPoolActivityMonth(poolActivityId);
    yearWorkouts =
        await DataManager.instance.getPoolActivityYear(poolActivityId);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                  segments: const <ButtonSegment<dateRange>>[
                    ButtonSegment(value: dateRange.week, label: Text("Неделя")),
                    ButtonSegment(value: dateRange.month, label: Text("Месяц")),
                    ButtonSegment(value: dateRange.year, label: Text("Год")),
                    ButtonSegment(value: dateRange.all, label: Text("Всё"))
                  ],
                  onSelectionChanged: (Set<dateRange> newSelection) {
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
