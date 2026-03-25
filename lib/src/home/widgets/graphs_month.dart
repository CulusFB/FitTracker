import 'package:fit_tracker/DB/models/workout_tonage.dart';
import 'package:fit_tracker/src/utils/datetime_lang.dart';
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
  late final String thisMonth;
  late final int lastDate;
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];
  @override
  void initState() {
    super.initState();
    workoutData = widget.workoutData;
    thisMonth = getMonthName(DateTime.now());
    lastDate = getLastDayOfMonth(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                reservedSize: 40,
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    space: 8,
                    fitInside: SideTitleFitInsideData(
                      enabled: true,
                      axisPosition: meta.axisPosition,
                      parentAxisSize: meta.parentAxisSize,
                      distanceFromEdge: 8,
                    ),
                    child: Text(
                      value == 1
                          ? '1 $thisMonth'
                          : value == 25
                              ? '$lastDate $thisMonth'
                              : '',
                      textAlign: TextAlign.center,
                    ),
                  );
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
                      format.parse(workout.date).day.toDouble(), workout.value))
                  .cast<FlSpot>()
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.35,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              barWidth: 2,
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
          ],
          //TODO: Сделать вывод при нажатию на точку на графике
          lineTouchData: LineTouchData(enabled: true)),
      curve: Curves.linear,
      duration: Duration(milliseconds: 150),
    );
  }
}
