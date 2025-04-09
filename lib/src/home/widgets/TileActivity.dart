import 'package:flutter/material.dart';

class TileActivity extends StatefulWidget {
  const TileActivity(
      {super.key, required this.activityName, required this.activityCount});
  final String activityName;
  final int activityCount;
  @override
  State<TileActivity> createState() =>
      _TileActivity(activityCount: activityCount, activityName: activityName);
}

class _TileActivity extends State<TileActivity> with TickerProviderStateMixin {
  _TileActivity({required this.activityCount, required this.activityName});
  final String activityName;
  final int activityCount;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
