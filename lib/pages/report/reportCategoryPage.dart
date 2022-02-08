import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:customer_portal/Models/Document.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/pages/report/reportListPage.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportCategoryPage extends StatefulWidget {
  int propertyId;
  String propertyName;
  ReportCategoryPage({required this.propertyId, required this.propertyName});

  @override
  _ReportCategoryPageState createState() =>
      _ReportCategoryPageState(this.propertyId, this.propertyName);
}

class _ReportCategoryPageState extends State<ReportCategoryPage>
    with SingleTickerProviderStateMixin {
  List reports = [];
  bool isLoading = false;
  int propertyId;
  String propertyName;
  _ReportCategoryPageState(this.propertyId, this.propertyName);

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    getReportCategories();
    getDocuments();
    _tabController = new TabController(length: 2, vsync: this);
  }

  getReportCategories() async {
    //print(_token);
    // return;
    setState(() {
      isLoading = true;
    });
    ApiHelper()
        .dio
        .get(
          "property/$propertyId/reportcategory",
        )
        .then((value) {
      setState(() {
        isLoading = false;
      });
      setState(() {
        reports = value.data;
      });
    });
  }

  List<Document> _docs = [];
  getDocuments() async {
    //print(_token);
    // return;
    setState(() {
      isLoading = true;
    });
    ApiHelper()
        .dio
        .get(
          "property/$propertyId/docs",
        )
        .then((value) {
      setState(() {
        isLoading = false;
      });
      setState(() {
        // reports = value.data;
        _docs = documentFromJson(jsonEncode(value.data));
      });
    });
  }

  List<String> _downloading = [];

  _downloadFile(String filename) async {
    var fileUrl = Base.baseUrlWithoutApi + "storage/files/receipts/" + filename;
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
      //print(j.toString() + " " + i.toString());
    }).then((value) {
      setState(() {
        _downloading.remove(filename);
      });
      //print(value.data);
      OpenFile.open(dir.path + "/" + filename);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CustomLoader(),
      color: Colors.black,
      opacity: 0.4,
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          title: Text("Docs"),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Text("Reports"),
              ),
              Tab(
                child: Text("Docs"),
              ),
            ],
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          reports.length < 1
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 60, right: 80),
                      // child: Image(
                      //   image: AssetImage("assets/images/no_data.png"),
                      // ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                )
              : GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemCount: reports.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (bc, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (v) => ReportListPage(
                              title: reports[i],
                              propertyId: propertyId,
                              propertyName: propertyName,
                            ),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Hero(
                        tag: reports[i],
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder,
                                  size: 120,
                                  color: Colors.grey,
                                ),
                                Text(reports[i])
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          // Documents
          GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: _docs.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (bc, i) {
              return InkWell(
                onTap: () {
                  _downloadFile(_docs[i].recFileName!);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: Colors.white,
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 5,
                    //     color: Colors.black.withOpacity(0.2),
                    //     offset: Offset(3, 3),
                    //   )
                    // ],
                  ),
                  margin: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Column(
                          children: [
                            Expanded(child: Image.asset("assets/pdf.png")),
                            Text(_docs[i].receiptName!),
                          ],
                        ),
                      ),
                      _downloading.indexOf(_docs[i].recFileName!) != -1
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
        ]),
      ),
    );
  }
}
