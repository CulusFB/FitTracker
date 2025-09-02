import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleTheme extends GoogleFonts {}

class TextRepetitionWeightTheme extends TextStyle {
  @override
  // TODO: implement fontFamily
  String? get fontFamily => GoogleFonts.roboto().fontFamily;
  @override
  // TODO: implement fontSize
  double? get fontSize => 22;
}
