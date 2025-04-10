import 'package:fit_tracker/src/home/screen/ActivityScreen.dart';
import 'package:flutter/material.dart';

class TileListActivity extends StatefulWidget {
  const TileListActivity(
      {super.key, required this.activityName, required this.activityCount});
  final String activityName;
  final int activityCount;
  @override
  State<TileListActivity> createState() => _TileListActivity(
      activityCount: activityCount, activityName: activityName);
}

class _TileListActivity extends State<TileListActivity>
    with TickerProviderStateMixin {
  _TileListActivity({required this.activityCount, required this.activityName});
  final String activityName;
  final int activityCount;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return ActivityScreen(
                activityName: activityName,
              );
            });
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_activity,
              ),
              SizedBox(
                width: 10,
              ),
              Text(activityName),
            ],
          ),
          Row(
            children: [
              Text(activityCount.toString()),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
              )
            ],
          )
        ],
      ),
    );
  }
}
