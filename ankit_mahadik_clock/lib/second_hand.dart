import 'dart:math';

import 'package:flutter/material.dart';

class SecondHand extends StatefulWidget {
  final double currentTick;
  final double prevTick;

  SecondHand({this.currentTick, this.prevTick});

  @override
  State<StatefulWidget> createState() => _SecondHandState();
}

class _SecondHandState extends State<SecondHand> with TickerProviderStateMixin {
  double _progress;
  Animation<double> _animation;
  AnimationController _controller;
  var sec = DateTime.now().second;

  @override
  void initState() {
    super.initState();
    _progress = (2 * pi * widget.currentTick);
    animateHand();
  }

  @override
  void didUpdateWidget(SecondHand oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (DateTime.now().second != sec) {
      sec = DateTime.now().second;
      animateHand();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: LinePainter(progress: _progress));
  }

  void animateHand() {
    final tickIncrement = 0.100;
    //Extra value added to match speed
    final beginPos = (2 * pi * widget.prevTick + tickIncrement);
    var endPos = (2 * pi * widget.currentTick + tickIncrement);
    if (beginPos > endPos) {
      //Extra value added to Switch last animation smoothly on minute change
      endPos = (2 * pi * widget.prevTick + tickIncrement) + 0.1055;
    }
    _controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animation = Tween(begin: beginPos, end: endPos).animate(_controller)
      ..addListener(() {
        setState(() {
          _progress = _animation.value;
        });
      });

    _controller.forward();
  }
}

class LinePainter extends CustomPainter {
  Paint _paint, _centerPainter;
  double progress;

  LinePainter({this.progress}) {
    _paint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    _centerPainter = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.translate(radius, radius);
    canvas.rotate(progress);
    canvas.drawCircle(Offset(0.0, 0.0), radius / 25, _centerPainter);
    canvas.drawPath(_secondPath(radius), _paint);
    _centerPainter.color = Colors.redAccent;
    canvas.drawCircle(Offset(0.0, 0.0), radius / 40, _centerPainter);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }

  Path _secondPath(double radius) {
    return Path()
      ..moveTo(0.0, radius - (radius / 1.2))
      ..lineTo(0.0, -(radius))
      ..close();
  }
}
