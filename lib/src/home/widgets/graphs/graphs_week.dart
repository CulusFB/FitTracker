import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraphsWeek extends StatefulWidget {
  const GraphsWeek({super.key, required this.weekWorkouts});
  final dynamic weekWorkouts;
  @override
  State<GraphsWeek> createState() => _GraphsWeek();
}

class _GraphsWeek extends State<GraphsWeek> {
  late final dynamic weekWorkouts;
  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  @override
  void initState() {
    super.initState();
    weekWorkouts = widget.weekWorkouts;
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
              case 1: return const Text('ПН');
              case 2: return const Text('ВТ');
              case 3: return const Text('СР');
              case 4: return const Text('ЧТ');    
              case 5: return const Text('ПТ');
              case 6: return const Text('СБ');
              case 7: return const Text('ВС');
              default: return const Text('');
            }
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
