import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/muscle_group.dart';
import 'package:fit_tracker/DB/models/pool_activity.dart';
import 'package:fit_tracker/src/home/screen/activity_screen.dart';
import 'package:fit_tracker/src/home/widgets/icon_widget.dart';
import 'package:flutter/material.dart';

class TileListActivity extends StatefulWidget {
  const TileListActivity({super.key, required this.muscleGroup});
  final MuscleGroup muscleGroup;
  @override
  State<TileListActivity> createState() => _TileListActivity();
}

class _TileListActivity extends State<TileListActivity> with TickerProviderStateMixin {
  late final MuscleGroup muscleGroup;
  late List<PoolActivity> idPoolActivity;

  @override
  void initState() {
    super.initState();
    muscleGroup = widget.muscleGroup;
    idPoolActivity = DataManager.instance.getPoolActivityMuscleGroup(muscleGroup.id);
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
              return ActivityScreen(muscleGroup: muscleGroup);
            }).whenComplete(() {
          idPoolActivity = DataManager.instance.getPoolActivityMuscleGroup(muscleGroup.id);
          setState(() {});
        });
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconWidget(muscleGroupId: muscleGroup.id),
              SizedBox(
                width: 10,
              ),
              Text(muscleGroup.nameRu as String),
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
