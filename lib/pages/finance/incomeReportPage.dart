import 'dart:math';

import 'package:date_range_form_field/date_range_form_field.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:customer_portal/db/Adapters/piwd_model.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeReportPage extends StatefulWidget {
  int propertyId;
  String propertyName;
  IncomeReportPage({required this.propertyId, required this.propertyName});
  @override
  _IncomeReportPageState createState() => _IncomeReportPageState(
      propertyId: this.propertyId, propertyName: this.propertyName);
}

class _IncomeReportPageState extends State<IncomeReportPage> {
  String dataToLoad = "this_month";
  int propertyId;
  String propertyName;
  List<Map> _incomes = [];
  _IncomeReportPageState(
      {required this.propertyId, required this.propertyName});
  DateFormat format = DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    super.initState();
    _getData();
    isThisPined();
  }

  _getData() async {
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

    ApiHelper().dio.get(
      "property/$propertyId/income",
      queryParameters: {"from": from, "to": to},
    ).then(
      (value) {
        _incomes = [];
        value.data.forEach((r) {
          _incomes.add(r);
        });
        setState(() {});
      },
    );
  }

  int _currentColor = 0;
  List colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.deepPurple,
    Colors.amber,
    Colors.blueGrey
  ];
  bool isPinned = false;
  int pinIndex = 0;
  String type = "finance_income";
  pinThis() async {
    var box = await Hive.openBox<Piwd>('piwd');
    Piwd p = new Piwd(
        type: type,
        label: "Income report",
        data: {"propertyId": propertyId, "propertyName": propertyName});
    box.add(p);
  }

  unPinThis() async {
    var box = await Hive.openBox<Piwd>('piwd');
    // box.delete(pinIndex);
    var res = box.toMap().forEach((key, value) {
      if (value.type == type && value.data!['propertyId'] == propertyId) {
        //print("has");
        box.delete(key);
      }
    });
  }

  isThisPined() async {
    var box = await Hive.openBox<Piwd>('piwd');
    //print(box.values);
    box.toMap().forEach((key, value) {
      if (value.type == type && value.data!['propertyId'] == propertyId) {
        //print("has");
        setState(() {
          isPinned = true;
          pinIndex = key;
        });
      }
    });
  }

  Color getColor(int i) {
    if (colors.length <= _currentColor) {
      _currentColor = 0;
    }

    Color c = colors[_currentColor];
    _currentColor++;
    return HSLColor.fromColor(c).withLightness(0.7).toColor();
  }

  Random random = new Random();
  @override
  Widget build(BuildContext context) {
    _currentColor = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        title: Text("Income Report"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SelectFormField(
                initialValue: dataToLoad,
                type: SelectFormFieldType.dropdown,
                onSaved: (val) {},
                onChanged: (val) {
                  setState(() {
                    dataToLoad = val;
                  });
                  _getData();
                },
                items: [
                  {"value": "this_month", "label": "This Month"},
                  {"value": "previous_month", "label": "Prevoius Month"},
                  {"value": "this_year", "label": "This Year"},
                  {"value": "previous_year", "label": "Previous Year"},
                  {"value": "custom", "label": "Custom date range"},
                ],
                labelText: "",
              ),
              SizedBox(
                height: 30,
              ),
              _incomes.length < 1
                  ? Container()
                  : Container(
                      child: AspectRatio(
                        aspectRatio: 1.3,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 70,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sections: _incomes.map((e) {
                              return PieChartSectionData(
                                radius: 70,
                                color: getColor(_incomes.indexOf(e)),
                                value: double.parse(e['rent_amt'].toString()),
                                title: e['tenant'],
                              );
                            }).toList(),
                          ),
                          swapAnimationDuration:
                              Duration(milliseconds: 150), // Optional
                          swapAnimationCurve: Curves.linear, // Optional
                        ),
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              _incomes.length < 1
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 60, right: 80),
                          child: Image(
                            image: AssetImage("assets/images/no_data.png"),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text("No reports")
                      ],
                    )
                  : ListView.builder(
                      itemCount: _incomes.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (bc, i) {
                        return Card(
                          child: ListTile(
                            title: Text(_incomes[i]['tenant']),
                            subtitle: Text(format
                                .format(DateTime.parse(_incomes[i]['date']))),
                            trailing: Text(_incomes[i]['rent_amt'].toString()),
                          ),
                        );
                      },
                    ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
