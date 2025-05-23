import 'package:fit_tracker/DB/models/RepetitionWeigth.dart';
import 'package:fit_tracker/src/themes/TextFieldTheme.dart';
import 'package:fit_tracker/src/themes/TextStyleTheme.dart';
import 'package:flutter/material.dart';

class RepetitionWeigthTile extends StatefulWidget {
  const RepetitionWeigthTile(
      {super.key,
      required this.repetitionWeight,
      required this.onTap,
      required this.id,
      required this.onDismissed,
      this.enable = false});
  final RepetitionWeight repetitionWeight;
  final Function onTap;
  final Function onDismissed;
  final int id;
  final bool enable;
  @override
  State<RepetitionWeigthTile> createState() => _RepetitionWeigthTile(
      repetitionWeight: repetitionWeight,
      onTap: onTap,
      id: id,
      onDismissed: onDismissed,
      enable: enable);
}

class _RepetitionWeigthTile extends State<RepetitionWeigthTile> {
  final RepetitionWeight repetitionWeight;
  final int id;
  final Function onTap;
  final Function onDismissed;
  final bool enable;
  _RepetitionWeigthTile(
      {required this.repetitionWeight,
      required this.onTap,
      required this.id,
      required this.onDismissed,
      required this.enable});
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        setState(() {});
      },
      child: Dismissible(
        onDismissed: (direction) async {
          onDismissed();
        },
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.only(right: 10),
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete_forever,
            size: 30,
          ),
        ),
        direction: enable ? DismissDirection.endToStart : DismissDirection.none,
        key: UniqueKey(),
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Text(id.toString()),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: TextFieldActivityTheme(),
                    enabled: false,
                    controller: TextEditingController(
                        text: repetitionWeight.weight.toString()),
                    style: TextRepetitionWeightTheme()),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: TextFieldActivityTheme(),
                  enabled: false,
                  controller: TextEditingController(
                      text: repetitionWeight.repetition.toString()),
                  style: TextRepetitionWeightTheme(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
