import 'package:delayed_display/delayed_display.dart';
import 'package:dio/dio.dart';
import 'package:customer_portal/Controllers/FinanceConroller.dart';
import 'package:customer_portal/Models/Finance.dart';
import 'package:customer_portal/components/indicator.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:customer_portal/utils/tools.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter_charts/flutter_charts.dart" as fc;
import 'package:charts_flutter/flutter.dart' as charts;
import './../../../others/pie_chart.dart' as pie;

class FinanceFragment extends StatefulWidget {
  int propertyId;
  Finance finance;
  String propertyName;
  String type;
  String typeQuery;
  String period;
  FinanceFragment(
      {required this.propertyId,
      required this.propertyName,
      required this.finance,
      required this.type,
      required this.typeQuery,
      required this.period});

  @override
  _FinanceFragmentState createState() => _FinanceFragmentState(
      propertyId: propertyId,
      propertyName: propertyName,
      finance: finance,
      type: type,
      period: period);
}

class _FinanceFragmentState extends State<FinanceFragment> {
  int propertyId;
  String propertyName;
  Finance finance;
  String type;
  String period;
  int? _currentChart = 0;
  _FinanceFragmentState({
    required this.propertyId,
    required this.propertyName,
    required this.finance,
    required this.type,
    required this.period,
  });
  DateFormat format = DateFormat('yyyy-MM-dd');
  String dataToLoad = "this_month";
  String _selectedNode = "";
  List colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.deepPurple,
    Colors.amber,
    Colors.blueGrey
  ];

  PageController _chartPageController = new PageController();

  Color getColor(int i) {
    int ind = i % colors.length;
    Color c = colors[ind];
    return HSLColor.fromColor(c).withLightness(0.7).toColor();
  }

  @override
  void initState() {
    super.initState();
    _chartPageController.addListener(() {
      setState(() {
        _currentChart = _chartPageController.page?.toInt();
      });
    });
  }

  fc.LineChartOptions _lineChartOptions = new fc.LineChartOptions();
  fc.ChartOptions _verticalBarChartOptions = new fc.VerticalBarChartOptions();
  fc.LabelLayoutStrategy _xContainerLabelLayoutStrategy =
      new fc.DefaultIterativeLabelLayoutStrategy(
    options: new fc.VerticalBarChartOptions(),
  );

  fc.ChartData _chartData = new fc.RandomChartData(
      useUserProvidedYLabels: new fc.LineChartOptions().useUserProvidedYLabels);

  List<charts.Series<dynamic, String>> getBarData(finData) {
    // List<charts.Series<dynamic, String>> data = finData.keys.map((key) {
    //   print(key);
    //   return charts.Series(
    //     id: "q",
    //     domainFn: (s, a) {
    //       return s["label"];
    //     },
    //     measureFn: (sales, _) => sales["val"],
    //     data: [
    //       {"label": "week 1", "val": 1},
    //       {"label": "week 2", "val": 2},
    //       {"label": "week 3", "val": 3}
    //     ],
    //   );
    // }).toList();

    // return data;

    List<charts.Series<dynamic, String>> values = [
      // charts.Series(
      //   id: "q",
      //   domainFn: (s, a) {
      //     return s["label"];
      //   },
      //   measureFn: (sales, _) => sales["val"],
      //   data: [
      //     {"label": "week 1", "val": 1},
      //     {"label": "week 2", "val": 2},
      //     {"label": "week 3", "val": 3}
      //   ],
      // ),
    ];

    finData.keys.forEach((e) {
      List da = [];
      finData[e].keys.forEach((f) {
        da.add({
          "label": Base.userDate.format(DateTime.parse(f)),
          "val": finData[e][f]
        });
      });
      print(finData[e].keys);
      values.add(
        charts.Series(
          id: e,
          domainFn: (s, a) {
            return s["label"];
          },
          measureFn: (sales, _) => sales["val"],
          data: da,
        ),
      );
    });

    return values;
  }

  @override
  Widget build(BuildContext context) {
    FinanceConroller finCtrl = Get.find(tag: "finance");
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ElevatedButton(
          //   child: Text("Hello"),
          //   onPressed: () {
          //     print(
          //         finCtrl.barExpense[finCtrl.barExpense.keys.toList()[0]].keys);
          //   },
          // ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                // horizontal: 50,
                ),
            child: AspectRatio(
              aspectRatio: 3.3 / 3,
              child: Column(
                children: [
                  Text(
                    "Showing report for : \n" +
                        convertConstantsToMessage(
                            con: period, from: finCtrl.from, to: finCtrl.to),
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _chartPageController,
                      children: [
                        Stack(
                          children: [
                            pie.PieChart(
                              dataMap: Map.fromIterable(
                                finance.categories!,
                                key: (d) => d.category,
                                value: (d) => d.total,
                              ),
                              colorList: finance.categories!.map((f) {
                                return getColor(finance.categories!.indexOf(f));
                              }).toList(),
                              chartType: pie.ChartType.ring,
                              chartRadius: 160,
                              ringStrokeWidth: 35,
                              // gradientList: [
                              //   [
                              //     Colors.amber,
                              //     Colors.amber,
                              //     Colors.deepOrange,
                              //   ],
                              //   [
                              //     Colors.amber,
                              //     Colors.deepOrange,
                              //   ],
                              // ],
                              legendOptions: pie.LegendOptions(
                                showLegendsInRow: false,
                                showLegends: false,
                                legendPosition: pie.LegendPosition.bottom,
                              ),
                              animationDuration: Duration(milliseconds: 800),
                              chartValuesOptions: pie.ChartValuesOptions(
                                showChartValuesOutside: true,
                                showChartValuesInPercentage: true,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 40, left: 15, right: 15),
                          child: charts.BarChart(
                            getBarData(finCtrl.barExpense),
                            // [].map((e) => charts.Series(
                            //     id: "q",
                            //     domainFn: (s, a) {
                            //       return s["label"];
                            //     },
                            //     measureFn: (sales, _) => sales["val"],
                            //     data: []
                            //     //     data: [
                            //     //       {"label": "week 1", "val": 1},
                            //     //       {"label": "week 2", "val": 2},
                            //     //       {"label": "week 3", "val": 3}
                            //     //     ],
                            //     ))
                            // [
                            //   charts.Series(
                            //     id: "q",
                            //     domainFn: (s, a) {
                            //       return s["label"];
                            //     },
                            //     measureFn: (sales, _) => sales["val"],
                            //     data: [
                            //       {"label": "week 1", "val": 1},
                            //       {"label": "week 2", "val": 2},
                            //       {"label": "week 3", "val": 3}
                            //     ],
                            //   ),
                            //   charts.Series(
                            //     id: "q1",
                            //     domainFn: (s, a) {
                            //       return s["label"];
                            //     },
                            //     measureFn: (sales, _) => sales["val"],
                            //     data: [
                            //       {"label": "week 1", "val": 3},
                            //       {"label": "week 2", "val": 2},
                            //       {"label": "ac", "val": 2},
                            //       {"label": "abv", "val": 2},
                            //       {"label": "aba", "val": 2},
                            //     ],
                            //   ),
                            // ],
                            // [] +
                            //     finCtrl.barExpense.keys
                            //         .map((e) => charts.Series(
                            //             id: e,
                            //             domainFn: (datum, index) {
                            //               return "s";
                            //             },
                            //             data: finCtrl.barExpense[e]))
                            //         .toList(),

                            secondaryMeasureAxis: charts.NumericAxisSpec(
                              showAxisLine: false,
                              tickProviderSpec:
                                  charts.BasicNumericTickProviderSpec(
                                zeroBound: false,
                                dataIsInWholeNumbers: false,
                                desiredTickCount: 5,
                              ),
                            ),
                            domainAxis: charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                lineStyle: charts.LineStyleSpec(
                                  color: charts.MaterialPalette.gray.shade300,
                                  thickness: 2,
                                ),
                                labelStyle: charts.TextStyleSpec(
                                  color: charts.MaterialPalette.gray.shade400,
                                  fontSize: 12,
                                ),
                                axisLineStyle: charts.LineStyleSpec(
                                  color: charts.MaterialPalette.gray.shade300,
                                  thickness: 2,
                                ),
                              ),
                            ),
                            primaryMeasureAxis: new charts.NumericAxisSpec(
                              tickProviderSpec:
                                  new charts.BasicNumericTickProviderSpec(
                                      zeroBound: true,
                                      dataIsInWholeNumbers: false,
                                      desiredTickCount: 1,
                                      desiredMinTickCount: 10),
                            ),
                            barGroupingType: charts.BarGroupingType.stacked,
                            defaultRenderer: charts.BarRendererConfig(
                              cornerStrategy: charts.ConstCornerStrategy(30),
                              groupingType: charts.BarGroupingType.stacked,
                              maxBarWidthPx: 15,
                            ),
                          ),
                          // child: BarChart(
                          //   BarChartData(
                          //     gridData: FlGridData(
                          //       show: true,
                          //       drawVerticalLine: false,
                          //       horizontalInterval: 100,

                          //       getDrawingHorizontalLine: (value) {
                          //         return FlLine(
                          //           color: Colors.grey.shade300,
                          //           strokeWidth: 1,
                          //         );
                          //       },
                          //       // getDrawingVerticalLine: (value) {
                          //       //   return FlLine(
                          //       //     color: const Color(0xff37434d),
                          //       //     strokeWidth: 1,
                          //       //   );
                          //       // },
                          //     ),
                          //     borderData: FlBorderData(
                          //       show: false,
                          //     ),
                          //     alignment: BarChartAlignment.spaceEvenly,
                          //     barGroups: finance.dates.map((e) {
                          //       return BarChartGroupData(
                          //         x: finance.dates.indexOf(e),
                          //         barsSpace: 150,
                          //         barRods: [
                          //           BarChartRodData(
                          //             y: e.total + 0.0,
                          //             width: 30,
                          //             colors: [getColor(e.total.toInt())],
                          //             borderRadius: BorderRadius.only(
                          //               topLeft: Radius.circular(10),
                          //               topRight: Radius.circular(10),
                          //             ),
                          //           ),
                          //         ],
                          //       );
                          //     })?.toList(),
                          //     titlesData: FlTitlesData(
                          //       bottomTitles: SideTitles(
                          //         showTitles: true,

                          //         // rotateAngle: 45,
                          //         getTitles: (a) {
                          //           return Base.formaterr.format(
                          //               finance.dates[a.toInt()].createdAt);
                          //         },
                          //       ),
                          //       leftTitles: SideTitles(
                          //         getTitles: (a) {
                          //           return "he";
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [0, 1].map((e) {
                      return Container(
                        width: 6,
                        height: 6,
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          color: _currentChart != e
                              ? Color(0xffe0e0e0)
                              : Color(0xffc4c4c4),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Wrap(
                runSpacing: 10,
                // direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: <Widget>[] +
                    finance.categories!
                        .map(
                          (e) => Indicator(
                            color: getColor(finance.categories!.indexOf(e)),
                            text: e.category!,
                            isSquare: false,
                            size: 6,
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: RichText(
                textAlign: TextAlign.end,
                text: TextSpan(children: [
                  TextSpan(
                    text: "Total: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: finance.total?.toString() ?? "0",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ])),
          ),
          ListView.separated(
            padding: EdgeInsets.only(bottom: 80),
            separatorBuilder: (bx, i) {
              if (_selectedNode != "" &&
                  _selectedNode != finance.entries![i].category) {
                return Container();
              }
              return Divider();
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: finance.entries?.length ?? 0,
            itemBuilder: (bc, i) {
              if (_selectedNode != "" &&
                  _selectedNode != finance.entries![i].category) {
                return Container();
              }
              return ListTile(
                isThreeLine: true,
                title: Row(
                  children: [
                    Text(finance.entries![i].category!),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      Base.formaterr.format(
                        finance.entries![i].date!,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                // subtitle: Text(Base.formaterr.format(finance.entries[i].date)),
                subtitle: Text(
                  finance.entries![i].description!,
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  finance.entries![i].amount.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: type == "Income" ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
