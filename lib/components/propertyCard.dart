import 'dart:ui';

import 'package:customer_portal/Models/Property.dart';
import 'package:customer_portal/others/pie_chart.dart';
import 'package:customer_portal/pages/files/file_system_page.dart';
import 'package:customer_portal/pages/finance/financeReport.dart';
import 'package:customer_portal/pages/property/property_status_page.dart';
import 'package:customer_portal/pages/report/reportCategoryPage.dart';
import 'package:customer_portal/pages/requests/tasksPage.dart';
import 'package:customer_portal/pages/timeLinePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// ignore: must_be_immutable
class PropertyCard extends StatefulWidget {
  Property property;
  PropertyCard({required this.property, Key? key}) : super(key: key);

  @override
  _PropertyCardState createState() => _PropertyCardState(property: property);
}

class _PropertyCardState extends State<PropertyCard>
    with SingleTickerProviderStateMixin {
  Property property;
  _PropertyCardState({required this.property});
  late AnimationController _animationController;
  late Animation<double> lineAnimation;
  // double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    lineAnimation = Tween(
      begin: 0.0,
      end: 3.0,
    ).animate(_animationController)
      ..addListener(() {
        //print("animating===================");
        // setState(() {
        //   _progress = lineAnimation.value;
        // });
      });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (bc, ani, ani2) => TimeLinePage(widget.property.id!),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.0, end: 1.0);
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double cellWidth = (MediaQuery.of(context).size.width - 30) / 4;
    return Theme(
      data: Theme.of(context)
          .copyWith(shadowColor: Colors.black.withOpacity(0.4)),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.property.isApproved()
                        ? Text(
                            widget.property.propertyName ?? "No name set",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          )
                        : Text(
                            widget.property.propertyName.toString() + "",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                    !widget.property.isApproved()
                        ? Container(
                            child: Text(
                              "Signup in-progress",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Colors.grey),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black.withOpacity(0.05),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 8),
                            child: RatingBar.builder(
                              initialRating: widget.property.rating!.toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              updateOnDrag: false,
                              itemCount: 5,
                              unratedColor: Colors.grey[500],
                              itemSize: 18,
                              itemPadding: EdgeInsets.symmetric(
                                horizontal: 3.0,
                              ),
                              itemBuilder: (context, _) => Image.asset(
                                "assets/star.png",
                              ),
                              onRatingUpdate: (rating) {
                                //print(rating);
                              },
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              !widget.property.isApproved()
                  ? Container()
                  : Container(
                      // color: Colors.grey,
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              // Navigator.of(context).push(_createRoute());
                              navigateWithFade(
                                  context, TimeLinePage(widget.property.id!));
                            },
                            child: Container(
                              width: cellWidth,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/logos/eye.png",
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Logs")
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    color: Colors.black.withOpacity(0.1),
                                    width: 2),
                              ),
                            ),
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (v) => FinanceReportPage(
                              //       propertyId: widget.property.id,
                              //       propertyName: widget.property.propertyName,
                              //     ),
                              //   ),
                              // );

                              navigateWithFade(
                                  context,
                                  FinanceReportPage(
                                    propertyId: widget.property.id,
                                    propertyName: widget.property.propertyName,
                                  ));
                            },
                            child: Container(
                              width: cellWidth,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/logos/chart.png",
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Finance")
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    color: Colors.black.withOpacity(0.1),
                                    width: 2),
                              ),
                            ),
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (v) => ReportCategoryPage(
                              //       propertyId: widget.property.id,
                              //       propertyName: widget.property.propertyName,
                              //     ),
                              //   ),
                              // );
                              navigateWithFade(
                                context,
                                FileSystemPage(
                                  propertyId: widget.property.id,
                                ),
                              );
                            },
                            child: Container(
                              color: Colors.white,
                              child: Container(
                                width: cellWidth,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/logos/doc.png",
                                      height: 23,
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text("Docs")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    color: Colors.black.withOpacity(0.1),
                                    width: 2),
                              ),
                            ),
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              navigateWithFade(
                                  context,
                                  TasksPage(
                                    propertyID: widget.property.id,
                                    propertyName: widget.property.propertyName,
                                  ));
                            },
                            child: Stack(
                              // overflow: Overflow.visible,
                              children: [
                                Container(
                                  width: cellWidth,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 16,
                                        child: Image.asset(
                                          "assets/logos/tick.png",
                                          height: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      Text("Tasks")
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: -8,
                                  right: 16,
                                  child: widget.property.taskCount! < 1
                                      ? Container()
                                      : Container(
                                          height: 16,
                                          width: 16,
                                          padding: EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                            color:
                                                HSLColor.fromColor(Colors.red)
                                                    .withSaturation(0.7)
                                                    .withLightness(0.7)
                                                    .toColor(),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Center(
                                            child: Text(
                                              widget.property.taskCount
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              widget.property.isApproved()
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        navigateWithFade(
                          context,
                          PropertyStatusPage(
                            property: widget.property,
                          ),
                        );
                      },
                      child: Container(
                        // color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TweenAnimationBuilder(
                            tween: Tween(
                                begin: 0.0, end: property.stepsApproved()),
                            duration: Duration(milliseconds: 300),

                            builder: (bc, num d, ch) {
                              //print("Steps: ${property.stepsApproved()}");
                              return CustomPaint(
                                painter: ProgressPainter(
                                    progress: ((33 * (d)) - 16) + 0.0,
                                    steps: [
                                      {
                                        "label": "Initiated",
                                        "point": 0,
                                        "completed": widget.property
                                                .statusPropertyDetails !=
                                            null,
                                      },
                                      {
                                        "label": "Inspection Scheduled",
                                        "point": 0.33,
                                        "completed":
                                            widget.property.statusInspection !=
                                                null,
                                      },
                                      {
                                        "label": "Approved",
                                        "point": 0.66,
                                        "completed":
                                            widget.property.statusApproval !=
                                                null,
                                      },
                                      {
                                        "label": "Agreement Signed",
                                        "point": 1,
                                        "completed":
                                            widget.property.statusAgreement !=
                                                null,
                                      },
                                    ]),
                                size: Size(300.0, 50),
                              );
                            },
                            // child:
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  double? progress;
  List? steps;
  ProgressPainter({this.progress, this.steps});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw a straight line
    //print(size);
    double _ofset = 20;
    var start = Offset(0, _ofset);
    var end = Offset(size.width, _ofset);
    var lineBrush = Paint()..color = Colors.grey;
    lineBrush..strokeWidth = 5.0;
    lineBrush.strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, lineBrush);
    // Draw progress line
    var start1 = Offset(0, _ofset);
    if (progress! < 0) {
      progress = 0;
    }
    var end1 = Offset((size.width * (progress! / 100)), _ofset);
    var lineBrush1 = Paint()..color = Color(0xffA9D18E);
    lineBrush1..strokeWidth = 8.0;
    lineBrush1.strokeCap = StrokeCap.round;
    lineBrush1.shader =
        LinearGradient(colors: [Color(0xffA9D18E), Color(0xff7BC5C1)])
            .createShader(Rect.fromLTWH(0, 0, 700, 5));

    canvas.drawLine(start1, end1, lineBrush1);

    // Draw steps
    steps?.forEach((element) {
      //
      var circleBrush = Paint();
      circleBrush..strokeWidth = 8.0;
      circleBrush.strokeCap = StrokeCap.round;
      if (element['completed']) {
        circleBrush.color = Color(0xffA9D18E);
      } else {
        circleBrush.color = Colors.grey;
      }
      canvas.drawCircle(
          Offset((size.width * element["point"]), _ofset), 6, circleBrush);

      // Draw tick
      if (element['completed']) {
        canvas.drawCircle(
            Offset((size.width * element["point"]), _ofset), 8, circleBrush);
        final icon = Icons.check;
        TextPainter iconPainter = TextPainter(textDirection: TextDirection.ltr);
        iconPainter.text = TextSpan(
            // text: String.fromCharCode(icon.codePoint),
            style: TextStyle(
                color: Colors.grey[800], fontFamily: icon.fontFamily));
        iconPainter.layout();
        iconPainter.paint(
            canvas, Offset((size.width * element["point"]) - 8, _ofset - 7));
      }
      // Draw text
      final textPainter = TextPainter(
          text: TextSpan(
            text: element["label"],
            style: TextStyle(color: Colors.grey, fontSize: 9),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr)
        ..layout(maxWidth: 50);
      if (steps?.indexOf(element) == 0) {
        textPainter.paint(
            canvas, Offset((size.width * element["point"]) - 15, _ofset + 20));
      } else if (steps?.indexOf(element) == steps!.length - 1) {
        textPainter.paint(
            canvas, Offset((size.width * element["point"]) - 30, _ofset + 20));
      } else {
        textPainter.paint(
            canvas, Offset((size.width * element["point"]) - 20, _ofset + 20));
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//  Card(
//             elevation: 5,
//             margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     "Property Name",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 0,
//                   ),
//                   AppStepper(),
//                 ],
//               ),
//             ),
//           ),
