import 'dart:convert';

import 'package:customer_portal/Models/ActivityLogGroup.dart';
import 'package:customer_portal/pages/activity/ActivityImageViewer.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ActivityDetailsPage extends StatefulWidget {
  final Datum activityLog;
  ActivityDetailsPage({required this.activityLog});
  @override
  _ActivityDetailsPageState createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        title: widget.activityLog.isPriority != 0
            ? Row(
                children: [
                  Text(widget.activityLog.activityType!),
                  Container(
                    // height: 10,
                    margin: EdgeInsets.only(left: 5),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: getColor("priority").withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Priority",
                      style:
                          TextStyle(fontSize: 12, color: getColor("priority")),
                    ),
                  ),
                ],
              )
            : Text(widget.activityLog.activityType!),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildItem("Activity Type", widget.activityLog.activityType!),
              buildItem("Analysis", widget.activityLog.analysis!),
              widget.activityLog.followUp != "null"
                  ? buildItem(
                      "Follow up", widget.activityLog.followUp.toString())
                  : Container(),
              widget.activityLog.recommentation != null
                  ? buildItem(
                      "Recomendations", widget.activityLog.recommentation ?? "")
                  : Container(),
              Card(
                child: Row(
                  children: [],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.activityLog.imageFiles == null
                    ? Text("")
                    : Text(
                        "Images",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
              GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8),
                  itemCount: widget.activityLog.imageFiles == null
                      ? 0
                      : jsonDecode(widget.activityLog.imageFiles!).length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  itemBuilder: (bx, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (bc) => ActivityImageViewer(
                                url: Base.baseUrlWithoutApi +
                                    "activity_images/${jsonDecode(widget.activityLog.imageFiles!)[i]}",
                              ),
                              fullscreenDialog: true,
                            ));
                      },
                      child: Hero(
                        tag: Base.baseUrlWithoutApi +
                            "activity_images/${jsonDecode(widget.activityLog.imageFiles!)[i]}",
                        child: Image.network(
                          Base.baseUrlWithoutApi +
                              "activity_images/${jsonDecode(widget.activityLog.imageFiles!)[i]}",
                          headers: {"Keep-Alive": "Keep-Alive"},
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Card buildItem(String key, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              key,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Html(
              data: value,
              style: {
                "table": Style(
                  fontSize: FontSize(14),
                ),
                "td": Style(
                  fontSize: FontSize(14),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  padding: EdgeInsets.all(8),
                ),
              },
            ),
            // Text(
            //   value,
            // ),
          ],
        ),
      ),
    );
  }
}
