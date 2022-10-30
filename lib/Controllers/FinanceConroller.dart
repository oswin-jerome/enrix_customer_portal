import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:customer_portal/Models/Finance.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinanceConroller extends GetxController {
  DateFormat format = DateFormat('yyyy-MM-dd');
  RxString name = "sd".obs;
  Finance? incomes;
  Rx<Finance> incomeList = Finance().obs;
  Rx<Finance> expenseList = Finance().obs;
  Rx<Finance> otherList = Finance().obs;
  RxMap barExpense = {}.obs;
  var dataLoading = false.obs;
  String from = "";
  String to = "";
  getData({
    int? propertyID,
    String? dataToLoad,
    String? type,
    String? from_c,
    String? to_c,
  }) async {
    // String from = "";
    // String to = "";
    dataLoading.value = true;

    if (dataToLoad == "custom") {
      from = from_c!;
      to = to_c!;
    }
    if (dataToLoad == "this_month") {
      DateTime firstDay =
          DateTime.utc(DateTime.now().year, DateTime.now().month, 1);

      DateTime lastDay = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month + 1,
      ).subtract(Duration(days: 1));

      from = format.format(firstDay);
      to = format.format(lastDay);
    }

    if (dataToLoad == "this_year") {
      DateTime firstDay = DateTime.utc(DateTime.now().year, 1, 1);

      DateTime lastDay = DateTime.utc(DateTime.now().year, 12, 31);

      from = format.format(firstDay);
      to = format.format(lastDay);
    }

    if (dataToLoad == "previous_year") {
      DateTime firstDay = DateTime.utc(DateTime.now().year - 1, 1, 1);

      DateTime lastDay = DateTime.utc(DateTime.now().year - 1, 12, 31);

      from = format.format(firstDay);
      to = format.format(lastDay);
    }

    if (dataToLoad == "previous_month") {
      DateTime firstDay =
          DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 1);

      DateTime lastDay = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
      ).subtract(Duration(days: 1));

      from = format.format(firstDay);
      to = format.format(lastDay);
    }
    String trm = type!.toLowerCase();
    Map<String, dynamic> _params = {
      "from": from,
      "to": to,
      "finance_type": trm,
    };
    if (propertyID != null) {
      _params.addAll({"property_id": propertyID});
    }
    dio.Response response = await ApiHelper().dio.get(
          "finance",
          queryParameters: _params,
        );
    print(response.data["data"]);
    if (type == "Income") {
      incomeList.value = financeFromJson(jsonEncode((response.data['data'])));
    } else if (type == "Expense") {
      incomes = financeFromJson(jsonEncode((response.data['data'])));
      expenseList.value = financeFromJson(jsonEncode((response.data['data'])));
    } else {
      otherList.value = financeFromJson(jsonEncode((response.data['data'])));
    }

    dataLoading.value = false;
  }

  Future<Finance> getIncome(
      {int? propertyID, String? dataToLoad, String? type}) async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    String from = "";
    String to = "";

    if (dataToLoad == "this_month") {
      DateTime firstDay =
          DateTime.utc(DateTime.now().year, DateTime.now().month, 1);

      DateTime lastDay = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month + 1,
      ).subtract(Duration(days: 1));

      from = format.format(firstDay);
      to = format.format(lastDay);
    }

    if (dataToLoad == "this_year") {
      DateTime firstDay = DateTime.utc(DateTime.now().year, 1, 1);

      DateTime lastDay = DateTime.utc(DateTime.now().year, 12, 31);

      from = format.format(firstDay);
      to = format.format(lastDay);
    }

    if (dataToLoad == "previous_year") {
      DateTime firstDay = DateTime.utc(DateTime.now().year - 1, 1, 1);

      DateTime lastDay = DateTime.utc(DateTime.now().year - 1, 12, 31);

      from = format.format(firstDay);
      to = format.format(lastDay);
    }

    if (dataToLoad == "previous_month") {
      DateTime firstDay =
          DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 1);

      DateTime lastDay = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
      ).subtract(Duration(days: 1));

      from = format.format(firstDay);
      to = format.format(lastDay);
    }
    String trm = type!.toLowerCase();
    dio.Response response = await ApiHelper().dio.get(
      "property/$propertyID/finance_$trm",
      queryParameters: {"from": from, "to": to},
    );
    // print(response.data);
    return financeFromJson(jsonEncode((response.data['data'])));
  }

  getBarData() async {
    dio.Response response = await ApiHelper().dio.get(
          "bardata",
        );
    print(response.data['data']);
    if (response.data['data'].length > 0) {
      barExpense.value = response.data['data'];
    }
  }
}
