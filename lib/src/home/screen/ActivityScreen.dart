import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/widgets/TileActivity.dart';
import 'package:fit_tracker/src/themes/FilledButtonTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key, required this.activityName});
  final String activityName;
  @override
  State<ActivityScreen> createState() =>
      _ActivityScreen(activityName: activityName);
}

class _ActivityScreen extends State<ActivityScreen>
    with TickerProviderStateMixin {
  _ActivityScreen({required this.activityName});
  final String activityName;
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
                  activityName,
                  style: GoogleFonts.roboto(fontSize: 30),
                )),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: FilledButton(
                  style: FilledButtonStyle(),
                  onPressed: () {},
                  child: Text(
                    S.of(context).add_activity,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            TileActivity(activityName: "Растяжка грудных мышц"),
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
