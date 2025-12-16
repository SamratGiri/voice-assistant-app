import 'package:flutter/material.dart';

class Pallete {
  static const Color mainFontColor = Color.fromRGBO(0, 0, 0, 1);
  static const Color firstSuggestionBoxColor = Color.fromRGBO(184, 181, 255, 1);
  static const Color secondSuggestionBoxColor = Color.fromRGBO(
    255,
    230,
    109,
    1,
  );
  static const Color thirdSuggestionBoxColor = Color.fromRGBO(255, 107, 107, 1);
  static const Color assistantCircleColor = Color.fromRGBO(184, 181, 255, 1);
  static const Color borderColor = Color.fromRGBO(200, 200, 200, 1);
  static const Color blackColor = Colors.black;
  static const Color whiteColor = Colors.white;
  static const Color backgroundColor = Color(0xFF2C211F);
  static const Color greenColor = Colors.green;
}

class Fonts {
  static const TextStyle medium = TextStyle(
    fontFamily: "Cera-Pro",
    fontSize: 14,
    fontStyle: FontStyle.italic,
  );
  static const TextStyle bold = TextStyle(
    fontFamily: "Cera-Pro",
    fontSize: 24,
    color: Colors.orangeAccent,
    fontWeight: FontWeight.w800,
  );
}
