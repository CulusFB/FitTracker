import 'package:fit_tracker/DB/models/RepetitionWeigth.dart';
import 'package:fit_tracker/src/themes/TextFieldTheme.dart';
import 'package:fit_tracker/src/themes/TextStyleTheme.dart';
import 'package:flutter/material.dart';

class RepetitionWeigthTile extends StatefulWidget {
  const RepetitionWeigthTile(
      {super.key,
      required this.repetitionWeight,
      required this.onTap,
      required this.id});
  final RepetitionWeight repetitionWeight;
  final Function onTap;
  final int id;
  @override
  State<RepetitionWeigthTile> createState() => _RepetitionWeigthTile(
      repetitionWeight: repetitionWeight, onTap: onTap, id: id);
}

class _RepetitionWeigthTile extends State<RepetitionWeigthTile> {
  final RepetitionWeight repetitionWeight;
  final int id;
  final Function onTap;
  _RepetitionWeigthTile(
      {required this.repetitionWeight, required this.onTap, required this.id});
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
    );
  }
}
