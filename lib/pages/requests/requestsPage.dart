import 'dart:convert';

import 'package:customer_portal/others/pie_chart.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:dio/dio.dart';
import 'package:customer_portal/Models/Task.dart';
import 'package:customer_portal/components/AppDrawer.dart';
import 'package:customer_portal/components/CustomFab.dart';
import 'package:customer_portal/components/TaskCard.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/components/my_app_bar.dart';
import 'package:customer_portal/pages/requests/createRequestPage.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map> _opened = [];
  List<Map> _closed = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    _getClosed();
    _getOpen();
  }

  _getClosed() async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);

    // setState(() {
    isLoading = true;
    // });

    ApiHelper().dio.get("request/closed").then((value) {
      setState(() {
        isLoading = false;
      });
      value.data['data'].forEach((ope) {
        //print(ope);
        _closed.add(ope);
      });
      setState(() {});
    });
  }

  _getOpen() async {
    setState(() {
      isLoading = true;
    });

    ApiHelper()
        .dio
        .get(
          Base.baseUrl + "request/open",
        )
        .then((value) {
      setState(() {
        isLoading = false;
      });
      value.data['data'].forEach((ope) {
        //print(ope);
        _opened.add(ope);
      });
      setState(() {});
    });
  }

  DateFormat format = DateFormat('dd MMMM yyyy');
  Color getColor(String text) {
    switch (text) {
      case "open":
        return Colors.red;
        break;
      case "on process":
        return Colors.orange;
        break;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        floatingActionButton: CustomFab(
          onPress: () async {
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (c) => CreateRequestPage(), fullscreenDialog: true),
            // );
            // await Get.to(
            //   CreateRequestPage(),
            //   fullscreenDialog: false,
            //   transition: Transition.rightToLeftWithFade,
            //   curve: Curves.easeInOut,
            // );

            await navigateWithFade(
              context,
              CreateRequestPage(),
            );
            // await Navigator.push(
            //   context,
            //   PageRouteBuilder(
            //     pageBuilder: (ctx, ani, secani) => CreateRequestPage(),
            //     transitionDuration: Duration(milliseconds: 300),
            //     reverseTransitionDuration: Duration(milliseconds: 200),
            //     fullscreenDialog: true,
            //     transitionsBuilder: (ctx, ani, secani, child) {
            //       return Transform.scale(
            //         scale: Tween(begin: 0.9, end: 1.0).transform(ani.value),
            //         child: Opacity(
            //           opacity: Tween(begin: 0.0, end: 1.0).transform(ani.value),
            //           child: child,
            //         ),
            //       );
            //     },
            //   ),
            // );
            _opened = [];
            _getOpen();
          },
          label: "New",
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          title: Text("Requests"),
          actions: [
            Column(
              children: [],
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Transform.scale(
              scale: 0.8,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                width: MediaQuery.of(context).size.width - 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // color: Colors.grey.shade200,
                    color: accent.withOpacity(0.1)),
                child: MyTabBar(
                  // tabController: _tabController,
                  tabs: [
                    Tab(
                      text: "Open Requests",
                    ),
                    Tab(
                      text: "Closed Requests",
                    ),
                  ],
                ),
              ),
            ),
          ),
          // bottom: TabBar(
          //   // controller: _tabController,
          //   tabs: [

          //   ],
          // ),
        ),
        drawer: Navigator.canPop(context) ? null : AppDrawer(),
        body: TabBarView(children: [
          ModalProgressHUD(
            inAsyncCall: isLoading,
            opacity: 0.3,
            color: Colors.black,
            progressIndicator: CustomLoader(),
            child: ListView(
              padding: EdgeInsets.all(10),
              children: _opened.map((e) {
                return DelayedDisplay(
                    slidingBeginOffset: Offset(-0.1, 0),
                    delay: Duration(milliseconds: 400 * _closed.indexOf(e) + 1),
                    child: TaskCard(
                        task: Task.fromJson(jsonDecode(jsonEncode(e)))));
              }).toList(),
            ),
          ),
          ModalProgressHUD(
            inAsyncCall: isLoading,
            opacity: 0.3,
            color: Colors.black,
            progressIndicator: CustomLoader(),
            child: ListView(
              padding: EdgeInsets.all(10),
              children: _closed.map((e) {
                return DelayedDisplay(
                    slidingBeginOffset: Offset(0.1, 0),
                    delay: Duration(milliseconds: 200 * _closed.indexOf(e) + 1),
                    child: TaskCard(
                        task: Task.fromJson(jsonDecode(jsonEncode(e)))));
              }).toList(),
            ),
          ),
        ]),
      ),
    );
  }
}
