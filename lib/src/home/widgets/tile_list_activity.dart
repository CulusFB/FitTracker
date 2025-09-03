import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/muscle_group.dart';
import 'package:fit_tracker/DB/models/pool_activity.dart';
import 'package:fit_tracker/src/home/screen/activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class TileListActivity extends StatefulWidget {
  const TileListActivity({super.key, required this.muscleGroup});
  final MuscleGroup muscleGroup;
  @override
   State<TileListActivity> createState() =>
      _TileListActivity(muscleGroup: muscleGroup);
}

class _TileListActivity extends State<TileListActivity> with TickerProviderStateMixin {
  late final MuscleGroup muscleGroup;
  late List<PoolActivity> idPoolActivity;

   _TileListActivity({required this.muscleGroup});

  @override
  void initState() {
    idPoolActivity =
        DataManager.instance.getPoolActivityMuscleGroup(muscleGroup.id);
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
              return ActivityScreen(muscleGroup: muscleGroup);
            }).whenComplete(() {
          idPoolActivity =
              DataManager.instance.getPoolActivityMuscleGroup(muscleGroup.id);
          setState(() {});
        });
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  // TODO: Добавить белые иконки и их обработку от темы
                  width: 60,
                  height: 60,
                  child: FutureBuilder<String>(
                      future: rootBundle.loadString(
                          'assets/icons/MuscleGroup/${muscleGroup.id}.svg'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SvgPicture.string(
                            snapshot.data!,
                          );
                        } else {
                          print("Ошибка при загрузке SVG: ${snapshot.error}");
                          return Icon(Icons.abc);
                        }
                      })),
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
