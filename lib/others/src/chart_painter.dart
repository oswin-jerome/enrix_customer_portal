import 'dart:math' as math;

import 'package:customer_portal/others/src/utils.dart';
import 'package:flutter/material.dart';
import './pie_chart.dart';

class PieChartPainter extends CustomPainter {
  List<Paint> _paintList = [];
  List<double>? _subParts;
  List<String>? _subTitles;
  double _total = 0;
  double _totalAngle = math.pi * 2;

  final TextStyle? chartValueStyle;
  final Color? chartValueBackgroundColor;
  final double? initialAngle;
  final bool? showValuesInPercentage;
  final bool? showChartValues;
  final bool? showChartValuesOutside;
  final int? decimalPlaces;
  final bool? showChartValueLabel;
  final ChartType? chartType;
  final String? centerText;
  final Function? formatChartValues;
  final double? strokeWidth;

  double _prevAngle = 0;

  PieChartPainter(
    double angleFactor,
    this.showChartValues,
    this.showChartValuesOutside,
    List<Color> colorList, {
    this.chartValueStyle,
    this.chartValueBackgroundColor,
    List<double> values = const [],
    List<String> titles = const [],
    this.initialAngle,
    this.showValuesInPercentage,
    this.decimalPlaces,
    this.showChartValueLabel,
    this.chartType,
    this.centerText,
    this.formatChartValues,
    this.strokeWidth,
  }) {
    for (int i = 0; i < values.length; i++) {
      final paint = Paint()..color = getColor(colorList, i);
      if (chartType == ChartType.ring) {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = strokeWidth!;
      }
      _paintList.add(paint);
    }
    _totalAngle = angleFactor * math.pi * 2;
    _subParts = values;
    _subTitles = titles;
    _total = values.fold(0, (v1, v2) => v1 + v2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.width < size.height ? size.width : size.height;
    _prevAngle = this.initialAngle! * math.pi / 180;
    for (int i = 0; i < _subParts!.length; i++) {
      // TODO: testing
      Paint p2 = Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      // canvas.drawArc(
      //   new Rect.fromLTWH(10.0, 10.0, side - 20, size.height - 20),
      //   _prevAngle,
      //   (((_totalAngle) / _total) * _subParts[i]),
      //   chartType == ChartType.disc ? true : false,
      //   p2,
      // );
      // pointing line
      final radius2 = showChartValuesOutside! ? (side / 1.4) + 16 : side / 3;
      final x2 = (radius2) *
          math.cos(
              _prevAngle + ((((_totalAngle) / _total) * _subParts![i]) / 2));
      final y2 = (radius2) *
          math.sin(
              _prevAngle + ((((_totalAngle) / _total) * _subParts![i]) / 2));
      final radius3 = showChartValuesOutside! ? (side / 2) + 16 : side / 3;
      final x3 = (radius3) *
          math.cos(
              _prevAngle + ((((_totalAngle) / _total) * _subParts![i]) / 2));
      final y3 = (radius3) *
          math.sin(
              _prevAngle + ((((_totalAngle) / _total) * _subParts![i]) / 2));

      canvas.drawLine(Offset((side / 2 + x3), (side / 2 + y3)),
          Offset((side / 2 + x2), (side / 2 + y2)), p2);

      canvas.drawArc(
        new Rect.fromLTWH(0.0, 0.0, side, size.height),
        _prevAngle,
        (((_totalAngle) / _total) * _subParts![i]),
        chartType == ChartType.disc ? true : false,
        _paintList[i],
      );
      Paint p = Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16;
      canvas.drawArc(
        new Rect.fromLTWH(10.0, 10.0, side - 20, size.height - 20),
        _prevAngle,
        (((_totalAngle) / _total) * _subParts![i]),
        chartType == ChartType.disc ? true : false,
        p,
      );

      // Text radios
      final radius = showChartValuesOutside! ? (side / 1.3) + 16 : side / 3;
      final x = (radius) *
          math.cos(
              _prevAngle + ((((_totalAngle) / _total) * _subParts![i]) / 2));
      final y = (radius) *
          math.sin(
              _prevAngle + ((((_totalAngle) / _total) * _subParts![i]) / 2));
      if (_subParts!.elementAt(i).toInt() != 0) {
        final value = formatChartValues != null
            ? formatChartValues!(_subParts!.elementAt(i))
            : _subParts!.elementAt(i).toStringAsFixed(this.decimalPlaces!);

//        final name = showValuesInPercentage
//            ? (((_subParts.elementAt(i) / _total) * 100)
//                    .toStringAsFixed(this.decimalPlaces) +
//                '%')
//            : value;
        final name = showValuesInPercentage!
            ? (((_subParts!.elementAt(i) / _total) * 100)
                    .toStringAsFixed(this.decimalPlaces!) +
                '%')
            : _subTitles!.elementAt(i);

        if (showChartValues!) {
          final name = showValuesInPercentage!
              ? (((_subParts!.elementAt(i) / _total) * 100)
                      .toStringAsFixed(this.decimalPlaces!) +
                  '%')
              : value;

          _drawName(canvas, name, x, y, side);
        }
      }
      _prevAngle = _prevAngle + (((_totalAngle) / _total) * _subParts![i]);
    }

    if (centerText != null && centerText!.trim().isNotEmpty) {
      _drawCenterText(canvas, side);
    }
  }

  void _drawCenterText(Canvas canvas, double side) {
    _drawName(canvas, centerText!, 0, 0, side);
  }

  void _drawName(Canvas canvas, String name, double x, double y, double side) {
    TextSpan span = TextSpan(
      style: chartValueStyle,
      text: name,
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    if (showChartValueLabel!) {
      //Draw text background box
      final rect = Rect.fromCenter(
        center: Offset((side / 2 + x), (side / 2 + y)),
        width: tp.width + 6,
        height: tp.height + 4,
      );
      final rRect = RRect.fromRectAndRadius(rect, Radius.circular(4));
      final paint = Paint()
        ..color = chartValueBackgroundColor ?? Colors.transparent
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rRect, paint);
    }
    //Finally paint the text above box
    tp.paint(
      canvas,
      new Offset(
        (side / 2 + x) - (tp.width / 2),
        (side / 2 + y) - (tp.height / 2),
      ),
    );
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) =>
      oldDelegate._totalAngle != _totalAngle;
}
