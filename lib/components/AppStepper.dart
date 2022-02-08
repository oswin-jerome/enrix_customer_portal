import 'package:flutter/material.dart';
import 'package:status_change/status_change.dart';

// ignore: must_be_immutable
class AppStepper extends StatelessWidget {
  List steps = [
    {"label": "Register", "completed": true},
    {"label": "Upload", "completed": true},
    {"label": "Verify", "completed": false},
    {"label": "Acrivated", "completed": false},
  ];
  // GlobalKey _key = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: StatusChange.tileBuilder(
        // theme: StatusChangeThemeData(
        //   direction: Axis.horizontal,
        //   connectorTheme: ConnectorThemeData(space: 1.0, thickness: 1.0),
        // ),
        builder: StatusChangeTileBuilder.connected(
          itemCount: steps.length,
          itemWidth: (_) => MediaQuery.of(context).size.width / steps.length,
          contentWidgetBuilder: (c, i) {
            return Text("");
          },
          nameWidgetBuilder: (bc, i) => Text(steps[i]['label']),
          lineWidgetBuilder: (i) {
            if (steps[i]['completed'] == true) {
              return DecoratedLineConnector(
                thickness: 5,
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              );
            }
            return DecoratedLineConnector(
              thickness: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            );
          },
          indicatorWidgetBuilder: (bx, i) {
            if (steps[i]['completed'] == true) {
              return DotIndicator(
                size: 30,
                // borderWidth: 2.0,
                child: Icon(Icons.check, color: Colors.white),
                color: Colors.green,
              );
            }
            return OutlinedDotIndicator(
              size: 30,
              borderWidth: 1.0,
              color: Colors.grey,
            );
          },
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
