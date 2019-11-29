import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTextHelper extends StatelessWidget {
  const DateTextHelper();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: DateFormat("MMM").format(DateTime.now()).toUpperCase(),
        style: const TextStyle(
            color: const Color(0x80000000),
            fontSize: 11.0,
            fontFamily: 'VarelaRound',
            fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(
            text: " ${DateFormat("dd").format(DateTime.now())}",
            style: const TextStyle(
              color: const Color(0x80000000),
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              decorationStyle: TextDecorationStyle.wavy,
            ),
            children: <TextSpan>[
              TextSpan(
                text:
                    "\n${DateFormat("EEE").format(DateTime.now()).toUpperCase()}",
                style: const TextStyle(
                  color: const Color(0xBF000000),
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
