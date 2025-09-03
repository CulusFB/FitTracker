import 'package:flutter/material.dart';

class FilledButtonStyle extends ButtonStyle {
  @override
  // TODO: implement shape
  WidgetStateProperty<OutlinedBorder?>? get shape =>
      WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), side: const BorderSide()));
}
