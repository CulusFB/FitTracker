import 'package:flutter/material.dart';

class FilledButtonStyle extends ButtonStyle {
  final Color? color;
  FilledButtonStyle({this.color});

  @override
  // TODO: implement backgroundColor
  WidgetStateProperty<Color?>? get backgroundColor {}

  @override
  // TODO: implement shape
  WidgetStateProperty<OutlinedBorder?>? get shape =>
      WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), side: const BorderSide()));
}
