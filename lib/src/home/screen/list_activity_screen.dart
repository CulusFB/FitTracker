import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/muscle_group.dart';
import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/screen/select_muscle_group_screen.dart';
import 'package:fit_tracker/src/home/widgets/tile_list_activity.dart';
import 'package:fit_tracker/src/themes/filled_button_theme.dart';
import 'package:flutter/material.dart';

class ListActivityScreen extends StatefulWidget {
  const ListActivityScreen({super.key});
  @override
  State<ListActivityScreen> createState() => _ListActivityScreen();
}

class _ListActivityScreen extends State<ListActivityScreen>
    with TickerProviderStateMixin {
  List<MuscleGroup> poolMuscleGroup = DataManager.instance.muscleGroups;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: FilledButton(
                style: FilledButtonStyle(),
                onPressed: () {
                  showModalBottomSheet(
                      useSafeArea: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return SelectMuscleGroupScreen();
                      }).whenComplete(() {
                    poolMuscleGroup = DataManager.instance.muscleGroups;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).create_exercise),
                      Icon(Icons.add)
                    ],
                  ),
                )),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: poolMuscleGroup
                    .map((muscleGroup) => TileListActivity(
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
