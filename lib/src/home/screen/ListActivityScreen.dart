import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/widgets/TileListActivity.dart';
import 'package:fit_tracker/src/themes/FilledButtonTheme.dart';
import 'package:flutter/material.dart';

class ListActivityScreen extends StatefulWidget {
  const ListActivityScreen({super.key});
  @override
  State<ListActivityScreen> createState() => _ListActivityScreen();
}

class _ListActivityScreen extends State<ListActivityScreen>
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
                style: FilledButtonStyle(),
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
          TileListActivity(activityName: 'Растяжка', activityCount: 3),
          TileListActivity(activityName: 'Кардио', activityCount: 3),
          TileListActivity(activityName: 'Грудь', activityCount: 2),
          TileListActivity(activityName: 'Спина', activityCount: 3),
          TileListActivity(activityName: 'Руки', activityCount: 3),
          TileListActivity(activityName: 'Ноги', activityCount: 3),
          TileListActivity(activityName: 'Плечи', activityCount: 3),
          TileListActivity(activityName: 'Пресс', activityCount: 3),
        ],
      ),
    );
  }
}
