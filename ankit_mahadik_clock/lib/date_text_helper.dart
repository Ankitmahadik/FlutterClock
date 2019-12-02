import 'package:ankit_mahadik_clock/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'colors_util.dart';

class DateTextHelper extends StatelessWidget {
  const DateTextHelper();

  @override
  Widget build(BuildContext context) {
    Color textColor = Utils().isDarkMode(context)
        ? ColorsUtil().textColorDark
        : ColorsUtil().textColorLight;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: DateFormat("MMM").format(DateTime.now()).toUpperCase(),
        style: TextStyle(
            color: textColor,
            fontSize: 11.0,
            fontFamily: 'VarelaRound',
            fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(
            text: " ${DateFormat("dd").format(DateTime.now())}",
            style: TextStyle(
              color: textColor,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              decorationStyle: TextDecorationStyle.wavy,
            ),
            children: <TextSpan>[
              TextSpan(
                text:
                    "\n${DateFormat("EEE").format(DateTime.now()).toUpperCase()}",
                style: TextStyle(
                  color: textColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  decorationStyle: TextDecorationStyle.wavy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
