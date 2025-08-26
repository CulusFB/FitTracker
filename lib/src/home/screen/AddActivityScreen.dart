import 'package:fit_tracker/DB/DataManager.dart';
import 'package:fit_tracker/DB/models/muscleGroup.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';
import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/themes/FilledButtonTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AddActivityScreen extends StatefulWidget {
  AddActivityScreen(
      {super.key, required this.muscleGroup, PoolActivity? poolActivity})
      : poolActivity = poolActivity ?? PoolActivity();
  final MuscleGroup muscleGroup;
  PoolActivity poolActivity;
  @override
  State<AddActivityScreen> createState() => _AddActivityScreen(muscleGroup: muscleGroup, poolActivity: poolActivity);
}

class _AddActivityScreen extends State<AddActivityScreen>
    with TickerProviderStateMixin {
  _AddActivityScreen({required this.muscleGroup, PoolActivity? poolActivity})
      : poolActivity = poolActivity ?? PoolActivity();
  PoolActivity poolActivity;
  TextEditingController textController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  final MuscleGroup muscleGroup;
  @override
  void initState() {
    if (poolActivity.id != 0) {
      textController.text = poolActivity.nameRu as String;
      labelController.text =
          poolActivity.label != null ? poolActivity.label as String : '';
    }
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            Divider(),
            TextField(
              onChanged: (value) {
                setState(() {});
              },
              controller: textController,
              decoration: InputDecoration(
                hintText: S.of(context).name_activity,
              ),
            ),
            textController.text != ''
                ? TextField(
                    controller: labelController,
                    decoration: InputDecoration(hintText: S.of(context).label),
                  )
                : SizedBox(),
            poolActivity.id != 0
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //TODO: Добавить intl
                                  title: Text('Вы уверены?'),
                                  content: Text(
                                      'История выполнений и статистика не сохранятся. Это действие нельзя отменить.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Отмена'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        //TODO Проверить работоспособность Удалил await на след. строчке
                                        DataManager.instance.removeActivity(poolActivity.id);
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Да'),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          "Удалить упражнение",
                          style: TextStyle(color: Colors.redAccent),
                        )),
                  )
                : SizedBox(),
            Spacer(),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                spacing: 10,
                children: [
                  SizedBox(
                    height: 45,
                    child: IconButton.filled(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      iconSize: 30,
                    ),
                  ),
                  textController.text != ''
                      ? Expanded(
                          child: SizedBox(
                          height: 45,
                          child: FilledButton(
                              style: FilledButtonStyle(),
                              onPressed: () async {

                                final dataManager = DataManager.instance;
                                poolActivity = PoolActivity();
                                poolActivity.nameRu = textController.text;
                                poolActivity.label = labelController.text.isEmpty ? null: labelController.text;

                                if (dataManager.poolActivities.contains(poolActivity)) {
                                  dataManager.editActivity(poolActivity);
                                } else {
                                  dataManager.addActivity(poolActivity);
                                }


                                // if (poolActivity.id != 0) {
                                //   poolActivity.nameRu = textController.text;
                                //   poolActivity.label = labelController.text;
                                //   await DataManager.instance.updateActivity(poolActivity);
                                // } else {
                                //   await DataManager.instance.newActivity(PoolActivity(nameRu: textController.text, label: labelController.text != ''? labelController.text: null, muscleGroupId: muscleGroup.id));
                                // }
                                Navigator.pop(context);
                              },
                              child: Text("Сохранить")),
                        ))
                      : SizedBox()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
