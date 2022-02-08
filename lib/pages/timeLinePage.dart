import 'dart:convert';

import 'package:delayed_display/delayed_display.dart';
import 'package:dio/dio.dart';
import 'package:customer_portal/Models/ActivityLogGroup.dart';
import 'package:customer_portal/components/CustomFab.dart';
import 'package:customer_portal/components/activityLogCard.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/pages/activity/activityDetailsPage.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';

import 'dashboard.dart';

class TimeLinePage extends StatefulWidget {
  int propertyId;
  TimeLinePage(this.propertyId);
  @override
  _TimeLinePageState createState() => _TimeLinePageState(this.propertyId);
}

class _TimeLinePageState extends State<TimeLinePage>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  int propertyId;
  _TimeLinePageState(this.propertyId);
  List<ActivityLogGroup> _logGroup = [];
  List<String> _tags = [];
  // List<Tagg> _selectedTags = [];
  List _actTypes = [];
  String? nextPage = null;
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _da();

    _getData();
    _getActType();
  }

  _getActType() async {
    ApiHelper()
        .dio
        .get(
          "property/$propertyId/activities/categories",
        )
        .then((value) {
      setState(() {
        _actTypes = value.data;
      });
    });
  }

  _getData() async {
    setState(() {
      isLoading = true;
    });
    ApiHelper().dio.get(
      Base.baseUrl + "property/$propertyId/activities?page=$page",
      queryParameters: {"activities": _tags.join(",")},
    ).then((value) {
      // //print(value);
      // return;
      setState(() {
        isLoading = false;
      });
      value.data["data"].forEach((grp) {
        ActivityLogGroup _grp = new ActivityLogGroup.fromJson(grp);
        //print(_grp.data);
        setState(() {
          _logGroup.add(_grp);
        });
      });
    });
  }

  _da() {
    _scrollController.addListener(() {
      //print("Off" +
      // _scrollController.position.maxScrollExtent.toInt().toString());
      //print(_scrollController.offset.toInt());

      if (_scrollController.position.maxScrollExtent.toInt() ==
          _scrollController.offset.toInt()) {
        _getNextPage();
      }
    });
  }

  _getNextPage() {
    if (nextPage != null) {
      //print("Loading next page...");
    }

    nextPage = null;
  }

  DateFormat format = DateFormat('dd MMMM yyyy');
  DateFormat formatMonth = DateFormat('MMMM yyyy');
  List<int> closed = [];
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        title: Text("Activity log"),
        actions: [
          Column(
            children: [],
          )
        ],
      ),
      floatingActionButton: CustomFab(
          icon: Icon(Icons.filter_list),
          label: "Filter",
          onPress: () {
            showModalBottomSheet(
              context: context,
              builder: (d) {
                return ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            "Activity Types",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _actTypes.length,
                            shrinkWrap: true,
                            itemBuilder: (bc, i) {
                              bool isChecked =
                                  _tags.contains(_actTypes[i]["activity_type"]);
                              return _actTypes[i]["activity_type"] == ""
                                  ? Container()
                                  : StatefulBuilder(
                                      builder: (bx, setState) => ListTile(
                                        title:
                                            Text(_actTypes[i]["activity_type"]),
                                        trailing: Checkbox(
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (value ?? false) {
                                                _tags.add(_actTypes[i]
                                                    ["activity_type"]);
                                              } else {
                                                _tags.remove(_actTypes[i]
                                                    ["activity_type"]);
                                              }
                                              setState(() {
                                                isChecked = !isChecked;
                                              });
                                            });
                                          },
                                          value: isChecked,
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _logGroup = [];
                                  page = 1;
                                  _getData();
                                  Navigator.pop(context);
                                },
                                child: Text("Ok"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              elevation: 0,
              backgroundColor: Colors.transparent,
              barrierColor: Colors.black.withOpacity(0.35),
            );
          }),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.3,
        color: Colors.black,
        progressIndicator: CustomLoader(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30),
          controller: _scrollController,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Timeline.tileBuilder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    theme: TimelineThemeData(
                      color: Colors.grey,
                      indicatorTheme: IndicatorThemeData(
                        size: 20,
                      ),
                      connectorTheme: ConnectorThemeData(
                        thickness: 5,
                      ),
                    ),
                    builder: TimelineTileBuilder.fromStyle(
                      contentsAlign: ContentsAlign.basic,

                      nodePositionBuilder: (context, index) {
                        return 0;
                      },
                      indicatorPositionBuilder: (b, i) {
                        return 0;
                      },
                      indicatorStyle: IndicatorStyle.outlined,
                      connectorStyle: ConnectorStyle.solidLine,
                      // itemExtent: 300,
                      itemExtentBuilder: (context, index) {
                        // if (index == 0) {
                        //   return 500;
                        // }
                        // return 300;

                        if (closed.contains(index)) {
                          return 50;
                        }
                        return (_logGroup[index].data!.length *
                                170.toDouble()) +
                            40;
                      },
                      contentsBuilder: (context, index) {
                        Animation _arrowAnimation;
                        AnimationController _arrowAnimationController;
                        _arrowAnimationController = AnimationController(
                            vsync: this, duration: Duration(milliseconds: 300));
                        _arrowAnimation = Tween(begin: 1.0, end: 0.0)
                            .animate(_arrowAnimationController);

                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            // color: Colors.red,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (closed.contains(index)) {
                                      setState(() {
                                        closed.remove(index);
                                      });
                                    } else {
                                      setState(() {
                                        closed.add(index);
                                      });
                                    }
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.s,
                                    children: [
                                      Text(
                                        formatMonth.format(DateTime.parse(
                                            "${_logGroup[index].year}-${_logGroup[index].month.toString().padLeft(2, '0')}-02")),
                                        style: TextStyle(
                                          fontSize: 18,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Center(
                                        child: closed.contains(index)
                                            ? Icon(
                                                FontAwesomeIcons.chevronUp,
                                                size: 14,
                                              )
                                            : Icon(
                                                FontAwesomeIcons.chevronDown,
                                                size: 14,
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation: _arrowAnimationController,
                                  builder: (context, child) => AnimatedOpacity(
                                    duration: Duration(seconds: 3),
                                    opacity: _arrowAnimation.value,
                                    child: ListView.builder(
                                      itemCount: _logGroup[index].data!.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (bc, i) {
                                        if (closed.contains(index)) {
                                          return Container();
                                        }
                                        // ++temp;
                                        return DelayedDisplay(
                                          slidingBeginOffset: Offset(0.0, 0.4),
                                          slidingCurve: Curves.easeInOutCubic,
                                          delay: Duration(
                                              milliseconds: 200 * (i + 1) + 1),
                                          child: ActivityLogCard(
                                            log: _logGroup[index].data![i],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: _logGroup.length,
                    ),
                  ),
                ),
                // TODO: ADD lazy loading
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 15.0),
                //   child: Center(
                //     child: CircularProgressIndicator(),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class TaggService {
//   int propertyID;
//   TaggService({required this.propertyID});

//   /// Mocks fetching Tagg from network API with delay of 500ms.
//   Future<List<Tagg>> getTaggs(String query) async {
//     List<Tagg> result = [];
//     await Future.delayed(Duration(milliseconds: 500), null);
//     var _pref = await SharedPreferences.getInstance();
//     String? _token = _pref.getString("token");
//     Response res =
//         await ApiHelper().dio.get("property/$propertyID/activities/categories");
//     if (res != null) {
//       //print(res.statusCode);
//       // //print((res.data['data']));
//       if (res.statusCode == 200) {
//         for (var da in res.data) {
//           //print(da);
//           result.add(
//             Tagg(name: da["activity_type"], position: da["count"]),
//           );
//         }
//       }
//     }
//     return result
//         .where((lang) => lang.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//   }
// }

// class Tagg extends Taggable {
//   ///
//   final String name;

//   ///
//   final int position;

//   /// Creates Tagg
//   Tagg({
//     required this.name,
//     required this.position,
//   });

//   @override
//   List<Object> get props => [name];

//   /// Converts the class to json string.
//   String toJson() => '''  {
//     "name": $name,\n
//     "position": $position\n
//   }''';
// }
