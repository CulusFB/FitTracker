import 'package:fit_tracker/DB/models/workout_tonage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class GraphsWeek extends StatefulWidget {
  const GraphsWeek({super.key, required this.workoutData});
  final List<WorkoutData> workoutData;
  @override
  State<GraphsWeek> createState() => _GraphsWeek();
}

class _GraphsWeek extends State<GraphsWeek> {
  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  late List<WorkoutData> workoutData;
  late final String thisMonth;
  late final int lastDate;
  late final List<FlSpot> spots;
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];
  late final double minValue;
  late final double maxValue;
  @override
  void initState() {
    super.initState();

    final start = startOfWeek(DateTime.now());
    final original = widget.workoutData;

    final normalized = <WorkoutData>[];

    for (int i = 1; i <= 7; i++) {
      final existing = original.where(
        (el) => format.parse(el.date).weekday == i,
      );

      if (existing.isNotEmpty) {
        normalized.add(existing.first);
      } else {
        final date = start.add(Duration(days: i - 1));
        normalized.add(
          WorkoutData(date.toString(), 0),
        );
      }
    }

    workoutData = normalized;
    minValue = workoutData.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    maxValue = workoutData.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    spots = workoutData
        .map((w) => FlSpot(
              format.parse(w.date).weekday.toDouble(),
              w.value,
            ))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }

  DateTime startOfWeek(DateTime now) {
    return now.subtract(Duration(days: now.weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
          minY: minValue != 0 ? minValue * 0.9 : -maxValue * 0.1,
          maxY: workoutData.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.1,
          titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                interval: 1,
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 1:
                      return const Text('ПН');
                    case 2:
                      return const Text('ВТ');
                    case 3:
                      return const Text('СР');
                    case 4:
                      return const Text('ЧТ');
                    case 5:
                      return const Text('ПТ');
                    case 6:
                      return const Text('СБ');
                    case 7:
                      return const Text('ВС');
                    default:
                      return const Text('');
                  }
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
