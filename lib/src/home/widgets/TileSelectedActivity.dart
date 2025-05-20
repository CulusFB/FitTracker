import 'package:fit_tracker/DB/models/RepetitionWeigth.dart';
import 'package:fit_tracker/DB/models/poolActivity.dart';
import 'package:fit_tracker/src/home/widgets/RepetitionWeigthTile.dart';
import 'package:flutter/material.dart';

class TileSelectedActivity extends StatefulWidget {
  const TileSelectedActivity(
      {super.key,
      required this.poolActivity,
      required this.onChange,
      required this.repetitionWeight});
  final PoolActivity poolActivity;
  final List<RepetitionWeight> repetitionWeight;
  final Function onChange;
  @override
  State<TileSelectedActivity> createState() => _TileSelectedActivity(
      poolActivity: poolActivity,
      onChange: onChange,
      repetitionWeight: repetitionWeight);
}

class _TileSelectedActivity extends State<TileSelectedActivity>
    with TickerProviderStateMixin {
  _TileSelectedActivity(
      {required this.poolActivity,
      required this.onChange,
      required this.repetitionWeight});
  final PoolActivity poolActivity;
  final List<RepetitionWeight> repetitionWeight;
  final Function onChange;
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          splashColor: Colors.transparent,
          leading: Icon(Icons.abc),
          selected: isSelected,
          onTap: () {
            isSelected = !isSelected;
            setState(() {});
          },
          title: Text(poolActivity.Name_ru as String),
          trailing: isSelected
              ? Transform.rotate(
                  angle: 33, child: Icon(Icons.arrow_back_ios_rounded))
              : Transform.rotate(
                  angle: 11,
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                  )),
          minVerticalPadding: 20,
        ),
        isSelected
            ? Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: repetitionWeight
                      .map((e) => RepetitionWeigthTile(repetitionWeight: e))
                      .toList(),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
