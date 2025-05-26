import 'package:fit_tracker/DB/models/RepetitionWeigth.dart';
import 'package:fit_tracker/src/themes/TextFieldTheme.dart';
import 'package:fit_tracker/src/themes/TextStyleTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RepetitionWeigthTile extends StatefulWidget {
  RepetitionWeigthTile(
      {super.key,
      required this.repetitionWeight,
      required this.onTap,
      required this.id,
      required this.onDismissed,
      this.enableDismissed = false,
      this.enableTextEdit = false,
      FocusNode? repetitionFocus,
      FocusNode? weightFocus})
      : repetitionFocus = repetitionFocus ?? FocusNode(),
        weigthFocus = weightFocus ?? FocusNode();
  final RepetitionWeight repetitionWeight;
  final Function onTap;
  final Function onDismissed;
  final int id;
  final bool enableDismissed;
  final bool enableTextEdit;
  final FocusNode repetitionFocus;
  final FocusNode weigthFocus;
  @override
  State<RepetitionWeigthTile> createState() => _RepetitionWeigthTile(
      repetitionWeight: repetitionWeight,
      onTap: onTap,
      id: id,
      onDismissed: onDismissed,
      enable: enableDismissed,
      enableTextEdit: enableTextEdit,
      repetitionFocus: repetitionFocus,
      weigthFocus: weigthFocus);
}

class _RepetitionWeigthTile extends State<RepetitionWeigthTile> {
  final RepetitionWeight repetitionWeight;
  final int id;
  final Function onTap;
  final Function onDismissed;
  final bool enable;
  final bool enableTextEdit;
  late final TextEditingController weightTextController;
  late final TextEditingController repetitionTextController;
  _RepetitionWeigthTile(
      {required this.repetitionWeight,
      required this.onTap,
      required this.id,
      required this.onDismissed,
      required this.enable,
      required this.enableTextEdit,
      required this.repetitionFocus,
      required this.weigthFocus});
  final FocusNode repetitionFocus;
  final FocusNode weigthFocus;
  @override
  void initState() {
    weightTextController = TextEditingController(
        text: formatDouble(repetitionWeight.weight as double));
    repetitionTextController =
        TextEditingController(text: repetitionWeight.repetition.toString());
    super.initState();
  }

  void disableFocus() {
    repetitionFocus.unfocus();
    weigthFocus.unfocus();
  }

  String formatDouble(double value) {
    if ((value % 1).abs() < 0.000001) {
      return value.toInt().toString().replaceAll(',', '.');
    }
    return value.toString();
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
                    focusNode: weigthFocus,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      repetitionWeight.weight = weightTextController
                              .text.isNotEmpty
                          ? double.parse(
                              weightTextController.text.replaceAll(',', '.'))
                          : 0.0;
                    },
                    textAlign: TextAlign.center,
                    decoration: TextFieldActivityTheme(),
                    enabled: enableTextEdit,
                    controller: weightTextController,
                    style: TextRepetitionWeightTheme()),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextField(
                  autofocus: repetitionFocus.hasFocus,
                  focusNode: repetitionFocus,
                  onChanged: (value) {
                    repetitionWeight.repetition =
                        repetitionTextController.text.isNotEmpty
                            ? int.parse(repetitionTextController.text)
                            : 0;
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: TextFieldActivityTheme(),
                  enabled: enableTextEdit,
                  controller: repetitionTextController,
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
