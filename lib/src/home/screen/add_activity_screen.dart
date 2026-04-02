import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/muscle_group.dart';
import 'package:fit_tracker/DB/models/pool_activity.dart';
import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/themes/filled_button_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AddActivityScreen extends StatefulWidget {
  AddActivityScreen({super.key, required this.muscleGroup, PoolActivity? poolActivity})
      : poolActivity = poolActivity ?? PoolActivity();
  final MuscleGroup muscleGroup;
  PoolActivity poolActivity;
  @override
  State<AddActivityScreen> createState() => _AddActivityScreen();
}

class _AddActivityScreen extends State<AddActivityScreen> with TickerProviderStateMixin {
  late PoolActivity poolActivity;
  TextEditingController textController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  late final MuscleGroup muscleGroup;

  @override
  void initState() {
    poolActivity = widget.poolActivity;
    muscleGroup = widget.muscleGroup;
    if (poolActivity.id != 0) {
      textController.text = poolActivity.nameRu as String;
      labelController.text = poolActivity.label != null ? poolActivity.label as String : '';
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
                                        await DataManager.instance.removeActivity(poolActivity.id);
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
                                poolActivity.muscleGroupId = muscleGroup.id;
                                poolActivity.label =
                                    labelController.text.isEmpty ? null : labelController.text;
                                if (widget.poolActivity.id != 0) {
                                  poolActivity.id = widget.poolActivity.id;
                                  await dataManager.editActivity(poolActivity);
                                } else {
                                  await dataManager.addActivity(poolActivity);
                                }
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
