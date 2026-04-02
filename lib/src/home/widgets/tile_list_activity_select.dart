import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/muscle_group.dart';
import 'package:fit_tracker/DB/models/pool_activity.dart';
import 'package:fit_tracker/src/home/screen/add_activity_screen.dart';
import 'package:flutter/material.dart';

class TileListActivitySelect extends StatefulWidget {
  const TileListActivitySelect({super.key, required this.muscleGroup});
  final MuscleGroup muscleGroup;
  @override
  State<TileListActivitySelect> createState() => _TileListActivitySelect();
}

class _TileListActivitySelect extends State<TileListActivitySelect> with TickerProviderStateMixin {
  late final MuscleGroup muscleGroup;
  late List<PoolActivity> idPoolActivity;
  @override
  void initState() {
    muscleGroup = widget.muscleGroup;
    idPoolActivity = DataManager.instance.getPoolActivityMuscleGroup(muscleGroup.id);
    super.initState();
  }

  void exit() {
    Navigator.pop(context);
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
              return AddActivityScreen(muscleGroup: muscleGroup);
            }).whenComplete(exit);
        // Navigator.pop(context);
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
              Text(muscleGroup.nameRu.toString()),
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
