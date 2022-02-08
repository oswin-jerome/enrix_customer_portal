import 'dart:convert';

import 'package:customer_portal/Models/ActivityLogGroup.dart';
import 'package:customer_portal/others/pie_chart.dart';
import 'package:customer_portal/pages/activity/activityDetailsPage.dart';
import 'package:customer_portal/utils/Base.dart' as base;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ActivityLogCard extends StatelessWidget {
  Datum log;
  DateFormat format = DateFormat('dd MMM yyyy');
  ActivityLogCard({required this.log});
  Color textColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    // if (log.isPriority == 0) {
    textColor = Colors.grey[850]!;
    // }
    if (log.imageFiles != null) {
      // //print(jsonDecode(log.imageFiles) as List);
    }
    return InkWell(
      onTap: () {
        navigateWithFade(
            context,
            ActivityDetailsPage(
              activityLog: log,
            ));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (c) => ActivityDetailsPage(
        //       activityLog: log,
        //     ),
        //   ),
        // );
      },
      child: Hero(
        tag: log.id!,
        child: Container(
          margin: EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 4),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: Offset(3, 3),
                  spreadRadius: 0,
                  blurRadius: 5,
                )
              ]),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        log.activityType!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: log.followUp != "null"
                          ? Text(
                              format.format(DateTime.parse(log.followUp!)),
                              style: TextStyle(
                                color: textColor,
                              ),
                            )
                          : Text(""),
                    )
                  ],
                ),
                Divider(
                  color: Colors.black,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Html(
                        data: log.analysis,
                        shrinkWrap: true,
                        style: {
                          "*": Style(
                            fontSize: FontSize(14.0),
                            padding: EdgeInsets.zero,
                            color: textColor,
                          ),
                        },
                      ),
                    )

                    // Expanded(
                    //   child: Text(
                    //     log.analysis,
                    //     maxLines: 2,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: TextStyle(color: textColor),
                    //   ),
                    // ),
                    // Icon(
                    //   Icons.keyboard_arrow_right_outlined,
                    //   size: 28,
                    // )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 32,
                        // color: Colors.grey,
                        child: log.imageFiles == null
                            ? Container()
                            : Stack(
                                children: <Widget>[] +
                                    (jsonDecode(log.imageFiles!) as List)
                                        .map((e) => Positioned(
                                            left: (jsonDecode(log.imageFiles!)
                                                        as List)
                                                    .indexOf(e) *
                                                18.0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          60)),
                                              margin: EdgeInsets.only(right: 6),
                                              padding: EdgeInsets.all(3),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                  base.Base.baseUrlWithoutApi +
                                                      "activity_images/$e",
                                                  height: 27,
                                                  width: 27,
                                                  headers: {
                                                    "Keep-Alive": "Keep-Alive"
                                                  },
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )))
                                        .toList() +
                                    [
                                      if (jsonDecode(log.imageFiles!).length >
                                          3) ...[
                                        Positioned(
                                            left: 3 * 18.0,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60)),
                                                margin:
                                                    EdgeInsets.only(right: 6),
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 27,
                                                  width: 27,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                        "+${jsonDecode(log.imageFiles!).length - 3}"),
                                                  ),
                                                )))
                                      ]
                                    ],
                              ),
                      ),
                      log.isPriority == 0
                          ? (log.recommentation == null
                              ? Text("")
                              : Text(
                                  "Read more...",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.end,
                                ))
                          : Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color:
                                    base.getColor("priority").withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "Priority",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: base.getColor("priority"),
                                ),
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
