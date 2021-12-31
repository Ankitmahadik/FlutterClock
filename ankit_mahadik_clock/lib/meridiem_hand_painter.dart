import 'dart:math';

import 'package:ankit_mahadik_clock/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MeridiemHandPainter extends CustomPainter {
  final Paint linePainter;
  final Paint centerPainter;
  final double tick;
  final BuildContext context;

  MeridiemHandPainter({required this.tick,required  this.context})
      : linePainter = Paint()
          ..color = Colors.black54
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8,
        centerPainter = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.fill
          ..strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.translate(radius, radius);
    linePainter.color =
        Utils().isDarkMode(this.context) ? Color(0xfffbe3b9) : Colors.blueGrey;
    canvas.rotate(2 * pi * tick);
    canvas.drawCircle(Offset(0.0, 0.0), radius / 30, linePainter);
    canvas.drawPath(_meridiemPath(radius), linePainter);
    centerPainter.color = Colors.redAccent;
    canvas.drawCircle(Offset(0.0, 0.0), radius / 25, centerPainter);
  }

  Path _meridiemPath(double radius) {
    return Path()
      ..moveTo(0.0, radius - (radius / 1.2))
      ..lineTo(0.0, -(radius - (radius / 2.0)))
      ..close();
  }

  @override
  bool shouldRepaint(MeridiemHandPainter oldDelegate) {
    return oldDelegate.tick != tick;
  }
}
