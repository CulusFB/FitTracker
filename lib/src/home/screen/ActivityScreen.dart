import 'package:fit_tracker/DB/crud/poolActivity_crud.dart';
import 'package:fit_tracker/DB/models/muscleGroup.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';
import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/screen/AddActivityScreen.dart';
import 'package:fit_tracker/src/home/widgets/TileActivity.dart';
import 'package:fit_tracker/src/themes/FilledButtonTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen(
      {super.key, required this.muscleGroup, required this.poolActivityList});
  final MuscleGroup muscleGroup;
  final List<PoolActivity> poolActivityList;
  @override
  State<ActivityScreen> createState() => _ActivityScreen(
      muscleGroup: muscleGroup, poolActivityList: poolActivityList);
}

class _ActivityScreen extends State<ActivityScreen>
    with TickerProviderStateMixin {
  _ActivityScreen({required this.muscleGroup, required this.poolActivityList});
  final MuscleGroup muscleGroup;
  List<PoolActivity> poolActivityList;
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
                      poolActivityList =
                          await getPoolActivityMuscleGroupID(muscleGroup.id);
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
            Column(
              children: poolActivityList
                  .map((poolActivity) => TileActivity(
                        activityName: poolActivity.Name_ru as String,
                      ))
                  .toList(),
            ),
            Spacer(),
            IconButton.filled(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              iconSize: 30,
            )
          ],
        ),
      ),
    );
  }
}
