import 'package:customer_portal/Models/Task.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TaskCard extends StatefulWidget {
  Task task;
  TaskCard({required this.task});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  DateFormat format = DateFormat('dd MMMM yyyy');
  bool isExpanded = false;
  Color getColor(String text) {
    switch (text) {
      case "open":
        return Colors.red;
        break;
      case "rejected":
        return Colors.red;
        break;
      case "on process":
        return Colors.orange;
        break;
      case "closed":
        return Colors.green;
        break;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(8),
          //   bottomRight: Radius.circular(8),
          // ),

          borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.task.discription,
                          overflow: TextOverflow.ellipsis,
                          maxLines: isExpanded ? 3 : 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: getColor(widget.task.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.task.status,
                          style: TextStyle(
                              fontSize: 12,
                              color: getColor(widget.task.status)),
                        ),
                      ),
                    ],
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        format.format(DateTime.parse(widget.task.createdAt)),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: widget.task.replies.length > 0
                            ? (isExpanded
                                ? Icon(
                                    FontAwesomeIcons.chevronUp,
                                    color: Colors.grey,
                                    size: 14,
                                  )
                                : Icon(
                                    FontAwesomeIcons.chevronDown,
                                    color: Colors.grey,
                                    size: 14,
                                  ))
                            : Container(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Progress",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Container(
                        height: 10,
                        margin: EdgeInsets.only(left: 10, right: 5),
                        width: 100,
                        child: CustomPaint(
                          painter:
                              ProgressPainter(progress: widget.task.progress),
                        ),
                      ),
                    ],
                  ),
                  !isExpanded
                      ? Container()
                      : (widget.task.replies.length < 1
                          ? Container()
                          : ListView.builder(
                              padding: EdgeInsets.only(top: 10),
                              itemCount: widget.task.replies.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (bc, iw) {
                                return Container(
                                  child: ListTile(
                                    dense: true,
                                    title: Text(
                                        widget.task.replies[iw].description),
                                    subtitle: Text(
                                      format.format(
                                        DateTime.parse(
                                          widget.task.replies[iw].createdAt,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  int progress;
  ProgressPainter({required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    var start1 = Offset(0, 4);

    var start = Offset(0, 4);
    var end = Offset(size.width, 4);
    var lineBrush = Paint()..color = Colors.grey[200]!;
    lineBrush..strokeWidth = 8.0;
    lineBrush.strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, lineBrush);

    var end1 = Offset((size.width * (progress / 100)), 4);
    var lineBrush1 = Paint()..color = Color(0xffA9D18E);
    lineBrush1..strokeWidth = 8.0;
    lineBrush1.strokeCap = StrokeCap.round;
    lineBrush1.shader =
        LinearGradient(colors: [Color(0xffA9D18E), Color(0xff7BC5C1)])
            .createShader(Rect.fromLTWH(0, 0, 700, 5));

    canvas.drawLine(start1, end1, lineBrush1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
