import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/workout.dart';
import 'package:fit_tracker/src/home/widgets/graphs/graphs_all.dart';
import 'package:fit_tracker/src/home/widgets/graphs/graphs_month.dart';
import 'package:fit_tracker/src/home/widgets/graphs/graphs_week.dart';
import 'package:fit_tracker/src/home/widgets/graphs/graphs_year.dart';
import 'package:fit_tracker/src/themes/text_style_theme.dart';
import 'package:fit_tracker/src/utils/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key, required this.poolActivityId});
  final int poolActivityId;
  @override
  State<StatisticScreen> createState() => _StatisticsScreen();
}

enum DateRange { week, month, year, all }

class _StatisticsScreen extends State<StatisticScreen> with TickerProviderStateMixin {
  late final int poolActivityId;
  dynamic weekWorkouts = [];
  List<Workout> monthWorkouts = [];
  List<Workout> yearWorkouts = [];
  List<Workout> allWorkouts = [];
  late TonnageWeightChartData tonnage;
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
    monthWorkouts =
        await dataManager.getPoolActivityMonth(poolActivityId); //NOTE Сомнительное решение
    yearWorkouts =
        await dataManager.getPoolActivityYear(poolActivityId); //NOTE Сомнительное решение
    allWorkouts = await dataManager.getPoolActivityAll(poolActivityId);
    tonnage = TonnageWeightChartData(workouts: monthWorkouts);
    setState(() {});
  }

  Widget getWeightGraph(DateRange period) {
    switch (period) {
      case DateRange.month:
        return GraphsMonth(workoutData: tonnage.getWeight());
      case DateRange.year:
        return GraphsYear(workoutData: tonnage.getWeight());
      case DateRange.all:
        return GraphsAll(workoutData: tonnage.getWeight());
      case DateRange.week:
        return GraphsWeek(workoutData: tonnage.getWeight());
    }
  }

  Widget getTonnageGraph(DateRange period) {
    switch (period) {
      case DateRange.month:
        return GraphsMonth(workoutData: tonnage.getTonnage());
      case DateRange.year:
        return GraphsYear(workoutData: tonnage.getTonnage());
      case DateRange.all:
        return GraphsAll(workoutData: tonnage.getTonnage());
      case DateRange.week:
        return GraphsWeek(workoutData: tonnage.getTonnage());
    }
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
                        tonnage = TonnageWeightChartData(workouts: monthWorkouts);
                      }
                      if (newSelection.first == DateRange.year) {
                        tonnage = TonnageWeightChartData(workouts: yearWorkouts);
                      }
                      if (newSelection.first == DateRange.week) {
                        tonnage = TonnageWeightChartData(workouts: weekWorkouts);
                      }
                      if (newSelection.first == DateRange.all) {
                        tonnage = TonnageWeightChartData(workouts: allWorkouts);
                        print(tonnage.getWeight().first.date);
                      }
                      selection = newSelection;
                    });
                  },
                  selected: selection),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: monthWorkouts.isNotEmpty
                    ? Column(
                        spacing: 10,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Text("Вес",
                                  style: GoogleFonts.roboto(
                                      fontSize: 22, fontWeight: FontWeight.bold)),
                              Text("max ${tonnage.maxWeight()}",
                                  style: GoogleFonts.roboto(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  )),
                            ],
                          ),
                          SizedBox(height: 250, child: getWeightGraph(selection.first)),
                          Row(
                            spacing: 10,
                            children: [
                              Text("Тоннаж",
                                  style: GoogleFonts.roboto(
                                      fontSize: 22, fontWeight: FontWeight.bold)),
                              Text("max ${tonnage.maxTonnage()}",
                                  style: GoogleFonts.roboto(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600])),
                            ],
                          ),
                          SizedBox(height: 250, child: getTonnageGraph(selection.first)),
                          Align(
                            alignment: AlignmentGeometry.centerLeft,
                            child: Text("История",
                                style:
                                    GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
