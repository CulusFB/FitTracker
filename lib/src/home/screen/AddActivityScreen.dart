import 'package:fit_tracker/DB/crud/poolActivity_crud.dart';
import 'package:fit_tracker/DB/models/muscleGroup.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';
import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/themes/FilledButtonTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({
    super.key,
    required this.muscleGroup,
  });
  final MuscleGroup muscleGroup;
  @override
  State<AddActivityScreen> createState() => _AddActivityScreen(
        muscleGroup: muscleGroup,
      );
}

class _AddActivityScreen extends State<AddActivityScreen>
    with TickerProviderStateMixin {
  _AddActivityScreen({
    required this.muscleGroup,
  });
  TextEditingController textController = TextEditingController();
  final MuscleGroup muscleGroup;
  @override
  void initState() {
    super.initState();
  }

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
                  muscleGroup.Name_ru as String,
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
            Spacer(),
            Row(
              spacing: 10,
              children: [
                IconButton.filled(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  iconSize: 30,
                ),
                textController.text != ''
                    ? Expanded(
                        child: FilledButton(
                            style: FilledButtonStyle(),
                            onPressed: () async {
                              newPoolActivity(PoolActivity(
                                  Name_ru: textController.text,
                                  MuscleGroupId: muscleGroup.id));
                              Navigator.pop(context);
                            },
                            child: Text("Сохранить")))
                    : SizedBox()
              ],
            )
          ],
        ),
      ),
    );
  }
}
