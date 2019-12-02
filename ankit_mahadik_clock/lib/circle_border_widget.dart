import 'package:ankit_mahadik_clock/lines_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleBorderWidget extends StatelessWidget {
  const CircleBorderWidget();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinesPainter(Colors.grey.withOpacity(0.8), DialLineType.date),
    );
  }
}

