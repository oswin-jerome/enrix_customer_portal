import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:customer_portal/Models/Payment.dart';
import 'package:customer_portal/Models/Task.dart';
import 'package:customer_portal/components/AppDrawer.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../dashboard.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Payment> _payments = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    _getClosed();
  }

  _getClosed() async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);

    // setState(() {
    isLoading = true;
    // });

    ApiHelper()
        .dio
        .get(
          Base.baseUrl + "payments",
        )
        .then((value) {
      setState(() {
        isLoading = false;
      });
      _payments = paymentFromJson(jsonEncode(value.data));
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     _getClosed();
        //     // _opened = [];
        //     // _getOpen();
        //   },
        //   child: Icon(Icons.refresh),
        // ),
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          title: Text("Payments"),
          actions: [
            Column(
              children: [
                // IconButton(
                //   onPressed: () {
                //     Navigator.pushReplacement(context,
                //         MaterialPageRoute(builder: (builder) => Dashboard()));
                //   },
                //   icon: Icon(
                //     // Icons.home_rounded,
                //     FontAwesomeIcons.home,
                //     color: Colors.grey,
                //     size: 26,
                //   ),
                // ),
              ],
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
                  color: accent.withOpacity(0.1),
                ),
                child: MyTabBar(
                  tabs: [
                    Tab(
                      text: "Unpaid",
                    ),
                    Tab(
                      text: "Paid",
                    ),
                  ],
                ),
              ),
            ),
          ),
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
              children: _payments.map((e) {
                if (e.paidAt != null) {
                  return Container();
                }
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    title: Text(e.title!),
                    subtitle: Text(
                      e.description!,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        print(e.url);
                        if (await canLaunchUrl(Uri.parse(e.url ?? ""))) {
                          launchUrl(Uri.parse(e.url ?? ""));
                        } else {
                          Get.showSnackbar(
                            GetSnackBar(
                              title: "Unable to launch payment",
                              messageText: Text(""),
                            ),
                          );
                        }
                      },
                      child: Text("Rs. " + e.amount.toString()),
                    ),
                  ),
                );
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
              children: _payments.map((e) {
                //print(e.paidAt == null);
                if (e.paidAt == null) {
                  return Container();
                }
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    title: Text(e.title!),
                    subtitle: Text(
                      e.description!,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: null,
                      child: Text("Rs. " + e.amount.toString()),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ]),
      ),
    );
  }
}
