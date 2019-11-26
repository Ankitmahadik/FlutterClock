import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LinesPainter extends CustomPainter {
  final double lineHeight = 8;
  final int maxLines = 60;
  final Color currentColor;
  final Paint linePainter;
  final DialLineType dialLineType;

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
        hourSize =15;
        secondSize =5;
        break;
      case DialLineType.date:
        hourSize =5;
        secondSize =5;
        break;
    }
    canvas.save();
    linePainter.color = currentColor;
    final radius = size.width / 2;

    List.generate(maxLines, (i) {
      var newRadius = (i % 5 == 0) ? radius - hourSize : radius - secondSize;
      canvas.drawLine(Offset(0, radius), Offset(0, newRadius), linePainter);
      canvas.rotate(2 * pi / maxLines);
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum DialLineType { clock, date }
