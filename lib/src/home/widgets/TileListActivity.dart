import 'package:fit_tracker/DB/DataManager.dart';
import 'package:fit_tracker/DB/models/muscleGroup.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';
import 'package:fit_tracker/src/home/screen/ActivityScreen.dart';
import 'package:flutter/material.dart';

class TileListActivity extends StatefulWidget {
  const TileListActivity({super.key, required this.muscleGroup});
  final MuscleGroup muscleGroup;
  @override
  State<TileListActivity> createState() =>
      _TileListActivity(muscleGroup: muscleGroup);
}

class _TileListActivity extends State<TileListActivity>
    with TickerProviderStateMixin {
  _TileListActivity({required this.muscleGroup});
  final MuscleGroup muscleGroup;
  late List<PoolActivity> idPoolActivity =
      DataManager.instance.getPoolActivityMuscleGroup(muscleGroup.id);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return ActivityScreen(
                muscleGroup: muscleGroup,
                poolActivityList: idPoolActivity,
              );
            }).whenComplete(() {
          setState(() {});
        });
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_activity,
              ),
              SizedBox(
                width: 10,
              ),
              Text(muscleGroup.Name_ru as String),
            ],
          ),
          Row(
            children: [
              Text(idPoolActivity.length.toString()),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
              )
            ],
          )
        ],
      ),
    );
  }
}
