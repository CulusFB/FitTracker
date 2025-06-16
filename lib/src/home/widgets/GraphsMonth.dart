import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraphsMonth extends StatefulWidget {
  const GraphsMonth({super.key, required this.monthWorkouts});
  final monthWorkouts;
  @override
  State<GraphsMonth> createState() =>
      _GraphsMonth(monthWorkouts: monthWorkouts);
}

class _GraphsMonth extends State<GraphsMonth> {
  _GraphsMonth({required this.monthWorkouts});
  final monthWorkouts;
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
                text = const Text('Январь');
                break;
              case 2:
                text = const Text('Февраль');
                break;
              case 3:
                text = const Text('Март');
                break;
              case 4:
                text = const Text('Апрель');
              case 5:
                text = const Text('Май');
                break;
              case 6:
                text = const Text('Июнь');
                break;
              case 7:
                text = const Text('Июль');
                break;
              case 8:
                text = const Text('Август');
                break;
              case 9:
                text = const Text('Сентябрь');
                break;
              case 10:
                text = const Text('Октябрь');
                break;
              case 11:
                text = const Text('Ноябрь');
                break;
              case 12:
                text = const Text('Декабрь');
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
              spots: monthWorkouts
                  .map((workout) => FlSpot(
                      format.parse(workout.Date as String).month.toDouble(),
                      workout.List_approaches?.last.weight as double))
                  .cast<FlSpot>()
                  .toList())
        ]));
  }
}
