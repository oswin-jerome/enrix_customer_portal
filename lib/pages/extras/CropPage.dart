import 'package:flutter/material.dart';
import 'package:time_range/time_range.dart';

class TimePickerPage extends StatefulWidget {
  @override
  _TimePickerPageState createState() => _TimePickerPageState();
}

class _TimePickerPageState extends State<TimePickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: TimeRange(
        fromTitle: Text(
          'From',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        toTitle: Text(
          'To',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        titlePadding: 10,
        textStyle: TextStyle(
            fontWeight: FontWeight.normal, color: Colors.black87, fontSize: 14),
        activeTextStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        borderColor: Colors.grey,
        backgroundColor: Colors.transparent,
        activeBackgroundColor: Colors.grey,
        firstTime: TimeOfDay(hour: 6, minute: 30),
        lastTime: TimeOfDay(hour: 22, minute: 00),
        timeStep: 30,
        timeBlock: 30,
        onRangeCompleted: (range) {
          Navigator.pop(context, range);
        },
      ),
    );
  }
}
