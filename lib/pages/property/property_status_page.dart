import 'package:delayed_display/delayed_display.dart';
import 'package:customer_portal/Models/Property.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class PropertyStatusPage extends StatelessWidget {
  final Property property;
  PropertyStatusPage({required this.property});
  List<Map<String, dynamic>> status = [
    {
      "title": "Initiated",
      "description": "We have recieved your property registration request",
      "status": false,
    },
    {
      "title": "Inspection Scheduled",
      "description":
          "We have recieved scheduled a property inspection, Our associate will get in touch with you soon...",
      "status": false,
    },
    {
      "title": "Approved",
      "description":
          "We have recieved scheduled a property inspection, Our associate will get in touch with you soon...",
      "status": false,
    },
    {
      "title": "Agreement signed",
      "description":
          "We have recieved scheduled a property inspection, Our associate will get in touch with you soon...",
      "status": false,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        title: Text('Property Status'),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(15),
        itemBuilder: (bc, i) {
          return DelayedDisplay(
            delay: Duration(milliseconds: (i) * 500),
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: property.stepsApproved() > i
                          ? Color(0xFF52D25C)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status[i]["title"],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          property.approvalSteps()[i],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (bc, i) {
          return DelayedDisplay(
            delay: Duration(milliseconds: (i + 1) * 250),
            child: Row(
              children: [
                SizedBox(width: 8),
                Container(
                  height: 50,
                  width: 2,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          );
        },
        itemCount: status.length,
      ),
    );
  }
}
