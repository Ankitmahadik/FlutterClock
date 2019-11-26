import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateTextHelper extends StatelessWidget {
  final String _date, _month;

  DateTextHelper(this._date, this._month);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RichText(
      text: TextSpan(
        text: _month.toUpperCase(),
        style: TextStyle(
            color: Colors.black26.withOpacity(0.80), fontSize: 15.0, fontFamily: 'VarelaRound',
            fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(
            text: " $_date",
            style: TextStyle(
              color: Colors.black26.withOpacity(0.50),
              fontSize:18.0,
              fontWeight: FontWeight.bold,
              decorationStyle: TextDecorationStyle.wavy,
            ),
          ),
        ],
      ),
    );
  }
}
