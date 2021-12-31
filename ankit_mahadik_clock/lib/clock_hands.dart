import 'dart:math';

import 'package:ankit_mahadik_clock/utils.dart';
import 'package:flutter/material.dart';

class ClockHands extends StatefulWidget {
  final double currentTick;
  final double prevTick;

  ClockHands({required this.currentTick, required this.prevTick});

  @override
  State<StatefulWidget> createState() => _ClockHandsState();
}

class _ClockHandsState extends State<ClockHands> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  var sec = DateTime.now().second;

  static const double MINUTES_IN_HOUR = 60.0;
  static const double SECONDS_IN_MINUTE = 60.0;
  static const double HOURS_IN_CLOCK = 12.0;
  late double seconds, minutes, hour;

  @override
  void initState() {
    super.initState();
    animateHand();
  }

  @override
  void didUpdateWidget(ClockHands oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (DateTime.now().second != sec) {
      sec = DateTime.now().second;
      animateHand();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => CustomPaint(
          painter: LinePainter(
            progress: _animation.value,
            context: context,
            seconds: seconds,
            minutes: minutes,
            hour: hour,
          ),
        ),
      ),
    );
  }

  void animateHand() {
    seconds = DateTime.now().second / SECONDS_IN_MINUTE;
    minutes = (DateTime.now().minute + seconds) / MINUTES_IN_HOUR;
    hour = (DateTime.now().hour + minutes) / HOURS_IN_CLOCK;

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
    _animation = Tween(begin: beginPos, end: endPos).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class LinePainter extends CustomPainter {
  late Paint _paint, _centerPainter, hourPainter, minutePainter;
  final double progress;
  final BuildContext context;

  final double seconds;
  final double minutes;

  final double hour;

  static const double BASE_SIZE = 320.0;
  static const double HAND_PIN_HOLE_SIZE = 8.0;
  static const double STROKE_WIDTH = 3.0;

  LinePainter(
      {required this.progress,
      required this.context,
      required this.seconds,
      required this.minutes,
      required this.hour}) {
    _paint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    _centerPainter = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;
    minutePainter = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.8;
    hourPainter = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.8;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _centerPainter.color =
        Utils().isDarkMode(this.context) ? Color(0xfffbe3b9) : Colors.blueGrey;
    final radius = size.width / 2;
    canvas.translate(radius, radius);

    hourPainter.color =
        Utils().isDarkMode(this.context) ? Color(0xffdbd8e3) : Colors.black;
    minutePainter.color =
        Utils().isDarkMode(this.context) ? Color(0xfffbe3b9) : Colors.blueGrey;

    canvas.rotate(2 * pi * hour);
    canvas.drawPath(_hourPath(radius), hourPainter);
    canvas.drawShadow(_hourPath(radius), Colors.black, 6.0, false);

    canvas.rotate(2 * pi * minutes - (2 * pi * hour));
    canvas.drawPath(_minutePath(radius), minutePainter);
    canvas.drawShadow(_minutePath(radius), Colors.black, 6.0, false);

    canvas.rotate(progress - (2 * pi * minutes));
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
}
