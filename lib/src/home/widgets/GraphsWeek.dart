import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraphsWeek extends StatefulWidget {
  const GraphsWeek({super.key, required this.weekWorkouts});
  final weekWorkouts;
  @override
  State<GraphsWeek> createState() => _GraphsWeek(weekWorkouts: weekWorkouts);
}

class _GraphsWeek extends State<GraphsWeek> {
  _GraphsWeek({required this.weekWorkouts});
  final weekWorkouts;
  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            Widget text;
            switch (value.toInt()) {
              case 1:
                text = const Text('ПН');
                break;
              case 2:
                text = const Text('ВТ');
                break;
              case 3:
                text = const Text('СР');
                break;
              case 4:
                text = const Text('ЧТ');
              case 5:
                text = const Text('ПТ');
                break;
              case 6:
                text = const Text('СБ');
                break;
              case 7:
                text = const Text('ВС');
                break;
              default:
                text = const Text('');
                break;
            }
            return text;
          },
        ))),
        lineBarsData: [
          LineChartBarData(
              spots: weekWorkouts
                  .map((workout) => FlSpot(
                      format.parse(workout.Date as String).weekday.toDouble(),
                      workout.List_approaches?.last.weight as double))
                  .cast<FlSpot>()
                  .toList())
        ]));
  }
}
