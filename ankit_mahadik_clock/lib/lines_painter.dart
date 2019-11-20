import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LinesPainter extends CustomPainter {
  final Paint linePainter;

  final double lineHeight = 8;
  final int maxLines = 60;

  LinesPainter()
      : linePainter = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();

    final radius = size.width / 2;

    List.generate(maxLines, (i) {
      var newRadius = (i % 5 == 0) ? radius - 15 : radius - 5;
      canvas.drawLine(Offset(0, radius), Offset(0, newRadius), linePainter);
      canvas.rotate(2 * pi / maxLines);
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
