import 'package:fit_tracker/DB/models/workout_tonage.dart';
import 'package:fit_tracker/src/utils/datetime_lang.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    thisMonth = getMonthName(DateTime.now());
    lastDate = getLastDayOfMonth(DateTime.now());
    minValue = workoutData.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    spots = workoutData
        .map((w) => FlSpot(
              format.parse(w.date).day.toDouble(),
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
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.white,
                maxContentWidth: 300,
                fitInsideHorizontally: true,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    int day = touchedSpot.x.toInt();

                    final workout = workoutData.firstWhere(
                      (w) => format.parse(w.date).day == day,
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
