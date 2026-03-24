import 'package:fit_tracker/DB/models/workout_tonage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraphsMonth extends StatefulWidget {
  const GraphsMonth({super.key, required this.workoutData});
  final List<WorkoutData> workoutData;
  @override
  State<GraphsMonth> createState() => _GraphsMonth();
}

class _GraphsMonth extends State<GraphsMonth> {
  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  late final List<WorkoutData> workoutData;
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];
  @override
  void initState() {
    super.initState();
    workoutData = widget.workoutData;
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
          titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 1:
                      return const Text('1');
                    case 30:
                      return const Text('Декабрь');
                    default:
                      return const Text('');
                  }
                },
              )),
              topTitles: AxisTitles(),
              leftTitles: AxisTitles(),
              rightTitles: AxisTitles()),
          gridData:
              FlGridData(drawVerticalLine: false, drawHorizontalLine: false),
          lineBarsData: [
            LineChartBarData(
              spots: workoutData
                  .map((workout) => FlSpot(
                      format.parse(workout.value).day.toDouble(),
                      workout.tonnage))
                  .cast<FlSpot>()
                  .toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withValues(alpha: 0.3))
                      .toList(),
                ),
              ),
            )
          ]),
      curve: Curves.linear,
      duration: Duration(milliseconds: 150),
    );
  }
}
