import 'package:fit_tracker/DB/models/RepetitionWeigth.dart';
import 'package:fit_tracker/DB/models/Workout.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';
import 'package:fit_tracker/src/home/screen/RepetitionWeigthScreen.dart';
import 'package:fit_tracker/src/home/widgets/RepetitionWeigthTile.dart';
import 'package:flutter/material.dart';

class TileSelectedActivity extends StatefulWidget {
  const TileSelectedActivity(
      {super.key,
      required this.poolActivity,
      required this.onChange,
      required this.workout});
  final PoolActivity poolActivity;
  final Workout workout;
  final Function onChange;
  @override
  State<TileSelectedActivity> createState() => _TileSelectedActivity(
      poolActivity: poolActivity, onChange: onChange, workout: workout);
}

class _TileSelectedActivity extends State<TileSelectedActivity>
    with TickerProviderStateMixin {
  _TileSelectedActivity(
      {required this.poolActivity,
      required this.onChange,
      required this.workout});
  final PoolActivity poolActivity;
  final Workout workout;
  final Function onChange;
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          splashColor: Colors.transparent,
          leading: Icon(Icons.abc),
          selected: isSelected,
          onTap: () {
            isSelected = !isSelected;
            setState(() {});
          },
          title: Text(poolActivity.Name_ru as String),
          trailing: isSelected
              ? Transform.rotate(
                  angle: 33, child: Icon(Icons.arrow_back_ios_rounded))
              : Transform.rotate(
                  angle: 11,
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                  )),
          minVerticalPadding: 20,
        ),
        isSelected
            ? Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: workout.List_approaches!
                      .asMap()
                      .entries
                      .map((e) => RepetitionWeigthTile(
                            id: e.key + 1,
                            repetitionWeight: e.value,
                            onDismissed: () {},
                            onTap: () {
                              showModalBottomSheet(
                                  useSafeArea: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return RepetitionWeightScreen(
                                      workout: workout,
                                      activityName:
                                          poolActivity.Name_ru.toString(),
                                      repetitionWeight: workout.List_approaches
                                          as List<RepetitionWeight>,
                                    );
                                  }).whenComplete(() async {
                                setState(() {});
                              });
                            },
                          ))
                      .toList(),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
