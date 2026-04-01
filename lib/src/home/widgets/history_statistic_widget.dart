import 'package:fit_tracker/DB/models/workout.dart';
import 'package:fit_tracker/src/utils/datetime_lang.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryStatisticWidget extends StatefulWidget {
  const HistoryStatisticWidget({super.key, required this.workouts});
  final List<Workout> workouts;
  @override
  State<HistoryStatisticWidget> createState() => _HistoryStatisticWidget();
}

class _HistoryStatisticWidget extends State<HistoryStatisticWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          ...widget.workouts.map(
            (e) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  getDayMonth(e.date.toString()),
                  style: GoogleFonts.roboto(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                ),
                ...e.approachesList?.map((el) =>
                        Text("${el.weight} x ${el.repetition}", style: GoogleFonts.roboto())) ??
                    []
              ],
            ),
          )
        ],
      ),
    );
  }
}
