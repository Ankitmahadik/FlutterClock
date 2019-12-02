import 'package:flutter/material.dart';

class ColorsUtil {
  final clockBGLight = Colors.white;
  final clockBGDark = Color(0xFF222831);

  final shadowColorLight = Colors.black26.withOpacity(0.04);
  final shadowColorDark = Colors.white24.withOpacity(0.04);

  final textColorLight = Color(0x80000000);
  final textColorDark = Colors.grey;

  List<Color> getColorsLightArray() {
    return [
      Color(0xFF6A1B9A),
      Color(0xFF8E24AA),
      Color(0xFFAB47BC),
      Color(0xFF1976D2),
      Color(0xFF0D47A1),
      Color(0xFF004D40),
      Color(0xFF00796B),
      Color(0xFF43A047),
      Color(0xFF2E7D32),
      Color(0xFF1B5E20),
      Color(0xFFF57C00),
      Color(0xFFE65100),
      Color(0xFFC62828),
      Color(0xFFE53935),
      Color(0xFFEF5350),
      Color(0xFFEC407A),
      Color(0xFFD81B60),
      Color(0xFFAD1457),
    ];
  }

  List<Color> getColorsDarkArray() {
    return [
      Color(0xFFf67280),
      Color(0xFFDCFFCC),
      Color(0xFFFF6464),
      Color(0xFFEAE7AF),
      Color(0xFFCA3E47),
      Color(0xFFE14594),
      Color(0xFFA7D129),
      Color(0xFF4ECCA3),
      Color(0xFFE16428),
      Color(0xFFF1BBD5),
      Color(0xFF91BD3A),
      Color(0xFFFFD800),
      Color(0xFFE08F62),
      Color(0xFF4DD599),
    ];
  }
}
