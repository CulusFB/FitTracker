import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/muscle_group.dart';
import 'package:fit_tracker/src/home/widgets/tile_list_activity_select.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectMuscleGroupScreen extends StatefulWidget {
  const SelectMuscleGroupScreen({super.key});
  @override
  State<SelectMuscleGroupScreen> createState() => _SelectMuscleGroupScreen();
}

class _SelectMuscleGroupScreen extends State<SelectMuscleGroupScreen>
    with TickerProviderStateMixin {
  List<MuscleGroup> poolMuscleGroup = DataManager().muscleGroups;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  'Новое упражнение',
                  style: GoogleFonts.roboto(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton.filled(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
            alignment: Alignment.topLeft,
            child: Text(
              'Выберите группу мышц',
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: poolMuscleGroup
                    .map((muscleGroup) => TileListActivitySelect(
                          muscleGroup: muscleGroup,
                        ))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
