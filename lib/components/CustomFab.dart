import 'package:customer_portal/Controllers/FabController.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomFab extends StatefulWidget {
  Widget icon;
  String label;
  VoidCallback onPress;
  CustomFab({
    required this.icon,
    required this.label,
    required this.onPress,
  });

  @override
  _CustomFabState createState() => _CustomFabState();
}

class _CustomFabState extends State<CustomFab> {
  bool ishandOver = false;
  @override
  Widget build(BuildContext context) {
    FabController c = Get.find(tag: "fab");
    print(c.isOpen);
    return GetX<FabController>(
        global: true,
        tag: "fab",
        init: c,
        builder: (ctrl) {
          return GestureDetector(
              onTap: widget.onPress,
              onTapDown: (details) {
                setState(() {
                  ishandOver = true;
                });
              },
              onTapUp: (details) {
                setState(() {
                  ishandOver = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  ishandOver = false;
                });
              },
              child: Transform.scale(
                scale: ishandOver ? 1.05 : 1.0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: ctrl.isOpen.value
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: ctrl.isOpen.value
                              ? null
                              : EdgeInsets.only(left: 3, right: 3),
                          child: widget.icon,
                        ),
                        AnimatedCrossFade(
                          firstChild: Text(
                            widget.label,
                            style: TextStyle(color: Colors.white),
                          ),
                          secondChild: Text(""),
                          crossFadeState: ctrl.isOpen.value
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: Duration(
                            milliseconds: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  height: 50,
                  width: ctrl.isOpen.value ? 100 : 50,
                  decoration: BoxDecoration(
                    // color: Theme.of(context).primaryColor,
                    color: accent,

                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        ishandOver
                            ? accent
                            : HSLColor.fromColor(accent)
                                .withLightness(0.4)
                                .toColor(),
                        accent,
                        accent,
                        accent,
                        accent,
                      ],
                      stops: [
                        0.10,
                        0.02,
                        0.3,
                        0.3,
                        0.3,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(0.2),
                        offset: Offset(0, 0),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                      // BoxShadow(
                      //   color: HSLColor.fromColor(accent)
                      //       .withLightness(0.4)
                      //       .toColor(),
                      //   blurRadius: 0,
                      //   spreadRadius: -0,
                      //   offset: Offset(0, ishandOver ? 0 : 4),
                      // ),
                    ],
                  ),
                ),
              ));
        });
  }
}
