import 'package:flutter/material.dart';

const defaultChartValueStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const defaultLegendStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

const List<Color> defaultColorList = [
  Color(0xFFff7675),
  Color(0xFF74b9ff),
  Color(0xFF55efc4),
  Color(0xFFffeaa7),
  Color(0xFFa29bfe),
  Color(0xFFfd79a8),
  Color(0xFFe17055),
  Color(0xFF00b894),
];

Color getColor(List<Color> colorList, int index) {
  if (index > (colorList.length - 1)) {
    final newIndex = index % (colorList.length - 1);
    return colorList.elementAt(newIndex);
  }
  return colorList.elementAt(index);
}

Future navigateWithFade(context, Widget widget) {
  return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, ani, secani) => widget,
        transitionDuration: Duration(milliseconds: 200),
        transitionsBuilder: (ctx, ani, secani, child) => Transform.scale(
          scale: Tween(begin: 1.1, end: 1.0).transform(ani.value),
          child: Opacity(
            opacity: Tween(begin: 0.0, end: 1.0).transform(ani.value),
            child: child,
          ),
        ),
      ));
}

Future navigateWithFadeReplace(context, Widget widget) {
  return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, ani, secani) => widget,
        transitionDuration: Duration(milliseconds: 200),
        transitionsBuilder: (ctx, ani, secani, child) => Transform.scale(
          scale: Tween(begin: 1.1, end: 1.0).transform(ani.value),
          child: Opacity(
            opacity: Tween(begin: 0.0, end: 1.0).transform(ani.value),
            child: child,
          ),
        ),
      ));
}
