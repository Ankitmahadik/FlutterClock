import 'dart:math';

import 'package:ankit_mahadik_clock/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TimeLinesPainter extends CustomPainter {
  final Paint linePainter;
  final Paint hourPainter;
  final Paint minutePainter;
  final Paint centerPainter;
  final double tick;
  final LineType lineType;
  final BuildContext context;

  TimeLinesPainter({this.tick, this.lineType, this.context})
      : linePainter = Paint()
          ..color = Colors.black54
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8,
        minutePainter = Paint()
          ..color = Colors.blueGrey
          ..style = PaintingStyle.fill
          ..strokeWidth = 1.8,
        hourPainter = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill
          ..strokeWidth = 2.8,
        centerPainter = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.fill
          ..strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    canvas.translate(radius, radius);
    hourPainter.color =
        Utils().isDarkMode(this.context) ? Color(0xffdbd8e3) : Colors.black;
    minutePainter.color =
    Utils().isDarkMode(this.context) ? Color(0xfffbe3b9) : Colors.blueGrey;

    switch (lineType) {
      case LineType.hour:
        canvas.rotate(2 * pi * tick);
        canvas.drawPath(_hourPath(radius), hourPainter);
        canvas.drawShadow(_hourPath(radius), Colors.black, 6.0, false);
        break;
      case LineType.minute:
        canvas.rotate(2 * pi * tick);
        canvas.drawPath(_minutePath(radius), minutePainter);
        canvas.drawShadow(_minutePath(radius), Colors.black, 6.0, false);
        break;
      case LineType.meridiem:
        linePainter.color =
        Utils().isDarkMode(this.context) ? Color(0xfffbe3b9) : Colors.blueGrey;
        canvas.rotate(2 * pi * tick);
        canvas.drawCircle(Offset(0.0, 0.0), radius / 30, linePainter);
        canvas.drawPath(_secondPath(radius), linePainter);
        centerPainter.color = Colors.redAccent;
        canvas.drawCircle(Offset(0.0, 0.0), radius / 25, centerPainter);
        break;
    }
  }

  Path _hourPath(double radius) {
    return Path()
      ..moveTo(-0.8, -radius / 1.7)
      ..lineTo(-2.5, -radius / 3.5)
      ..lineTo(-1.0, 4.0)
      ..lineTo(1.0, 4.0)
      ..lineTo(2.5, -radius / 3.5)
      ..lineTo(0.8, -radius / 1.7)
      ..close();
  }

  Path _minutePath(double radius) {
    return Path()
      ..moveTo(-1.0, -radius / 1.15)
      ..lineTo(-2.5, -radius / 2.5)
      ..lineTo(-1.0, 3.0)
      ..lineTo(1.0, 3.0)
      ..lineTo(2.5, -radius / 2.5)
      ..lineTo(1.0, -radius / 1.15)
      ..close();
  }

  Path _secondPath(double radius) {
    return Path()
      ..moveTo(0.0, radius - (radius / 1.2))
      ..lineTo(0.0, -(radius - (radius / 2.0)))
      ..close();
  }

  @override
  bool shouldRepaint(TimeLinesPainter oldDelegate) {
    return oldDelegate.tick != tick;
  }
}

enum LineType { hour, minute, meridiem }
