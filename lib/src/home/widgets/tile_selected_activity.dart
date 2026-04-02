import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/repetition_weigth.dart';
import 'package:fit_tracker/DB/models/workout.dart';
import 'package:fit_tracker/DB/models/pool_activity.dart';
import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/repetition_weight_bloc.dart';
import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/repetition_weight_repository.dart';
import 'package:fit_tracker/src/home/screen/repetition_weight_screen.dart';
import 'package:fit_tracker/src/home/widgets/icon_widget.dart';
import 'package:fit_tracker/src/home/widgets/tile_repetition_weigth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TileSelectedActivity extends StatefulWidget {
  const TileSelectedActivity(
      {super.key, required this.poolActivity, required this.onChange, required this.workout});
  final PoolActivity poolActivity;
  final Workout workout;
  final Function onChange;
  @override
  State<TileSelectedActivity> createState() => _TileSelectedActivity();
}

class _TileSelectedActivity extends State<TileSelectedActivity> with TickerProviderStateMixin {
  bool isSelected = false;
  late final RepetitionWeightRepository repetitionWeightRepository;
  late Workout workout;
  late final int muscleGroupId;
  @override
  void initState() {
    repetitionWeightRepository = RepetitionWeightRepository();
    workout = widget.workout;
    muscleGroupId = widget.poolActivity.muscleGroupId;
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
          DataManager.instance.delWorkout(widget.workout.id);
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
              leading: IconWidget(muscleGroupId: muscleGroupId),
              selected: isSelected,
              onTap: () {
                isSelected = !isSelected;
                setState(() {});
              },
              title: Text(widget.poolActivity.nameRu as String),
              trailing: isSelected
                  ? Transform.rotate(angle: 33, child: Icon(Icons.arrow_back_ios_rounded))
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
                      children: workout.approachesList!
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
                                                RepetitionWeightBloc(repetitionWeightRepository),
                                            child: RepetitionWeightScreen(
                                              workout: workout,
                                              activityName: widget.poolActivity.nameRu.toString(),
                                              repetitionWeight:
                                                  workout.approachesList as List<RepetitionWeight>,
                                            ));
                                      }).whenComplete(() async {
                                    workout =
                                        await DataManager.instance.getWorkoutId(widget.workout.id);
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
