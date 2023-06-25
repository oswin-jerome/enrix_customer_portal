import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:dio/dio.dart' as ddio;
import 'package:customer_portal/Models/Customer.dart';
import 'package:customer_portal/pages/auth/loginPage.dart';
import 'package:customer_portal/pages/dashboard.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/route_manager.dart' as route_manager;

class UserController extends GetxController {
  var customer = new Customer().obs;
  var email = "".obs;
  @override
  void onInit() {
    super.onInit();
    getData();
    getCustomer();
  }

  getData() {
    var box = Hive.box("store");
    if (box.get("user") != null) {
      //print("User-----------------");
      customer.value =
          Customer.fromJson(jsonDecode(jsonEncode(box.get("user"))));
    }
    //print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  }

  getCustomer() async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);
    if (_token == null) return;
    // return;
    ddio.Dio()
        .get(
      Base.baseUrl + "customer",
      options: ddio.Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer " + _token
        },
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    )
        .then(
      (value) {
        //print(value.data);
        if (value.statusCode == 200) {
          var box = Hive.box("store");

          customer.value = Customer.fromJson(value.data['user']);
          box.put("user", value.data['user']);
          email.value = "sdsdsd";
          update();
        }
      },
    );
  }

  logout() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.clear();
    var storeBox = Hive.box("store");
    storeBox.clear();
    route_manager.Get.offAll(
      LoginPage(),
    );
  }

  Future<ddio.Response> login(ddio.FormData data) async {
    ddio.Response res = await ddio.Dio().post(
      Base.baseUrl + "login",
      data: data,
      options: ddio.Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    var storeBox = Hive.box("store");
    if (res.statusCode == 200) {
      SharedPreferences _pref = await SharedPreferences.getInstance();

      if (res.data['user']['email_verified_at'] == null) {
        return res;
      }

      _pref.setString("token", res.data['token']);
      storeBox.put("token", res.data['token']);
      storeBox.put("user", res.data['user']);
      getData();
      route_manager.Get.offAll(
        Dashboard(),
      );
    }

    return res;
  }

  Future<ddio.Response> register(
      {@required name, @required email, @required password}) async {
    ddio.Response res = await ApiHelper().dio.post(
          Base.baseUrl + "register",
          data: ddio.FormData.fromMap(
            {
              "name": name,
              "email": email,
              "password": password,
            },
          ),
          options: ddio.Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );

    return res;
  }
}
