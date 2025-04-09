import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/widgets/TileActivity.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});
  @override
  State<ActivityScreen> createState() => _ActivityScreen();
}

class _ActivityScreen extends State<ActivityScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: FilledButton(
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).create_exercise),
                      Icon(Icons.add)
                    ],
                  ),
                )),
          ),
          TileActivity(activityName: 'Растяжка', activityCount: 3),
          TileActivity(activityName: 'Кардио', activityCount: 3),
          TileActivity(activityName: 'Грудь', activityCount: 2),
          TileActivity(activityName: 'Спина', activityCount: 3),
          TileActivity(activityName: 'Руки', activityCount: 3),
          TileActivity(activityName: 'Ноги', activityCount: 3),
          TileActivity(activityName: 'Плечи', activityCount: 3),
          TileActivity(activityName: 'Пресс', activityCount: 3),
        ],
      ),
    );
  }
}
