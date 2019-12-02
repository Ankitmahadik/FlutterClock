import 'package:flutter/material.dart';

class Utils {


  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
