import 'dart:ui';

import 'package:customer_portal/Controllers/NotificationController.dart';
import 'package:customer_portal/components/AppDrawer.dart';
import 'package:customer_portal/db/Adapters/piwd_model.dart';
import 'package:customer_portal/others/pie_chart.dart';
import 'package:customer_portal/pages/Payments/PaymentsPage.dart';
import 'package:customer_portal/pages/calenderPage.dart';
import 'package:customer_portal/pages/finance/financeReport.dart';
import 'package:customer_portal/pages/finance/incomeReportPage.dart';
import 'package:customer_portal/pages/notification/NotificationsPage.dart';
import 'package:customer_portal/pages/profilePage.dart';
import 'package:customer_portal/pages/property/propertyList.dart';
import 'package:customer_portal/pages/report/reportListPage.dart';
import 'package:customer_portal/pages/requests/requestsPage.dart';
import 'package:customer_portal/pages/requests/tasksPage.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:snap_scroll_physics/snap_scroll_physics.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isGrid = true;
  List pins = [];
  // final notificationController = Get.put(NotificationController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListOfPins();
    var box = Hive.box("store");
    _isGrid = box.get("isgrid", defaultValue: true);

    testNotification();
  }

  testNotification() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseInAppMessaging _firebaseInAppMessaging =
        FirebaseInAppMessaging.instance;
    _firebaseInAppMessaging.triggerEvent("app_launch");
    _firebaseMessaging.getToken().then((token) {
      // print("token: $token");
      ApiHelper().dio.post(Base.baseUrl + "fcm", data: {"fcm_token": token});
      // Clipboard.setData(ClipboardData(text: token));
    });
    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );
    _firebaseMessaging.subscribeToTopic("global");
    _firebaseMessaging.getInitialMessage().then((value) {
      print("value: $value");
    });

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, sound: true);
  }

  getListOfPins() async {
    var r = await Hive.openBox<Piwd>('piwd');
    setState(() {
      pins = r.values.toList();
    });
    r.watch().listen((event) {
      if (mounted) {
        setState(() {
          pins = r.values.toList();
        });
      }
    });
  }

  final notificationController = Get.put(NotificationController());
  final ScrollController _gridScrollController = ScrollController();
  bool _shouldShow = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: AppDrawer(),
      body: Container(
        child: SafeArea(
          child: CustomScrollView(
            physics: SnapScrollPhysics(snaps: [
              Snap.avoidZone(0,
                  200), // If the scroll offset is expected to stop between 0-200, the scroll will snap to 0 if the expected one is between 0-99, and to 200 if it is between 100-200,
              // Snap.avoidZone(
              //   0,
              //   400,
              //   delimiter: 20,
              // ), // If the scroll offset is expected to stop between 0-200, the scroll will snap to 0 if the expected one is between 0-49, and to 200 if it is between 50-200
            ]),
            slivers: [
              SliverPersistentHeader(
                delegate: CustomSliverHeader(),
                pinned: true,
                // floating: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _shouldShow = !_shouldShow;
                            // _isGrid = !_isGrid;
                          });
                          Future.delayed(const Duration(milliseconds: 300), () {
                            setState(() {
                              _isGrid = !_isGrid;
                              _shouldShow = !_shouldShow;
                            });
                          });
                          var box = Hive.box("store");
                          box.put("isgrid", _isGrid);
                        },
                        icon: Icon(
                          _isGrid ? Icons.list_sharp : Icons.grid_view,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                // fillOverscroll: false,

                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GridView(
                          controller: _gridScrollController,
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 25, right: 25),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _isGrid
                                ? (MediaQuery.of(context).size.width > 500
                                    ? 3
                                    : 2)
                                : 1,
                            childAspectRatio: _isGrid ? 1 / 1 : 3.7 / 1,
                            crossAxisSpacing: _isGrid ? 15 : 10,
                            mainAxisSpacing: _isGrid ? 15 : 10,
                          ),
                          children: <Widget>[
                                GridCard(
                                  order: 1,
                                  show: _shouldShow,
                                  direction: _isGrid,
                                  icon: "assets/person.png",
                                  label: "My Profile",
                                  onClick: () {
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (bc) => ProfilePage(),
                                    //   ),
                                    // );
                                    // Get.to(
                                    //   ProfilePage(),
                                    //   transition: Transition.size,
                                    // );

                                    navigateWithFade(context, ProfilePage());

                                    // Navigator.push(
                                    //     context,
                                    //     PageRouteBuilder(
                                    //       pageBuilder: (ctx, ani, secani) =>
                                    //           ProfilePage(),
                                    //       transitionDuration:
                                    //           const Duration(milliseconds: 300),
                                    //       transitionsBuilder:
                                    //           (ctx, ani, secani, child) =>
                                    //               Transform.scale(
                                    //         scale: Tween(begin: 1.2, end: 1.0)
                                    //             .transform(ani.value),
                                    //         child: Opacity(
                                    //           opacity:
                                    //               Tween(begin: 0.0, end: 1.0)
                                    //                   .transform(ani.value),
                                    //           child: child,
                                    //         ),
                                    //       ),
                                    //     ));
                                  },
                                ),
                                GridCard(
                                  show: _shouldShow,
                                  order: 2,
                                  direction: _isGrid,
                                  icon: "assets/bag.png",
                                  label: "Property List",
                                  onClick: () {
                                    navigateWithFade(
                                        context, PropertyListPage());
                                  },
                                ),
                                GridCard(
                                  show: _shouldShow,
                                  order: 7,
                                  direction: _isGrid,
                                  icon: "assets/logos/chart.png",
                                  label: "Finances",
                                  onClick: () {
                                    navigateWithFade(
                                        context,
                                        FinanceReportPage(
                                            propertyName: "Properties"));
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (bc) => FinanceReportPage(
                                    //         propertyName: "Properties"),
                                    //   ),
                                    // );
                                  },
                                ),
                                GridCard(
                                  show: _shouldShow,
                                  order: 3,
                                  direction: _isGrid,
                                  icon: "assets/cal.png",
                                  label: "Calendar",
                                  onClick: () {
                                    navigateWithFade(
                                      context,
                                      CalenderPage(),
                                    );
                                  },
                                ),
                                GridCard(
                                  show: _shouldShow,
                                  order: 4,
                                  direction: _isGrid,
                                  icon: "assets/check.png",
                                  label: "Requests",
                                  onClick: () {
                                    navigateWithFade(
                                      context,
                                      RequestsPage(),
                                    );
                                  },
                                ),
                                GridCard(
                                  show: _shouldShow,
                                  order: 6,
                                  direction: _isGrid,
                                  icon: "assets/logos/tick.png",
                                  label: "All Tasks",
                                  onClick: () {
                                    navigateWithFade(
                                      context,
                                      TasksPage(
                                        propertyName: "Properties",
                                      ),
                                    );
                                  },
                                ),
                                GridCard(
                                  show: _shouldShow,
                                  order: 5,
                                  direction: _isGrid,
                                  icon: "assets/card.png",
                                  label: "Payments",
                                  onClick: () {
                                    navigateWithFade(
                                      context,
                                      PaymentPage(),
                                    );
                                  },
                                ),
                              ] +
                              pins.map<Widget>((e) {
                                Piwd p = e;
                                return buildPins(p, () async {
                                  var r = await Hive.openBox<Piwd>('piwd');
                                  r.deleteAt(pins.indexOf(e));
                                  setState(() {
                                    pins.remove(p);
                                  });
                                });
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SliverToBoxAdapter(
              //   child: Container(
              //       // ////print(_gridScrollController.position.viewportDimension);
              //       // //print(MediaQuery.of(context).size.height);

              //       // height: (MediaQuery.of(context).size.height -
              //       //         _gridScrollController.position.viewportDimension),
              //       ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Stack buildPins(Piwd pin, Function onUnpin) {
    return Stack(
      children: [
        Positioned.fill(
          child: GridCard(
            show: _shouldShow,
            order: 3,
            direction: _isGrid,
            icon: "assets/folder.png",
            heading: pin.data!['propertyName'],
            label: pin.label!,
            onClick: () {
              if (pin.type == "report_detail") {
                navigateWithFade(
                  context,
                  ReportListPage(
                    propertyId: pin.data!['propertyId'],
                    title: pin.data!['category'],
                    propertyName: pin.data!['propertyName'],
                  ),
                );
              }

              if (pin.type == "finance_income") {
                navigateWithFade(
                  context,
                  IncomeReportPage(
                    propertyId: pin.data!['propertyId'],
                    propertyName: pin.data!['propertyName'],
                  ),
                );
              }
            },
          ),
        ),
        // Positioned(
        //   left: 13,
        //   top: 10,
        //   child: Text(
        //     pin.data['propertyName'],
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        Positioned(
          right: 0,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(15 / 360),
            child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (bc) {
                      return AlertDialog(
                        content: const Text("Are your sure to unpin this?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onUnpin();
                              },
                              child: const Text("Yes")),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.push_pin_rounded,
                color: Colors.amber,
                size: 20,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class GridCard extends StatelessWidget {
  String label;
  String icon;
  final VoidCallback onClick;
  bool direction;
  String heading;
  int order;
  bool show;
  GridCard({
    required this.label,
    required this.icon,
    required this.onClick,
    required this.order,
    required this.direction,
    this.heading = "",
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      fadeIn: show,
      slidingCurve: Curves.easeInOutCubic,
      slidingBeginOffset: const Offset(0.0, 0.2),
      delay: Duration(milliseconds: 30 * order + 1),
      child: GestureDetector(
        onTap: onClick,
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Flex(
              direction: direction ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: direction
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: direction ? 50 : 40,
                  child: Image.asset(
                    icon,
                    width: direction ? 50 : 40,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: (direction ? 0.0 : 20.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: direction
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      // heading == null
                      //     ? Container()
                      //     : Text(
                      //         heading,
                      //         style: TextStyle(
                      //           fontSize: direction ? 16 : 18,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: direction ? 14 : 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSliverHeader extends SliverPersistentHeaderDelegate {
  final double _minExtend = AppBar().preferredSize.height;
  final double _maxExtend = 200;
  final double _maxTop = 50;
  final double _minTop = 10;
  final double _maxTopWidth = 50;
  final double _maxBottomWidth = 80;
  final double _minTopWidth = 25;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / _maxExtend;
    //print(percent);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100.withOpacity(0.7),
        // image: DecorationImage(
        //   image: AssetImage(
        //     "assets/images/splash_top.png",
        //   ),
        //   fit: BoxFit.cover,
        // ),
      ),
      height: _maxExtend,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            left: 33,
            bottom: 20,
            child: Opacity(
              opacity: Tween(begin: 1.0, end: 0.0).transform(percent),
              child: Image.asset(
                "assets/images/splash_top.png",
                fit: BoxFit.cover,
                // color: accent.withOpacity(opacity),
              ),
            ),
          ),
          Positioned(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GetX<NotificationController>(builder: (ctrl) {
                    return GestureDetector(
                      onTap: () {
                        navigateWithFade(context, NotificationsPage());
                      },
                      child: Stack(
                        children: [
                          const Center(
                            child: Icon(
                              Icons.notifications,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                          ctrl.pending.value > 0
                              ? Positioned(
                                  top: 10,
                                  left: 4,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
          Positioned(
            left: (((MediaQuery.of(context).size.width / 2) -
                        (_maxTopWidth / 2)) *
                    (1 - percent))
                .clamp(50, (MediaQuery.of(context).size.width / 2))
                .toDouble(),
            top: (_maxTop * (1 - percent)).clamp(_minTop, _maxTop),
            child: Container(
              // color: Colors.red,
              // width: percent > 0.5 ? _minTopWidth : _minTopWidth,
              child: Hero(
                tag: "intro_1",
                child: Image.asset(
                  "assets/logo_top.png",
                  width: ((_maxTopWidth) * (1 - percent))
                      .clamp(_minTopWidth, _maxTopWidth),
                ),
              ),
            ),
          ),
          Positioned(
            left: (((MediaQuery.of(context).size.width / 2) -
                        ((_maxBottomWidth - 6) / 2)) *
                    (1 - percent))
                .clamp(85, (MediaQuery.of(context).size.width / 2))
                .toDouble(),
            top: ((_maxTop + 70) * (1 - percent))
                .clamp(_minTop + 10, _maxTop + 120),
            child: Center(
              // color: Colors.red,
              // width: percent > 0.5 ? _minTopWidth : _minTopWidth,
              child: Image.asset(
                "assets/logo_down.png",
                // width: 0,
                width: ((_maxBottomWidth) * (1 - percent))
                    .clamp(50, _maxBottomWidth),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => _maxExtend;

  @override
  double get minExtent => _minExtend;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
