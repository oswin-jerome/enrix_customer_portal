import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(right: 10),
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            width: 90,
            child: Text(
              text,
              // overflow: TextOverflow.ellipsis,
              overflow: TextOverflow.visible,

              style: TextStyle(
                fontSize: 12,
                height: 1.0,
                fontWeight: FontWeight.normal,
                color: textColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
