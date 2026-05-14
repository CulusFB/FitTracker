import 'package:fit_tracker/DB/models/pool_activity.dart';
import 'package:flutter/material.dart';

class TileController {
  Map<int, PoolActivity> enableActivity = {};
}

class TileActivity extends StatefulWidget {
  const TileActivity(
      {super.key,
      required this.poolActivity,
      required this.tileController,
      required this.onChange,
      this.icon});
  final TileController tileController;
  final PoolActivity poolActivity;
  final Function onChange;
  final Widget? icon;
  @override
  State<TileActivity> createState() => _TileActivity();
}

class _TileActivity extends State<TileActivity> with TickerProviderStateMixin {
  late final PoolActivity poolActivity;
  late final TileController tileController;
  late final Function onChange;
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    poolActivity = widget.poolActivity;
    tileController = widget.tileController;
    onChange = widget.onChange;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.icon,
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
      title: Text(poolActivity.nameRu as String),
      subtitle: poolActivity.label != null ? Text(poolActivity.label as String) : null,
      trailing: isSelected ? Icon(Icons.check) : null,
      minVerticalPadding: 20,
    );
  }
}
