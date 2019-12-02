import 'dart:async';

import 'package:ankit_mahadik_clock/circle_border_widget.dart';
import 'package:ankit_mahadik_clock/circle_progress_second.dart';
import 'package:ankit_mahadik_clock/colors_util.dart';
import 'package:ankit_mahadik_clock/date_text_helper.dart';
import 'package:ankit_mahadik_clock/lines_painter.dart';
import 'package:ankit_mahadik_clock/second_hand.dart';
import 'package:ankit_mahadik_clock/time_lines_painter.dart';
import 'package:ankit_mahadik_clock/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';

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
  Color bgColor = Colors.white;
  Color textColor = Colors.white;
  Color shadowColor = Colors.black26.withOpacity(0.04);
  Color currentColor = Color(0xFF6A1B9A);
  int currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
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
        currentColor = _getCurrentColor();
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
    checkThemeMode(context);
    return Stack(
      children: <Widget>[
        buildClockWidget(),
        buildSecondProgressWidget(),
      ],
    );
  }

  Widget _buildTempBorderWidget() {
    return Positioned(
      top: 70,
      left: 15,
      child: Container(
        height: 75,
        width: 75,
        child: const CircleBorderWidget(),
      ),
    );
  }

  Widget _buildDateBorderWidget() {
    return Positioned(
      top: 70,
      right: 15,
      child: Container(
        height: 75,
        width: 75,
        child: const CircleBorderWidget(),
      ),
    );
  }

  Widget _buildMeridiemDialWidget() {
    return Positioned(
      top: 135,
      left: 75,
      child: Container(
        height: 70,
        width: 70,
        child: CustomPaint(
          painter: LinesPainter(Color(0xFF64B5F6), DialLineType.meridiem),
          child: CustomPaint(
            painter: TimeLinesPainter(
                lineType: LineType.meridiem,
                tick: _hoursMeridiem(),
                context: context),
          ),
        ),
      ),
    );
  }

  Widget _buildTempWidget() {
    return Positioned(
      top: 80,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 65,
        width: 65,
        child: Center(
          child: Text(
              "${widget.model.temperature.toStringAsFixed(2)}\n${widget.model.unitString}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textColor,
                  fontSize: 12.0,
                  fontFamily: 'VarelaRound',
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildDateWidget() {
    return Positioned(
      top: 90,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 65,
        width: 65,
        child: DateTextHelper(),
      ),
    );
  }

  Widget buildSecondProgressWidget() {
    return Center(
      child: CircleProgressSecond(
        radius: 110.0,
        dotColor: currentColor,
        dotRadius: 3.0,
        shadowWidth: 8.0,
        progress: _secondPercent(),
        prevProgress: prevTick,
      ),
    );
  }

  Widget buildClockWidget() {
    return Center(
      child: Container(
          height: 280,
          width: 280,
          padding: const EdgeInsets.all(8.0),
          decoration:
              BoxDecoration(color: bgColor, shape: BoxShape.circle, boxShadow: [
            BoxShadow(
                color: shadowColor,
                blurRadius: 10,
                offset: const Offset(-12, 0),
                spreadRadius: 2),
            BoxShadow(
                color: shadowColor,
                blurRadius: 10,
                offset: const Offset(12, 0),
                spreadRadius: 5),
          ]),
          child: Container(
            width: 280,
            height: 280,
            child: CustomPaint(
              painter: LinesPainter(currentColor, DialLineType.clock),
              child: Container(
                margin: const EdgeInsets.all(23.0),
                decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: shadowColor, blurRadius: 5, spreadRadius: 8),
                    ]),
                child: Stack(
                  children: <Widget>[
                    _buildTempBorderWidget(),
                    _buildTempWidget(),
                    _buildDateBorderWidget(),
                    _buildDateWidget(),
                    _buildMeridiemDialWidget(),
                    _buildHourMinuteHandWidget(),
                    _buildSecondHandWidget(),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildSecondHandWidget() {
    return Container(
      width: 280,
      height: 280,
      child: SecondHand(currentTick: _secondPercent(), prevTick: prevTick),
    );
  }

  Widget _buildHourMinuteHandWidget() {
    return Container(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: TimeLinesPainter(
          lineType: LineType.hour,
          tick: _hoursPercent(),
          context: context,
        ),
        child: CustomPaint(
          painter: TimeLinesPainter(
              lineType: LineType.minute,
              tick: _minutesPercent(),
              context: context),
        ),
      ),
    );
  }

  Color _getCurrentColor() {
    List<Color> array = Utils().isDarkMode(context)
        ? ColorsUtil().getColorsDarkArray()
        : ColorsUtil().getColorsLightArray();
    if (currentColorIndex < array.length - 1) {
      currentColorIndex++;
    } else {
      currentColorIndex = 0;
    }
    return array[currentColorIndex];
  }

  double _secondPercent() => _now.second / 60;

  double _minutesPercent() => _now.minute / 60;

  double _hoursPercent() => _now.hour / 12;

  double _hoursMeridiem() {
    return _now.hour / 24;
  }

  void checkThemeMode(BuildContext context) {
    if (Utils().isDarkMode(context)) {
      bgColor = ColorsUtil().clockBGDark;
      shadowColor = ColorsUtil().shadowColorDark;
      textColor = ColorsUtil().textColorDark;
    } else {
      bgColor = ColorsUtil().clockBGLight;
      shadowColor = ColorsUtil().shadowColorLight;
      textColor = ColorsUtil().textColorLight;
    }
  }
}
