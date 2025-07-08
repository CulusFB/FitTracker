import 'package:fit_tracker/DB/DataManager.dart';
import 'package:fit_tracker/DB/models/RepetitionWeigth.dart';
import 'package:fit_tracker/DB/models/Workout.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';
import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/RepetitionWeightBloc.dart';
import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/RepetitionWeightRepository.dart';
import 'package:fit_tracker/src/home/screen/RepetitionWeightScreen.dart';
import 'package:fit_tracker/src/home/widgets/RepetitionWeigthTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Workout workout;
  final Function onChange;
  bool isSelected = false;
  late final RepetitionWeightRepository repetitionWeightRepository;

  @override
  void initState() {
    repetitionWeightRepository = RepetitionWeightRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Вы уверены?"),
                content: const Text("Все данные упражнения будут удалены."),
                actions: <Widget>[
                  FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Удалить")),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Отмена"),
                  ),
                ],
              );
            },
          );
        },
        key: UniqueKey(),
        onDismissed: (direction) {
          DataManager.instance.delWorkout(workout.id);
        },
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.only(right: 10),
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete_forever,
            size: 30,
          ),
        ),
        direction: DismissDirection.endToStart,
        child: Column(
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
                                key: UniqueKey(),
                                id: e.key + 1,
                                repetitionWeight: e.value,
                                onDismissed: () {},
                                onTap: () {
                                  showModalBottomSheet(
                                      useSafeArea: true,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return BlocProvider(
                                            create: (BuildContext context) =>
                                                RepetitionWeightBloc(
                                                    repetitionWeightRepository),
                                            child: RepetitionWeightScreen(
                                              workout: workout,
                                              activityName: poolActivity.Name_ru
                                                  .toString(),
                                              repetitionWeight:
                                                  workout.List_approaches
                                                      as List<RepetitionWeight>,
                                            ));
                                      }).whenComplete(() async {
                                    workout = await DataManager.instance
                                        .getWorkoutId(workout.id);
                                    setState(() {});
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  )
                : SizedBox(),
          ],
        ));
  }
}
