import 'package:fit_tracker/DB/models/poolActivity.dart';
import 'package:flutter/material.dart';

class TileController {
  Map<int, PoolActivity> enableActivity = {};
}

class TileActivity extends StatefulWidget {
  const TileActivity(
      {super.key,
      required this.poolActivity,
      required this.tileController,
      required this.onChange});
  final TileController tileController;
  final PoolActivity poolActivity;
  final Function onChange;
  @override
  State<TileActivity> createState() => _TileActivity(
      poolActivity: poolActivity,
      tileController: tileController,
      onChange: onChange);
}

class _TileActivity extends State<TileActivity> with TickerProviderStateMixin {
  _TileActivity(
      {required this.poolActivity,
      required this.tileController,
      required this.onChange});
  final PoolActivity poolActivity;
  final TileController tileController;
  final Function onChange;
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      internalAddSemanticForOnTap: false,
      splashColor: Colors.transparent,
      selected: isSelected,
      onTap: () {
        isSelected = !isSelected;
        isSelected
            ? tileController.enableActivity[poolActivity.id] = poolActivity
            : tileController.enableActivity.remove(poolActivity.id);
        onChange();
        setState(() {});
      },
      title: Text(poolActivity.Name_ru as String),
      subtitle: poolActivity.label != null
          ? Text(poolActivity.label as String)
          : null,
      trailing: isSelected ? Icon(Icons.check) : null,
      minVerticalPadding: 20,
    );
  }
}
