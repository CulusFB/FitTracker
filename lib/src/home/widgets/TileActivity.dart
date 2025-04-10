import 'package:flutter/material.dart';

class TileActivity extends StatefulWidget {
  const TileActivity({super.key, required this.activityName});
  final String activityName;
  @override
  State<TileActivity> createState() =>
      _TileActivity(activityName: activityName);
}

class _TileActivity extends State<TileActivity> with TickerProviderStateMixin {
  _TileActivity({required this.activityName});
  final String activityName;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(onTap: () {}, title: Text(activityName));
  }
}
