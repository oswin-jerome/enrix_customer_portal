import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:customer_portal/Controllers/FinanceConroller.dart';
import 'package:customer_portal/Models/Finance.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ExportController extends GetxController {
  exportCSV(
      {List<String>? exportableCategories,
      List<Finance>? finance,
      List<int>? selectedTypes}) async {
    // var finance = Get.put(FinanceConroller(), tag: "finance");

    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("Date");
    row.add("Type");
    row.add("Category");
    row.add("Amount");
    row.add("Description");
    rows.add(row);

    selectedTypes?.forEach((element) {
      print(element);
      List<Entry>? entryList = finance?[element].entries;
      for (int i = 0; i < entryList!.length; i++) {
        if (!exportableCategories!.contains(entryList[i].category)) {
          List<dynamic> row = [];
          row.add(Base.formaterr.format(entryList[i].date!));
          if (element == 0) {
            row.add("Income");
          } else if (element == 1) {
            row.add("Expense");
          } else {
            row.add("Other");
          }
          row.add(entryList[i].category);
          row.add(entryList[i].amount);
          row.add(entryList[i].description);
          rows.add(row);
        }
      }
    });

    bool checkPermission = true;

    if (checkPermission) {
      String dir =
          (await getExternalStorageDirectory())!.absolute.path + "/Enrix";
      String file = "$dir";
      File f = new File(file +
          "_finance_export_" +
          Random(4).nextInt(100).toString() +
          ".csv");

      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
      print(f.path);
      OpenFile.open(f.path);
    }
  }
}
