import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateTextHelper extends StatelessWidget {
  final String _date, _month, _day;

  DateTextHelper(this._date, this._month, this._day);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: _month.toUpperCase(),
        style: TextStyle(
            color: Colors.black26.withOpacity(0.50),
            fontSize: 11.0,
            fontFamily: 'VarelaRound',
            fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(
            text: " $_date",
            style: TextStyle(
              color: Colors.black26.withOpacity(0.50),
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              decorationStyle: TextDecorationStyle.wavy,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "\n${_day.toUpperCase()}",
                style: TextStyle(
                  color: Colors.black26.withOpacity(0.90),
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
