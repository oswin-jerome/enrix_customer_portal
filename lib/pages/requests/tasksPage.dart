import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:customer_portal/Models/Task.dart';
import 'package:customer_portal/components/AppDrawer.dart';
import 'package:customer_portal/components/TaskCard.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/pages/dashboard.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksPage extends StatefulWidget {
  int? propertyID;
  String propertyName;
  TasksPage({this.propertyID, required this.propertyName});
  @override
  _TasksPageState createState() =>
      _TasksPageState(propertyID: propertyID, propertyName: propertyName);
}

class _TasksPageState extends State<TasksPage> {
  int? propertyID;
  String propertyName;
  _TasksPageState({this.propertyID, required this.propertyName});
  bool _isLoading = false;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _getTasks();
  }

  _getTasks() async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);
    setState(() {
      _isLoading = true;
    });
    ApiHelper()
        .dio
        .get(
          "tasks" + (propertyID != null ? "/$propertyID" : ""),
        )
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value.statusCode == 200) {
        setState(() {
          _tasks = taskFromJson(jsonEncode(value.data['data']));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      opacity: 0.3,
      color: Colors.black,
      progressIndicator: CustomLoader(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(fontFamily: GoogleFonts.raleway().fontFamily),
              children: [
                TextSpan(
                  text: "Tasks",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "   " + widget.propertyName,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Column(
              children: [],
            )
          ],
        ),
        drawer: propertyID == null ? AppDrawer() : null,
        body: _tasks.length > 0
            ? ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: _tasks.length,
                itemBuilder: (bc, i) {
                  return TaskCard(
                    task: _tasks[i],
                  );
                })
            : Container(),
      ),
    );
  }
}

// subtitle: Text(format.format(DateTime.parse(task.createdAt))),
