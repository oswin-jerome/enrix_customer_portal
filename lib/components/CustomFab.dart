import 'package:customer_portal/Controllers/FabController.dart';
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
                          firstChild: Text(widget.label),
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
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 0),
                        blurRadius: 5,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}
