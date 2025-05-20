import 'package:fit_tracker/DB/models/RepetitionWeigth.dart';
import 'package:fit_tracker/src/themes/TextFieldTheme.dart';
import 'package:fit_tracker/src/themes/TextStyleTheme.dart';
import 'package:flutter/material.dart';

class RepetitionWeigthTile extends StatefulWidget {
  const RepetitionWeigthTile({super.key, required this.repetitionWeight});
  final RepetitionWeight repetitionWeight;
  @override
  State<RepetitionWeigthTile> createState() =>
      _RepetitionWeigthTile(repetitionWeight: repetitionWeight);
}

class _RepetitionWeigthTile extends State<RepetitionWeigthTile> {
  final RepetitionWeight repetitionWeight;

  _RepetitionWeigthTile({required this.repetitionWeight});
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(repetitionWeight.id.toString()),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
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
            textAlign: TextAlign.center,
            decoration: TextFieldActivityTheme(),
            enabled: false,
            controller: TextEditingController(
                text: repetitionWeight.repetition.toString()),
            style: TextRepetitionWeightTheme(),
          ),
        )
      ],
    );
  }
}
