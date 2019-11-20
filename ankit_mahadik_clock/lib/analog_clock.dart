import 'dart:async';

import 'package:ankit_mahadik_clock/circle_progress_second.dart';
import 'package:ankit_mahadik_clock/lines_painter.dart';
import 'package:ankit_mahadik_clock/time_lines_painter.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;
  final Color bgColor = Colors.white;

  double _secondPercent() => _now.second / 60;

  double _minutesPercent() => _now.minute / 60;

  double _hoursPercent() => _now.hour / 12;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.

      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hms().format(DateTime.now());

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                  height: 310,
                  width: 310,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26.withOpacity(0.04),
                            blurRadius: 10,
                            offset: Offset(-12, 0),
                            spreadRadius: 2),
                        BoxShadow(
                            color: Colors.black26.withOpacity(0.04),
                            blurRadius: 10,
                            offset: Offset(12, 0),
                            spreadRadius: 5),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomPaint(
                      painter: LinesPainter(),
                      child: Container(
                        margin: const EdgeInsets.all(32.0),
                        decoration: BoxDecoration(
                            color: bgColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26.withOpacity(0.03),
                                  blurRadius: 5,
                                  spreadRadius: 8),
                            ]),
                        child: CustomPaint(
                          painter: TimeLinesPainter(
                            lineType: LineType.minute,
                            tick: _minutesPercent(),
                          ),
                          child: CustomPaint(
                            painter: TimeLinesPainter(
                              lineType: LineType.hour,
                              tick: _hoursPercent(),
                            ),
                            child: CustomPaint(
                              painter: TimeLinesPainter(
                                  lineType: LineType.second,
                                  tick: _secondPercent()),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
            Center(
              child: CircleProgressSecond(
                radius: 125.0,
                dotColor: Colors.pink,
                dotRadius: 5.0,
                shadowWidth: 3.0,
                progress: _secondPercent(),
                progressChanged: (value) {
                  setState(() {
                    print("Progress...$value");
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
