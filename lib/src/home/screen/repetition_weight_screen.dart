import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/repetition_weigth.dart';
import 'package:fit_tracker/DB/models/workout.dart';
import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/repetition_weight_bloc.dart';
import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/repetition_weight_event.dart';
import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/repetition_weight_state.dart';
import 'package:fit_tracker/src/home/screen/statistics_screen.dart';
import 'package:fit_tracker/src/home/widgets/tile_repetition_weigth.dart';
import 'package:fit_tracker/src/themes/filled_button_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RepetitionWeightScreen extends StatefulWidget {
  const RepetitionWeightScreen(
      {super.key,
      required this.activityName,
      required this.repetitionWeight,
      required this.workout});
  final String activityName;
  final List<RepetitionWeight> repetitionWeight;
  final Workout workout;

  @override
  State<RepetitionWeightScreen> createState() => _RepetitionWeightScreen();
}

class _RepetitionWeightScreen extends State<RepetitionWeightScreen> {
  late final String activityName;
  late List<RepetitionWeight> repetitionWeight;
  late int lastId;
  late final Workout workout;
  bool onFocus = false;
  dynamic lastWorkout = 0;

  @override
  void initState() {
    super.initState();
    activityName = widget.activityName;
    repetitionWeight = widget.repetitionWeight;
    workout = widget.workout;
    lastId = repetitionWeight.length + 1;
    getLastWorkouts();
  }

  dynamic getLastWorkouts() async {
    lastWorkout =
        await DataManager.instance.getWorkoutLast(workout.poolActivityId);
    setState(() {});
  }

  void checkFocus(FocusNode weightFocus, FocusNode repetitionFocus) {
    if (weightFocus.hasFocus || repetitionFocus.hasFocus) {
      BlocProvider.of<RepetitionWeightBloc>(context)
          .add(RepetitionWeightSaveEvent());
    } else {
      BlocProvider.of<RepetitionWeightBloc>(context)
          .add(RepetitionWeightDefaultEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              activityName,
              style:
                  GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Text('Вес'),
              SizedBox(
                width: 150,
              ),
              Text("Повторы")
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[] +
                    repetitionWeight.asMap().entries.map((e) {
                      FocusNode weightFocus = FocusNode();
                      FocusNode repetitionFocus = FocusNode();
                      weightFocus.addListener(() {
                        checkFocus(weightFocus, repetitionFocus);
                      });
                      repetitionFocus.addListener(() {
                        checkFocus(weightFocus, repetitionFocus);
                      });
                      return RepetitionWeigthTile(
                        key: UniqueKey(),
                        enableTextEdit: true,
                        weightFocus: weightFocus,
                        repetitionFocus: repetitionFocus,
                        id: e.key + 1,
                        repetitionWeight: e.value,
                        enableDismissed: e.key == 0 ? false : true,
                        onTap: () {},
                        onDismissed: () async {
                          await DataManager.instance
                              .delReptitioonWeight(e.key, workout);
                          lastId = repetitionWeight.length + 1;
                          setState(() {});
                        },
                      );
                    }).toList() +
                    [
                      Row(
                        children: [
                          // Text(lastId.toString()),
                          SizedBox(width: 10),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(left: 10),
                            height: 60,
                            child: FilledButton(
                                style: FilledButtonStyle(),
                                onPressed: () async {
                                  RepetitionWeight newRepetitionWeight =
                                      RepetitionWeight(
                                          weight: repetitionWeight.last.weight,
                                          repetition:
                                              repetitionWeight.last.repetition);
                                  repetitionWeight.add(newRepetitionWeight);
                                  lastId++;
                                  await DataManager.instance
                                      .addRepetitionWeight(
                                          newRepetitionWeight, workout.id);
                                  setState(() {});
                                },
                                child: Text("Добавить подход")),
                          ))
                        ],
                      ),
                      if (repetitionWeight.first.repetition == 0 &&
                          repetitionWeight.first.weight == 0 &&
                          lastWorkout != 0)
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 20),
                                  height: 60,
                                  child: FilledButton(
                                      onPressed: () async {
                                        Workout lastWorkout = await DataManager
                                            .instance
                                            .getWorkoutLast(
                                                workout.poolActivityId);

                                        setState(() {
                                          repetitionWeight =
                                              lastWorkout.approachesList
                                                  as List<RepetitionWeight>;
                                          DataManager.instance
                                              .updAllRepetitionWeight(
                                                  repetitionWeight, workout.id);
                                        });
                                      },
                                      style: FilledButtonStyle(),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.copy_outlined,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Копировать прошлое")
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          BlocBuilder<RepetitionWeightBloc, RepetitionWeightState>(
              builder: (context, state) {
            if (state is RepetitionWeightDefaultState) {
              return Container(
                padding: EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: FilledButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                  useSafeArea: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return StatisticScreen(
                                      poolActivityId: workout.poolActivityId,
                                    );
                                  });
                            },
                            label: Row(
                              children: [
                                Icon(
                                  Icons.bar_chart_rounded,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    'Статистика',
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Готово')),
                      ),
                    )
                  ],
                ),
              );
            }
            if (state is RepetitionWeightSaveState) {
              return Container(
                  padding: EdgeInsets.only(bottom: 10),
                  height: 60,
                  width: MediaQuery.sizeOf(context).width,
                  child: FilledButton(
                      onPressed: () {
                        onFocus = false;
                        DataManager.instance.updAllRepetitionWeight(
                            repetitionWeight, workout.id);
                        setState(() {});
                        BlocProvider.of<RepetitionWeightBloc>(context)
                            .add(RepetitionWeightDefaultEvent());
                      },
                      child: Text('Сохранить')));
            }
            return SizedBox();
          }),
        ]),
      ),
    );
  }
}
