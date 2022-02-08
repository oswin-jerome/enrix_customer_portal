import 'dart:io';

import 'package:dio/dio.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/db/Adapters/piwd_model.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportListPage extends StatefulWidget {
  String title;
  int propertyId;
  String propertyName;
  ReportListPage(
      {required this.title,
      required this.propertyId,
      required this.propertyName});
  @override
  _ReportListPageState createState() =>
      _ReportListPageState(this.title, this.propertyId, this.propertyName);
}

class _ReportListPageState extends State<ReportListPage> {
  String category, propertyName;
  int propertyId;
  bool isLoading = false;
  List<String> _downloading = [];
  bool isPinned = false;
  int pinIndex = 0;
  List<dynamic> _reportList = [];
  @override
  void initState() {
    super.initState();
    getReports();
    isThisPined();
  }

  _ReportListPageState(this.category, this.propertyId, this.propertyName);

  pinThis() async {
    var box = await Hive.openBox<Piwd>('piwd');
    Piwd p = new Piwd(type: "report_detail", label: category, data: {
      "category": category,
      "propertyId": propertyId,
      "propertyName": propertyName
    });
    box.add(p);
  }

  unPinThis() async {
    var box = await Hive.openBox<Piwd>('piwd');
    // //print(t("Index: $pinIndex");
    // box.delete(pinIndex);
    var res = box.toMap().forEach((key, value) {
      if (value.type == "report_detail" &&
          value.data!['category'] == category &&
          value.data!['propertyId'] == propertyId) {
        //print(t("has");
        box.delete(key);
      }
    });
  }

  isThisPined() async {
    var box = await Hive.openBox<Piwd>('piwd');

    var res = box.toMap().forEach((key, value) {
      if (value.type == "report_detail" &&
          value.data!['category'] == category &&
          value.data!['propertyId'] == propertyId) {
        //print(t("has");
        setState(() {
          isPinned = true;
          pinIndex = key;
        });
      }
    });
  }

  getReports() async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(t(_token);
    // return;
    setState(() {
      isLoading = true;
    });
    ApiHelper()
        .dio
        .get(
          "property/$propertyId/$category",
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
        .then((value) {
      setState(() {
        isLoading = false;
      });
      //print(t(value.data);
      setState(() {
        _reportList = value.data;
      });
    });
  }

  _downloadFile(String filename) async {
    var fileUrl = Base.baseUrlWithoutApi + "storage/files/reports/" + filename;
    Directory dir = await getApplicationDocumentsDirectory();

    File file = new File(dir.path + "/" + filename);
    if (file.existsSync()) {
      return OpenFile.open(dir.path + "/" + filename);
    }

    setState(() {
      _downloading.add(filename);
    });

    Dio().download(fileUrl, dir.path + "/" + filename,
        onReceiveProgress: (i, j) {
      //print(t(j.toString() + " " + i.toString());
    }).then((value) {
      setState(() {
        _downloading.remove(filename);
      });
      //print(t(value.data);
      OpenFile.open(dir.path + "/" + filename);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      opacity: 0.3,
      color: Colors.black,
      progressIndicator: CustomLoader(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () {
                if (isPinned) {
                  unPinThis();
                  setState(() {
                    isPinned = false;
                  });
                } else {
                  pinThis();
                  setState(() {
                    isPinned = true;
                  });
                }
              },
              icon: Icon(
                isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: isPinned ? Colors.orange : Colors.grey,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: GridView.builder(
              itemCount: _reportList.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (bc, i) {
                return InkWell(
                  onTap: () {
                    _downloadFile(_reportList[i]['file_name']);
                  },
                  child: Card(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Column(
                            children: [
                              Expanded(child: Image.asset("assets/pdf.png")),
                              Text(_reportList[i]["report_name"]),
                            ],
                          ),
                        ),
                        _downloading.indexOf(_reportList[i]['file_name']) != -1
                            ? Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.7),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        // value: 0.5,
                                        ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
