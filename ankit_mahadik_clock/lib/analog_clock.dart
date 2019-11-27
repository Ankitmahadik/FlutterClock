import 'dart:async';
import 'dart:math';

import 'package:ankit_mahadik_clock/circle_progress_second.dart';
import 'package:ankit_mahadik_clock/date_text_helper.dart';
import 'package:ankit_mahadik_clock/lines_painter.dart';
import 'package:ankit_mahadik_clock/second_hand.dart';
import 'package:ankit_mahadik_clock/time_lines_painter.dart';
import 'package:ankit_mahadik_clock/utils.dart';
import 'package:flutter/services.dart';
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
  Timer _timer;
  double prevTick = 0.0;
  final Color bgColor = Colors.white;
  Color currentColor = Color(0xFF6A1B9A);
  int currentColorIndex = 0;

  double _height = 0.0, _width = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      prevTick = _secondPercent();
      if (_minutesPercent() != (DateTime.now().minute / 60)) {
        currentColor = Utils().getColorsArray()[_getCurrentIndex()];
      }
      _now = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          children: <Widget>[
            buildClockWidget(),
            buildSecondProgressWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTempBorderWidget() {
    return Positioned(
      top: _width / 4.7,
      right: _width / 2.5,
      child: Container(
          height: 90,
          width: 90,
          child: CustomPaint(
            painter: LinesPainter(Colors.black38, DialLineType.date),
          )),
    );
  }

  Widget _buildDateBorderWidget() {
    return Positioned(
      top: _width / 4.7,
      left: _width / 2.5,
      child: Container(
          height: 90,
          width: 90,
          child: CustomPaint(
            painter: LinesPainter(Colors.black38, DialLineType.date),
          )),
    );
  }

  Widget _buildMeridiemDialWidget() {
    return Positioned(
      top: _width / 2.5,
      left: _width / 4.5,
      child: Container(
        height: 90,
        width: 90,
        child: CustomPaint(
          painter: LinesPainter(Color(0xFF64B5F6), DialLineType.meridiem),
          child: CustomPaint(
            painter: TimeLinesPainter(
              lineType: LineType.meridiem,
              tick: _hoursMeridiem(),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildTempWidget() {
    return Positioned(
      top: _width / 4.3,
      right:   _width / 2.4,
      child: Container(
        height: 80,
        width: 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text("${widget.model.temperature}\n${widget.model.unitString}",textAlign: TextAlign.center,style: TextStyle(
                color: Colors.black26.withOpacity(0.50),
                fontSize: 14.0,
                fontFamily: 'VarelaRound',
                fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
  Widget _buildDateWidget() {
    return Positioned(
      top: _width / 4.3,
      left: _width / 2.4,
      child: Container(
        height: 80,
        width: 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: DateTextHelper(
              _getDate(),
              _getMonth(),
              _getDay(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSecondProgressWidget() {
    return Center(
      child: CircleProgressSecond(
        radius: 137.0,
        dotColor: currentColor,
        dotRadius: 5.0,
        shadowWidth: 8.0,
        progress: _secondPercent(),
        prevProgress: prevTick,
      ),
    );
  }

  Widget buildClockWidget() {
    return Center(
      child: Container(
          height: 350,
          width: 350,
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
            child: Center(
              child: Container(
                width: 350,
                height: 350,
                child: CustomPaint(
                  painter: LinesPainter(currentColor, DialLineType.clock),
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
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Stack(
                        children: <Widget>[
                          _buildTempBorderWidget(),
                          _buildTempWidget(),
                          _buildDateBorderWidget(),
                          _buildDateWidget(),
                          _buildMeridiemDialWidget(),
                          Container(
                            width: 350,
                            height: 350,
                            child: CustomPaint(
                              painter: TimeLinesPainter(
                                lineType: LineType.hour,
                                tick: _hoursPercent(),
                              ),
                              child: CustomPaint(
                                painter: TimeLinesPainter(
                                  lineType: LineType.minute,
                                  tick: _minutesPercent(),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 350,
                            height: 350,
                            child: SecondHand(
                                currentTick: _secondPercent(),
                                prevTick: prevTick),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  String _getDate() {
    return DateFormat("dd").format(DateTime.now());
  }

  String _getMonth() {
    return DateFormat("MMM").format(DateTime.now());
  }

  String _getDay() {
    return DateFormat("EEE").format(DateTime.now());
  }

  int _getCurrentIndex() {
    if (currentColorIndex < Utils().getColorsArray().length - 1) {
      currentColorIndex++;
    } else {
      currentColorIndex = 0;
    }
    return currentColorIndex;
  }

  double _secondPercent() => _now.second / 60;

  double _minutesPercent() => _now.minute / 60;

  double _hoursPercent() => _now.hour / 12;

  double _hoursMeridiem() {
    var hour24 = int.parse(DateFormat("H").format(DateTime.now()));
    return _now.hour / 24;
  }
}
