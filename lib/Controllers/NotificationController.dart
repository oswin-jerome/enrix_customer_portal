import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:customer_portal/Models/Notification.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  // ignore: deprecated_member_use
  var notifications = <Notification>[].obs;
  var pending = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // getData();
    getPending();
    Timer.periodic(Duration(minutes: 10), (time) {
      //print("############# Checking for new notifications ###############");
      getPending();
    });
  }

  removePendingNotifications() async {
    //print("Reading,,,,,,,,,,,,,,,,,,");
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);
    // return;
    Dio()
        .get(
          Base.baseUrl + "notifications/read",
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
        .then((value) => {});
  }

  getData() async {
    //print("################################");

    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);
    // return;
    Dio()
        .get(
      Base.baseUrl + "notifications",
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
        //print(value);
        notifications.value =
            notificationFromJson(jsonEncode(value.data['data']));
      },
    );
  }

  getPending() async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    // //print(_token);
    if (_token == null) return;
    // return;
    ApiHelper()
        .dio
        .get(
          "notifications/unread",
        )
        .then(
      (value) {
        pending.value = notificationFromJson(jsonEncode(value.data)).length;
      },
    );
  }
}
