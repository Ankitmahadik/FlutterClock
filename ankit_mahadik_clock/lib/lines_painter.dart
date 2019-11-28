import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LinesPainter extends CustomPainter {
  final double lineHeight = 8;
  final int maxLines = 60;
  final Color currentColor;
  final Paint linePainter;
  final DialLineType dialLineType;
  static const double BASE_SIZE = 300.0;

  LinesPainter(this.currentColor, this.dialLineType)
      : linePainter = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    var hourSize = 0, secondSize = 0;
    switch (dialLineType) {
      case DialLineType.clock:
        hourSize = 15;
        secondSize = 5;
        break;
      case DialLineType.date:
        hourSize = 4;
        secondSize = 4;
        break;
      case DialLineType.meridiem:
        hourSize = 4;
        secondSize = 4;
        break;
    }
    canvas.save();
    linePainter.color = currentColor;
    if (dialLineType != DialLineType.clock) {
      linePainter.strokeWidth = 1.25;
    }
    final radius = size.width / 2;
    if (dialLineType != DialLineType.meridiem) {
      List.generate(maxLines, (i) {
        var newRadius = (i % 5 == 0) ? radius - hourSize : radius - secondSize;
        canvas.drawLine(Offset(0, radius), Offset(0, newRadius), linePainter);
        canvas.rotate(2 * pi / maxLines);
      });
    } else {
      List.generate(maxLines, (i) {
        var newRadius = radius - hourSize;
        linePainter.strokeWidth = (i % 5 == 0) ? 2.0 : 0.8;
        if (i < 30) {
          linePainter.color = Colors.red;
        } else {
          linePainter.color = Colors.grey;
        }
        canvas.drawLine(Offset(0, radius), Offset(0, newRadius), linePainter);
        canvas.rotate(2 * pi / maxLines);
      });
      double scaleFactor = size.shortestSide / BASE_SIZE;

      TextStyle style = TextStyle(
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
          fontSize: 16.0 * scaleFactor * 2.0);
      TextSpan span12 = new TextSpan(style: style, text: "AM");
      var textPainter = new TextPainter(
          text: span12,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      TextPainter tp12 = textPainter;
      tp12.layout();
      tp12.paint(canvas,
          size.center(Offset(-(size / 1.68).height, -(size / 1.15).height)));

      style = TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16.0 * scaleFactor * 2.0);
      TextSpan span13 = new TextSpan(style: style, text: "PM");
      TextPainter tp13 = new TextPainter(
          text: span13,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp13.layout();
      tp13.paint(canvas,
          size.center(Offset(-(size / 1.68).height, -(size / 4.0).height)));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum DialLineType { clock, date, meridiem }
