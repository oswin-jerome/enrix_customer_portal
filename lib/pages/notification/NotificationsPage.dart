import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:customer_portal/Controllers/NotificationController.dart';
import 'package:customer_portal/Models/Notification.dart' as mod;
import 'package:customer_portal/Models/Notification.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/pages/report/reportListPage.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  DateFormat format = DateFormat('dd MMMM yyyy, hh:MM a');
  List<mod.Notification> _notifications = [];
  int lastPage = 1;
  int currentPage = 1;
  bool isLoading = false;
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    getData();
    NotificationController().removePendingNotifications();
  }

  getData() async {
    //print("c: $currentPage | l: $lastPage");

    if (lastPage < currentPage) {
      //print("Byeee");
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
      _refreshController.loadNoData();
      return;
    }

    if (currentPage == 1)
      setState(() {
        isLoading = true;
      });
    //print("################################");

    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);
    // return;
    Dio()
        .get(
      Base.baseUrl + "notifications?page=$currentPage",
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer " + _token!
        },
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    )
        .then(
      (value) {
        lastPage = int.tryParse(value.data['last_page'].toString()) ?? 1;
        setState(() {
          if (isLoading) {
            _notifications =
                notificationFromJson(jsonEncode(value.data['data']));
          } else {
            _notifications +=
                notificationFromJson(jsonEncode(value.data['data']));
          }
          isLoading = false;
        });
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
      },
    );

    currentPage++;
  }

  _refresh() {
    currentPage = 1;
    lastPage = 1;
    getData();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      opacity: 0.3,
      color: Colors.black,
      progressIndicator: CustomLoader(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Notifications"),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullUp: true,
          onRefresh: _refresh,
          onLoading: getData,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _notifications.length,
            itemBuilder: (bc, i) {
              return NotificationCard(
                notification: _notifications[i],
              );
            },
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  DateFormat format = DateFormat('dd MMMM yyyy, hh:MM a');
  mod.Notification notification;
  NotificationCard({required this.notification});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //print(notification.type);
        if (notification.type == "App\\Notifications\\ReportNotification") {
          //print("true");
          Get.to(
            () => ReportListPage(
              title: notification.data['report_type'],
              propertyId: int.parse(notification.data['property_id']),
              propertyName: notification.data['property_name'] ?? "",
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: notification.readAt != null ? Colors.white : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 5,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "${notification.data['title']}",
              style: TextStyle(
                  color: Colors.grey[800], fontWeight: FontWeight.bold),
            ),
            notification.data['description'] == null
                ? Text("")
                : Text(
                    "${notification.data['description']}",
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${format.format(notification.createdAt!)}",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

//  Card(
//         color: Colors.transparent,
//         elevation: 0,
//         child: ListTile(
//           title: Text("${notification.data['message']}"),
//           subtitle: Text("${format.format(notification.createdAt)}"),
//         ),
//       )
