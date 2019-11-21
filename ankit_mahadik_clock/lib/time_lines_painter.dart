import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TimeLinesPainter extends CustomPainter {
  final Paint linePainter;
  final Paint hourPainter;
  final Paint minutePainter;
  final Paint centerPainter;
  final double tick;
  final LineType lineType;

  TimeLinesPainter({this.tick, this.lineType })
      : linePainter = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.9,
        minutePainter = Paint()
          ..color = Colors.black38
          ..style = PaintingStyle.fill
          ..strokeWidth = 4.2,
        hourPainter = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill
          ..strokeWidth = 5.2,
        centerPainter = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.fill
          ..strokeWidth = 2.9;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    canvas.translate(radius, radius);

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
      case LineType.second:
        canvas.rotate(2 * pi * tick);
        canvas.drawPath(_secondPath(radius), linePainter);
        canvas.drawCircle(Offset(0.0, 0.0), radius / 20, centerPainter);
        canvas.drawShadow(_secondPath(radius), Colors.black26, 100, true);
        break;
    }
  }

  Path _hourPath(double radius) {
    return Path()
      ..moveTo(-1.5, -radius / 1.8)
      ..lineTo(-4, -radius / 3.6)
      ..lineTo(-2.0, 5.0)
      ..lineTo(2.0, 5.0)
      ..lineTo(4, -radius / 3.6)
      ..lineTo(1.5, -radius / 1.8)
      ..close();
  }

  Path _minutePath(double radius) {
    return Path()
      ..moveTo(-1.5, -radius / 1.2)
      ..lineTo(-3.5, -radius / 3.2)
      ..lineTo(-2.0, 5.0)
      ..lineTo(2.0, 5.0)
      ..lineTo(3.5, -radius / 3.2)
      ..lineTo(1.5, -radius / 1.2)
      ..close();
  }

  Path _secondPath(double radius) {
    return Path()
      ..lineTo(0, -(radius + 10))
      ..close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum LineType { hour, minute, second }
