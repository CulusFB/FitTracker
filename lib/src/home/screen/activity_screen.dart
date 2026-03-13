import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/repetition_weigth.dart';
import 'package:fit_tracker/DB/models/workout.dart';
import 'package:fit_tracker/DB/models/muscle_group.dart';
import 'package:fit_tracker/DB/models/pool_activity.dart';
import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/screen/add_activity_screen.dart';
import 'package:fit_tracker/src/home/widgets/tile_activity.dart';
import 'package:fit_tracker/src/themes/filled_button_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key, required this.muscleGroup});
  final MuscleGroup muscleGroup;

  @override
  State<ActivityScreen> createState() => _ActivityScreen();
}

class _ActivityScreen extends State<ActivityScreen>
    with TickerProviderStateMixin {
  late final MuscleGroup muscleGroup;
  late List<PoolActivity> poolActivityList;
  late TileController tileController;

  @override
  void initState() {
    super.initState();
    tileController = TileController();
    muscleGroup = widget.muscleGroup;
    poolActivityList =
        DataManager.instance.getPoolActivityMuscleGroup(muscleGroup.id);
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  muscleGroup.nameRu as String,
                  style: GoogleFonts.roboto(fontSize: 30),
                )),
            Container(
              padding: EdgeInsets.all(10),
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
                          return AddActivityScreen(
                            muscleGroup: muscleGroup,
                          );
                        }).whenComplete(() async {
                      poolActivityList = await DataManager.instance
                          .getPoolActivityMuscleGroup(muscleGroup.id);
                      setState(() {});
                    });
                  },
                  child: Text(
                    S.of(context).add_activity,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: poolActivityList
                      .map((poolActivity) => TileActivity(
                            key: Key(poolActivity.id.toString()),
                            poolActivity: poolActivity,
                            tileController: tileController,
                            onChange: () {
                              setState(() {});
                            },
                          ))
                      .toList(),
                ),
              ),
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
                            //TODO: maybe refactoring
                            List<Workout> workouts = [];
                            DateTime now =
                                DataManager.instance.calendarController.value;
                            DateTime date =
                                DateTime(now.year, now.month, now.day);
                            List<RepetitionWeight> repetitionWeight = [
                              RepetitionWeight(repetition: 0, weight: 0)
                            ];
                            tileController.enableActivity
                                .forEach((id, activity) {
                              workouts.add(Workout(
                                  date: date.toString(),
                                  poolActivityId: activity.id,
                                  approaches: repetitionWeight));
                            });
                            DataManager.instance.newWorkout(workouts);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 30,
                          ),
                          //TODO: Добавить intl
                          label: Text(
                              'Выбрать: ${tileController.enableActivity.length}'),
                        ),
                      ),
                      Spacer(),
                      tileController.enableActivity.length == 1
                          ? SizedBox(
                              height: 45,
                              child: FilledButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        useSafeArea: true,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return AddActivityScreen(
                                            muscleGroup: muscleGroup,
                                            poolActivity: tileController
                                                .enableActivity.values.first,
                                          );
                                        }).whenComplete(() async {
                                      List<PoolActivity> newPoolActivityList =
                                          await DataManager.instance
                                              .getPoolActivityMuscleGroup(
                                                  muscleGroup.id);
                                      if (newPoolActivityList.length !=
                                          poolActivityList.length) {
                                        tileController.enableActivity.clear();
                                        poolActivityList = newPoolActivityList;
                                      }

                                      setState(() {});
                                    });
                                  },
                                  child: Text(S.of(context).edit)))
                          : SizedBox()
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
