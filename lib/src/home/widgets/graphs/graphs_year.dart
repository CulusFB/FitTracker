import 'package:fit_tracker/DB/models/workout_tonage.dart';
import 'package:fit_tracker/src/utils/datetime_lang.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class GraphsYear extends StatefulWidget {
  const GraphsYear({super.key, required this.workoutData});
  final List<WorkoutData> workoutData;
  @override
  State<GraphsYear> createState() => _GraphsAll();
}

class _GraphsAll extends State<GraphsYear> {
  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  late final List<WorkoutData> workoutData;
  late final int thisYear;
  late final String firstMonth;
  late final int firstYear;
  late final String lastMonth;
  late final int lastYear;
  late final List<FlSpot> spots;
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];
  late final double minValue;
  @override
  void initState() {
    super.initState();
    workoutData = widget.workoutData;
    var firstDate = format.parse(workoutData.first.date);
    var lastDate = format.parse(workoutData.last.date);
    firstMonth = getMonthName(firstDate);
    firstYear = firstDate.year;
    lastMonth = getMonthName(lastDate);
    lastYear = lastDate.year;
    minValue = workoutData.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    spots = workoutData
        .map((w) => FlSpot(
              dayOfYear(format.parse(w.date)).toDouble(),
              w.value,
            ))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
          minY: minValue * 0.9,
          maxY: workoutData.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.1,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 1000,
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
                      value == dayOfYear(format.parse(workoutData.first.date)).toDouble()
                          ? "$firstMonth $firstYear"
                          : value > 1
                              ? "$lastMonth $lastYear"
                              : "",
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              )),
              topTitles: AxisTitles(),
              leftTitles: AxisTitles(),
              rightTitles: AxisTitles()),
          gridData: FlGridData(
              drawVerticalLine: false,
              drawHorizontalLine: false,
              horizontalInterval: 1,
              verticalInterval: 1),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.15,
              preventCurveOverShooting: true,
              preventCurveOvershootingThreshold: 10,
              barWidth: 3,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors.map((color) => color.withValues(alpha: 0.3)).toList(),
                ),
              ),
            )
          ],
          lineTouchData: LineTouchData(
              touchSpotThreshold: 100,
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.white,
                maxContentWidth: 300,
                fitInsideHorizontally: true,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    int day = touchedSpot.x.toInt();

                    final workout = workoutData.firstWhere(
                      (w) => dayOfYear(format.parse(w.date)) == day,
                      orElse: () => WorkoutData('', 0),
                    );

                    String dateText = workout.date.isNotEmpty
                        ? DateFormat('dd MMM yyyy').format(format.parse(workout.date))
                        : '';

                    return LineTooltipItem('${touchedSpot.y.toStringAsFixed(1)}  ',
                        GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: dateText,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.normal, color: Colors.grey[600]),
                          ),
                        ]);
                  }).toList();
                },
              ))),
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 150),
    );
  }
}
