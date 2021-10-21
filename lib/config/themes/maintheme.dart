import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class MainThemeInterface {
  final gradiant = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xff7E33B8), Color(0xffEE5A3A)])
      .createShader(Rect.fromLTWH(0, 0, 0.0, 150.0));
  ThemeData getTheme();
}

class MainTheme extends MainThemeInterface {
  @override
  ThemeData getTheme() {
    return ThemeData(
      fontFamily: 'Poppings',
      textTheme: TextTheme(
        bodyText1: GoogleFonts.poppins(),
        headline1: GoogleFonts.poppins(foreground: Paint()..shader = gradiant),
        headline2: GoogleFonts.poppins(foreground: Paint()..shader = gradiant),
        headline3: GoogleFonts.poppins(foreground: Paint()..shader = gradiant),
        headline4: GoogleFonts.poppins(foreground: Paint()..shader = gradiant),
        headline5: TextStyle(
            foreground: Paint()..shader = gradiant,
            fontWeight: FontWeight.bold),
        headline6: TextStyle(foreground: Paint()..shader = gradiant),
        subtitle1: TextStyle(foreground: Paint()..shader = gradiant),
        bodyText2: GoogleFonts.poppins(
            foreground: Paint()..shader = gradiant,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
