import 'dart:ui';

import 'package:delayed_display/delayed_display.dart';
import 'package:dio/dio.dart';
import 'package:customer_portal/Models/Property.dart';
import 'package:customer_portal/components/AppDrawer.dart';
import 'package:customer_portal/components/AppStepper.dart';
import 'package:customer_portal/components/CustomFab.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/components/propertyCard.dart';
import 'package:customer_portal/others/pie_chart.dart';
import 'package:customer_portal/pages/dashboard.dart';
import 'package:customer_portal/pages/extras/SignPage.dart';
import 'package:customer_portal/pages/property/addPropertyPage.dart';
import 'package:customer_portal/pages/report/reportCategoryPage.dart';
import 'package:customer_portal/pages/timeLinePage.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:customer_portal/utils/GenerateAuthLetter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial/tutorial.dart';
import 'package:rive/rive.dart';
import '../activity/activityLogPage.dart';

class PropertyListPage extends StatefulWidget {
  @override
  _PropertyListPageState createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  List<Property> _properties = [];
  bool isLoading = false;

  // Intro
  final addMenu = GlobalKey();
  List<TutorialItens> itens = [];
  @override
  void initState() {
    itens.addAll({
      TutorialItens(
        globalKey: addMenu,
        touchScreen: true,
        top: 200,
        left: 50,
        children: [
          Text(
            "Registering a new property",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            height: 100,
          )
        ],
        widgetNext: Text(
          "Next",
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        shapeFocus: ShapeFocus.oval,
      ),
    });
    super.initState();
    _getProperties();
  }

  _getProperties() async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);

    setState(() {
      isLoading = true;
    });
    // await Future.delayed(Duration(seconds: 3));

    ApiHelper()
        .dio
        .get(
          "property",
        )
        .then((value) {
      setState(() {
        isLoading = false;
      });
      _properties = [];
      value.data["data"].forEach((property) {
        Property pro = Property.fromJson(property);
        //print(property);
        _properties.add(pro);
      });
      setState(() {
        _properties.sort((a, b) => a.position!.compareTo(b.position!));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      opacity: 0.4,
      color: Colors.black,
      progressIndicator: CustomLoader(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          title: Text("Property List"),
          actions: [
            Column(
              children: [],
            )
          ],
        ),
        floatingActionButton: CustomFab(
          icon: Icon(Icons.add),
          label: "New",
          onPress: () async {
            await navigateWithFade(
              context,
              AddPropertyPage(),
            );
            _getProperties();
          },
        ),
        drawer: Navigator.canPop(context) ? null : AppDrawer(),
        body: _properties.length < 1
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    // child: Image(
                    //   image: AssetImage("assets/images/noproperties.png"),
                    // ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    height: 150,
                  )
                ],
              )
            : Theme(
                data: Theme.of(context).copyWith(
                  shadowColor: Colors.transparent,
                  canvasColor: Colors.transparent,
                ),
                child: ReorderableListView(
                  // shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  onReorder: (current, latest) async {
                    //print("c : $current | l: $latest");

                    var _pref = await SharedPreferences.getInstance();
                    String? _token = _pref.getString("token");

                    var c = current;
                    var l = latest - (current < latest ? 1 : 0);
                    var temp = _properties[c];
                    _properties[c] = _properties[l];
                    _properties[l] = temp;
                    setState(() {});
                    // return;
                    ApiHelper()
                        .dio
                        .post(
                          "sort",
                          data: FormData.fromMap({
                            "current": current,
                            "new": latest - (current < latest ? 1 : 0)
                          }),
                        )
                        .then((value) {
                      _getProperties();
                    });
                  },
                  // physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    for (int index = 0; index < _properties.length; index++)
                      Container(
                        key: Key(_properties[index].id.toString()),
                        child: DelayedDisplay(
                          slidingBeginOffset: Offset(0.0, 0.4),
                          slidingCurve: Curves.easeInOutCubic,
                          delay: Duration(milliseconds: 20 * index + 1),
                          child: PropertyCard(
                            key: Key(_properties[index].id.toString()),
                            property: _properties[index],
                          ),
                        ),
                      )
                  ],
                ),
              ),
      ),
    );
  }
}
