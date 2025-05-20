import 'package:flutter/material.dart';

class TextFieldActivityTheme extends InputDecoration {
  @override
  // TODO: implement border
  InputBorder? get border => OutlineInputBorder(
      borderSide: BorderSide(width: 1),
      borderRadius: BorderRadius.circular(20));
}
