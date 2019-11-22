import 'dart:math';

import 'package:flutter/material.dart';

class SecondHand extends StatefulWidget {
  final double currentTick;
  double prevTick;

  SecondHand({this.currentTick, this.prevTick});

  @override
  State<StatefulWidget> createState() => _SecondHandState();
}

class _SecondHandState extends State<SecondHand> with TickerProviderStateMixin {
  double _progress;
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _progress = (2 * pi * widget.currentTick);
    animateHand();
  }

  @override
  void didUpdateWidget(SecondHand oldWidget) {
    super.didUpdateWidget(oldWidget);
    animateHand();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: LinePainter(progress: _progress));
  }

  void animateHand() {
    _controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animation = Tween(
            begin: (2 * pi * widget.prevTick),
            end: (2 * pi * widget.currentTick))
        .animate(_controller)
          ..addListener(() {
            setState(() {
              if (DateTime.now().second == 0) {
                print(
                    "_animation.value..${_animation.value}...${widget.prevTick}.....${widget.currentTick}");
              }
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
      ..strokeWidth = 2.9;
    _centerPainter = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.9;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.translate(radius, radius);
    canvas.rotate(progress);
    canvas.drawCircle(Offset(0.0, 0.0), radius / 20, _centerPainter);
    canvas.drawPath(_secondPath(radius), _paint);
    _centerPainter.color = Colors.redAccent;
    canvas.drawCircle(Offset(0.0, 0.0), radius / 30, _centerPainter);
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
