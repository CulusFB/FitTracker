import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/pool_activity.dart';
import 'package:fit_tracker/DB/models/repetition_weigth.dart';
import 'package:fit_tracker/DB/models/workout.dart';
import 'package:fit_tracker/src/home/widgets/icon_widget.dart';
import 'package:fit_tracker/src/home/widgets/tile_activity.dart';
import 'package:flutter/material.dart';

class SearchActivity extends StatefulWidget {
  const SearchActivity({super.key, required this.search});
  final String search;
  @override
  State<SearchActivity> createState() => SearchAcvtivityState();
}

class SearchAcvtivityState extends State<SearchActivity> {
  late TileController tileController;
  late List<PoolActivity> activities;
  @override
  void initState() {
    activities = DataManager().poolActivities.where((el) {
      return (el.nameRu?.toLowerCase().startsWith(
                    widget.search.toLowerCase(),
                  ) ??
              false) ||
          (el.label?.toLowerCase().startsWith(
                    widget.search.toLowerCase(),
                  ) ??
              false);
    }).toList();
    tileController = TileController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: activities
                      .map((el) => TileActivity(
                          poolActivity: el,
                          tileController: tileController,
                          icon: IconWidget(muscleGroupId: el.muscleGroupId),
                          onChange: () {
                            setState(() {});
                          }))
                      .toList(),
                )),
              ),
              tileController.enableActivity.isEmpty
                  ? IconButton.filled(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      iconSize: 30,
                    )
                  : Row(
                      children: [
                        SizedBox(
                          height: 45,
                          child: FilledButton.icon(
                            iconAlignment: IconAlignment.start,
                            onPressed: () {
                              List<Workout> workouts = [];
                              DateTime now = DataManager().calendarController.value;
                              DateTime date = DateTime(now.year, now.month, now.day);
                              List<RepetitionWeight> repetitionWeight = [
                                RepetitionWeight(repetition: 0, weight: 0)
                              ];
                              tileController.enableActivity.forEach((id, activity) {
                                workouts.add(Workout(
                                    date: date.toString(),
                                    poolActivityId: activity.id,
                                    approaches: repetitionWeight));
                              });
                              DataManager().newWorkout(workouts);
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 30,
                            ),
                            //TODO: Добавить intl
                            label: Text('Выбрать: ${tileController.enableActivity.length}'),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
