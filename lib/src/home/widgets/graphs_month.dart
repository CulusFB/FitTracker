import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraphsMonth extends StatefulWidget {
  const GraphsMonth({super.key, required this.monthWorkouts});
  final dynamic monthWorkouts;
  @override
  State<GraphsMonth> createState() => _GraphsMonth();
}

class _GraphsMonth extends State<GraphsMonth> {
  late final dynamic monthWorkouts;
  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  
  @override
  void initState() {
    super.initState();
    monthWorkouts = widget.monthWorkouts;
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            switch (value.toInt()) {
              case 1: return const Text('Январь');
              case 2: return const Text('Февраль');
              case 3: return const Text('Март');
              case 4: return const Text('Апрель');
              case 5: return const Text('Май');
              case 6: return const Text('Июнь');
              case 7: return const Text('Июль');
              case 8: return const Text('Август');
              case 9: return const Text('Сентябрь');
              case 10: return const Text('Октябрь');
              case 11: return const Text('Ноябрь');
              case 12: return const Text('Декабрь');
              default:
                return const Text('');
            }
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
