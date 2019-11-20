import 'dart:math';

import 'package:flutter/material.dart';

typedef ProgressChanged<double> = void Function(double value);

num degToRad(num deg) => deg * (pi / 180.0);

num radToDeg(num rad) => rad * (180.0 / pi);

class CircleProgressSecond extends StatefulWidget {
  final double radius;
  final double progress;
  final double dotRadius;
  final double shadowWidth;
  final Color shadowColor;
  final Color dotColor;
  final Color dotEdgeColor;
  final Color ringColor;

  final ProgressChanged progressChanged;

  const CircleProgressSecond({
    Key key,
    @required this.radius,
    @required this.dotRadius,
    @required this.dotColor,
    this.shadowWidth = 2.0,
    this.shadowColor = Colors.black12,
    this.ringColor = const Color(0XFFFFFF),
    this.dotEdgeColor = Colors.white,
    this.progress,
    this.progressChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CircleProgressState();
}

class _CircleProgressState extends State<CircleProgressSecond>
    with SingleTickerProviderStateMixin {
  AnimationController progressController;
  bool isValidTouch = false;
  final GlobalKey paintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    progressController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    if (widget.progress != null) progressController.value = widget.progress;
    progressController.addListener(() {
      if (widget.progressChanged != null)
        widget.progressChanged(progressController.value);
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(CircleProgressSecond oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.progress != null) progressController.value = widget.progress;
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.radius * 2.0;
    final size = new Size(width, width);
    return Container(
      alignment: FractionalOffset.center,
      child: CustomPaint(
        key: paintKey,
        size: size,
        painter: ProgressPainter(
            dotRadius: widget.dotRadius,
            shadowWidth: widget.shadowWidth,
            shadowColor: widget.shadowColor,
            ringColor: widget.ringColor,
            dotColor: widget.dotColor,
            dotEdgeColor: widget.dotEdgeColor,
            progress: progressController.value),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double dotRadius;
  final double shadowWidth;
  final Color shadowColor;
  final Color dotColor;
  final Color dotEdgeColor;
  final Color ringColor;
  final double progress;

  ProgressPainter({
    this.dotRadius,
    this.shadowWidth = 2.0,
    this.shadowColor = Colors.black12,
    this.ringColor = const Color(0XFFF7F7FC),
    this.dotColor,
    this.dotEdgeColor = const Color(0XFFF5F5FA),
    this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    final Offset offsetCenter = Offset(center, center);
    final double drawRadius = size.width * 0.5 - dotRadius;
    final angle = 360.0 * progress;
    final double radians = degToRad(angle);

    final double radiusOffset = dotRadius * 0.4;
    final double outerRadius = center - radiusOffset;
    final double innerRadius = center - dotRadius * 2 + radiusOffset;

    Path path = Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(Rect.fromCircle(center: offsetCenter, radius: outerRadius)),
        Path()
          ..addOval(
              Rect.fromCircle(center: offsetCenter, radius: innerRadius)));
    canvas.drawShadow(path, shadowColor, 4.0, true);

    // draw ring.
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = ringColor
      ..strokeWidth = (outerRadius - innerRadius);
    canvas.drawCircle(offsetCenter, drawRadius, ringPaint);

    final Color currentDotColor = Color.alphaBlend(
        dotColor.withOpacity(0.7 + (0.3 * progress)), Colors.white);

    // draw progress.
    if (progress > 0.0) {
      final progressWidth = outerRadius - innerRadius + radiusOffset;
      final double offset = asin(progressWidth * 0.5 / drawRadius);
      if (radians > offset) {
        canvas.save();
        canvas.translate(0.0, size.width);
        canvas.rotate(degToRad(-90.0));
        final Gradient gradient = new SweepGradient(
          endAngle: radians,
          colors: [
            Colors.white,
            currentDotColor,
          ],
        );
        final Rect arcRect =
            Rect.fromCircle(center: offsetCenter, radius: drawRadius);
        final progressPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = progressWidth
          ..shader = gradient.createShader(arcRect);
        canvas.drawArc(arcRect, offset, radians - offset, false, progressPaint);
        canvas.restore();
      }
    }

    // draw dot.
    final double dx = center + drawRadius * sin(radians);
    final double dy = center - drawRadius * cos(radians);
    final dotPaint = Paint()..color = currentDotColor;
    canvas.drawCircle(new Offset(dx, dy), dotRadius, dotPaint);
    dotPaint
      ..color = dotEdgeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = dotRadius * 0.3;
    canvas.drawCircle(new Offset(dx, dy), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
