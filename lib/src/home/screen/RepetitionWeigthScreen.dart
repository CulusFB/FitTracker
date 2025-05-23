import 'package:fit_tracker/DB/DataManager.dart';
import 'package:fit_tracker/DB/models/RepetitionWeigth.dart';
import 'package:fit_tracker/DB/models/Workout.dart';
import 'package:fit_tracker/src/home/widgets/RepetitionWeigthTile.dart';
import 'package:fit_tracker/src/themes/FilledButtonTheme.dart';
import 'package:flutter/material.dart';
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
  State<RepetitionWeightScreen> createState() => _NewActivityScreen(
      activityName: activityName,
      repetitionWeight: repetitionWeight,
      workout: workout);
}

class _NewActivityScreen extends State<RepetitionWeightScreen>
    with TickerProviderStateMixin {
  final String activityName;
  final List<RepetitionWeight> repetitionWeight;
  late int lastId;
  final Workout workout;
  _NewActivityScreen(
      {required this.activityName,
      required this.repetitionWeight,
      required this.workout});
  @override
  void initState() {
    lastId = repetitionWeight.length + 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20, bottom: 40, left: 20, right: 20),
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
                    repetitionWeight
                        .asMap()
                        .entries
                        .map((e) => RepetitionWeigthTile(
                              id: e.key + 1,
                              repetitionWeight: e.value,
                              enable: e.key == 0 ? false : true,
                              onTap: () {},
                              onDismissed: () async {
                                await DataManager.instance
                                    .delReptitioonWeight(e.key, workout);
                                lastId = repetitionWeight.length + 1;
                                setState(() {});
                              },
                            ))
                        .toList() +
                    [
                      Row(
                        children: [
                          Text(lastId.toString()),
                          SizedBox(width: 10),
                          Expanded(
                              child: SizedBox(
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
                      )
                    ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                      onPressed: () {},
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
                                  fontWeight: FontWeight.bold, fontSize: 17),
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
          )
        ]),
      ),
    );
  }
}
