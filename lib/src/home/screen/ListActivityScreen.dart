import 'package:fit_tracker/DB/crud/muscleGroup_crud.dart';
import 'package:fit_tracker/DB/models/muscleGroup.dart';
import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/widgets/TileListActivity.dart';
import 'package:fit_tracker/src/themes/FilledButtonTheme.dart';
import 'package:flutter/material.dart';

class ListActivityScreen extends StatefulWidget {
  const ListActivityScreen({super.key});
  @override
  State<ListActivityScreen> createState() => _ListActivityScreen();
}

class _ListActivityScreen extends State<ListActivityScreen>
    with TickerProviderStateMixin {
  List<MuscleGroup> poolMuscleGroup = [];
  @override
  void initState() {
    super.initState();
    _asyncGetActivityList();
  }

  _asyncGetActivityList() async {
    poolMuscleGroup = await getAllMuscleGroup();
    setState(() {});
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
                onPressed: () {},
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
          SingleChildScrollView(
            child: Column(
              children: poolMuscleGroup
                  .map((muscleGroup) => TileListActivity(
                        muscleGroup: muscleGroup,
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
