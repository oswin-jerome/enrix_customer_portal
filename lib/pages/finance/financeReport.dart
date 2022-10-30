import 'package:customer_portal/utils/Base.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:customer_portal/Controllers/ExportController.dart';
import 'package:customer_portal/Controllers/FinanceConroller.dart';
import 'package:customer_portal/Models/Finance.dart';
import 'package:customer_portal/components/CustomFab.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/components/indicator.dart';
import 'package:customer_portal/components/my_app_bar.dart';
import 'package:customer_portal/pages/finance/fragments/financeFragment.dart';
import 'package:customer_portal/utils/tools.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:select_form_field/select_form_field.dart';

import '../dashboard.dart';

class FinanceReportPage extends StatefulWidget {
  int? propertyId;
  String propertyName;
  FinanceReportPage({this.propertyId, required this.propertyName});
  @override
  _FinanceReportPageState createState() => _FinanceReportPageState();
}

class _FinanceReportPageState extends State<FinanceReportPage>
    with SingleTickerProviderStateMixin {
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
  Color getColor(int i) {
    if (colors.length <= _currentColor) {
      _currentColor = 0;
    }

    Color c = colors[_currentColor];
    _currentColor++;
    return HSLColor.fromColor(c).withLightness(0.7).toColor();
  }

  late TabController _tabController;
  String? frm, too;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    controller.getData(
        dataToLoad: _filterPeriod,
        type: "Income",
        propertyID: widget.propertyId ?? null);

    controller.getData(
        dataToLoad: _filterPeriod,
        type: "Expense",
        propertyID: widget.propertyId ?? null);
    controller.getData(
        dataToLoad: _filterPeriod,
        type: "Withdrawals",
        propertyID: widget.propertyId ?? null);

    controller.getBarData();
  }

  String _filterPeriod = "this_year";
  var controller = Get.put(FinanceConroller(), tag: "finance");
  bool _isOp = true;

  _showExportPanel() {
    List<String> _selectedCategories = [];
    List<String> categories = [];
    List<int> _selectedTypes = [];
    Finance income = controller.incomeList.value;
    Finance expense = controller.expenseList.value;
    Finance other = controller.otherList.value;
    List<Finance> _finances = [income, expense, other];
    // print(finance.categories);
    // return;

    income.categories?.forEach((element) {
      if (!categories.contains(element.category)) {
        categories.add(element.category!);
      }
    });
    expense.categories?.forEach((element) {
      if (!categories.contains(element.category)) {
        categories.add(element.category!);
      }
    });
    other.categories?.forEach((element) {
      if (!categories.contains(element.category)) {
        categories.add(element.category!);
      }
    });

    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.35),
        enableDrag: false,
        builder: (b) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
            ),
            child: StatefulBuilder(
              builder: (bc, setState) => ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: SingleChildScrollView(
                  // physics: NeverScrollableScrollPhysics(),
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 30, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  ExportController ctrl =
                                      new ExportController();
                                  ctrl.exportCSV(
                                    exportableCategories: _selectedCategories,
                                    finance: _finances,
                                    selectedTypes: _selectedTypes,
                                  );
                                },
                                child: Text(
                                  "Export",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Types: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.all(0),
                              title: Text("Income"),
                              leading: Checkbox(
                                value: _selectedTypes.contains(0),
                                onChanged: (b) {
                                  setState(() {
                                    if (!b!) {
                                      _selectedTypes.remove(0);
                                    } else {
                                      _selectedTypes.add(0);
                                    }
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.all(0),
                              title: Text("Expense"),
                              leading: Checkbox(
                                value: _selectedTypes.contains(1),
                                onChanged: (b) {
                                  setState(() {
                                    if (!b!) {
                                      _selectedTypes.remove(1);
                                    } else {
                                      _selectedTypes.add(1);
                                    }
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.all(0),
                              title: Text("Others"),
                              leading: Checkbox(
                                value: _selectedTypes.contains(2),
                                onChanged: (b) {
                                  setState(() {
                                    if (!b!) {
                                      _selectedTypes.remove(2);
                                    } else {
                                      _selectedTypes.add(2);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Categories: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: categories.length,
                          itemBuilder: (bc, i) {
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.all(0),
                              horizontalTitleGap: 0.0,
                              leading: Checkbox(
                                value: !_selectedCategories
                                    .contains(categories[i]),
                                onChanged: (s) {
                                  setState(() {
                                    if (s!) {
                                      _selectedCategories.remove(categories[i]);
                                    } else {
                                      _selectedCategories.add(categories[i]);
                                    }
                                  });
                                },
                              ),
                              title: Text(categories[i]),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        //print(notification.metrics.atEdge);
        setState(() {
          _isOp = notification.metrics.atEdge;
        });
        return false;
      },
      child: Scaffold(
        // floatingActionButton: CustomFab(),
        floatingActionButton: CustomFab(
            label: "Filter",
            icon: Icon(
              Icons.filter_list_rounded,
              color: Colors.white,
            ),
            onPress: () {
              // controller.getData(
              //     dataToLoad: _filterPeriod,
              //     type: "Income",
              //     propertyID: widget.propertyId);
              // return;
              showModalBottomSheet(
                // isScrollControlled: true,
                context: context,
                builder: (d) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: StatefulBuilder(
                      builder: (bc, setState) => ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DropdownButtonFormField(
                                  // titleText: "Choose a period",
                                  // textField: 'display',
                                  // valueField: 'value',
                                  // filled: false,
                                  value: _filterPeriod,
                                  onChanged: (String? s) {
                                    //print(s);
                                    if (s == "custom") {
                                      String from = "";
                                      String to = "";
                                      showDialog(
                                          context: context,
                                          builder: (bc) {
                                            return Dialog(
                                              child: Container(
                                                padding: EdgeInsets.all(15),
                                                child: AspectRatio(
                                                  aspectRatio: 1 / 0.8,
                                                  child: Column(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          DateTimePicker(
                                                            firstDate:
                                                                DateTime(2001),
                                                            initialDate:
                                                                DateTime.now(),
                                                            lastDate:
                                                                DateTime(2022),
                                                            dateLabelText:
                                                                "From",
                                                            onChanged: (a) {
                                                              from = a;
                                                              frm = a;
                                                            },
                                                          ),
                                                          DateTimePicker(
                                                            onChanged: (a) {
                                                              to = a;
                                                              too = a;
                                                            },
                                                            firstDate:
                                                                DateTime(2001),
                                                            initialDate:
                                                                DateTime.now(),
                                                            lastDate:
                                                                DateTime(2022),
                                                            dateLabelText: "To",
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 15,
                                                                    top: 10),
                                                            child:
                                                                ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      primary:
                                                                          accent,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        _filterPeriod =
                                                                            "custom";
                                                                      });
                                                                      controller
                                                                          .getData(
                                                                        dataToLoad:
                                                                            "custom",
                                                                        type:
                                                                            "Income",
                                                                        propertyID:
                                                                            widget.propertyId!,
                                                                        from_c:
                                                                            from,
                                                                        to_c:
                                                                            to,
                                                                      );

                                                                      controller
                                                                          .getData(
                                                                        dataToLoad:
                                                                            "custom",
                                                                        type:
                                                                            "Expense",
                                                                        propertyID:
                                                                            widget.propertyId!,
                                                                        from_c:
                                                                            from,
                                                                        to_c:
                                                                            to,
                                                                      );
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        "Filter")),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                      return;
                                    }
                                    setState(() {
                                      _filterPeriod = s!;
                                    });

                                    controller.getData(
                                        dataToLoad: _filterPeriod,
                                        type: "Income",
                                        propertyID: widget.propertyId!);

                                    controller.getData(
                                        dataToLoad: _filterPeriod,
                                        type: "Expense",
                                        propertyID: widget.propertyId!);
                                    controller.getData(
                                        dataToLoad: _filterPeriod,
                                        type: "WithDrawals",
                                        propertyID: widget.propertyId!);
                                    Navigator.pop(context);
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                        child: Text("This Month"),
                                        value: "this_month"),
                                    DropdownMenuItem(
                                        child: Text("Last Month"),
                                        value: "last_month"),
                                    DropdownMenuItem(
                                        child: Text("This Year"),
                                        value: "this_year"),
                                    DropdownMenuItem(
                                        child: Text("Last Year"),
                                        value: "previous_year"),
                                    DropdownMenuItem(
                                        child: Text("Custom"), value: "custom"),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, top: 10),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Filter")),
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  title: Text("Export"),
                                ),
                                ListTile(
                                  onTap: () async {
                                    // ExportController ctrl =
                                    //     new ExportController();
                                    // ctrl.exportCSV();
                                    Navigator.pop(context);
                                    _showExportPanel();
                                  },
                                  title: Text("Export CSV"),
                                  leading: Icon(Icons.table_view_rounded),
                                ),
                                // ListTile(
                                //   title: Text("Export PDF"),
                                //   leading: Icon(Icons.document_scanner_rounded),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                elevation: 0,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black.withOpacity(0.35),
              );
            }),
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          title: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(fontFamily: GoogleFonts.raleway().fontFamily),
              children: [
                TextSpan(
                  text: "Finances",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "   " + widget.propertyName,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
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
                  tabController: _tabController,
                  tabs: [
                    Tab(
                      // text: "Income",

                      child: Text("Income"),
                    ),
                    Tab(
                      // text: "Income",
                      child: Text("Expense"),
                    ),
                    Tab(
                      // text: "Income",
                      child: Text("Others"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Obx(() {
              if (controller.dataLoading.value == true) {
                return ModalProgressHUD(
                  inAsyncCall: true,
                  opacity: 0.3,
                  color: Colors.black,
                  progressIndicator: CustomLoader(),
                  child: Container(),
                );
              }
              Finance finance = controller.incomeList.value;
              if (controller.incomeList.value.total != null) {
                if (finance.total == 0) {
                  return Center(
                    child: Text("No data for " +
                        convertConstantsToMessage(
                            con: _filterPeriod,
                            from: frm ?? "",
                            to: too ?? "")),
                  );
                }
                return FinanceFragment(
                  propertyId: widget.propertyId ?? null,
                  propertyName: widget.propertyName,
                  finance: finance,
                  type: "Income",
                  typeQuery: "Income",
                  period: _filterPeriod,
                );
              } else {
                return Center(
                  child: Text("Error"),
                );
              }
            }),
            Obx(() {
              if (controller.dataLoading.value == true) {
                return ModalProgressHUD(
                  inAsyncCall: true,
                  opacity: 0.3,
                  color: Colors.black,
                  progressIndicator: CustomLoader(),
                  child: Container(),
                );
              }
              Finance finance = controller.expenseList.value;
              if (controller.expenseList.value.total != null) {
                if (finance.total == 0) {
                  return Center(
                    child: Text("No data for " +
                        convertConstantsToMessage(
                            con: _filterPeriod,
                            from: frm ?? "",
                            to: too ?? "")),
                  );
                }
                return FinanceFragment(
                  propertyId: widget.propertyId ?? null,
                  propertyName: widget.propertyName,
                  finance: finance,
                  type: "Expense",
                  typeQuery: "Expense",
                  period: _filterPeriod,
                );
              } else {
                return Center(
                  child: Text("Error"),
                );
              }
            }),
            Obx(() {
              if (controller.dataLoading.value == true) {
                return ModalProgressHUD(
                  inAsyncCall: true,
                  opacity: 0.3,
                  color: Colors.black,
                  progressIndicator: CustomLoader(),
                  child: Container(),
                );
              }
              Finance finance = controller.otherList.value;
              if (controller.otherList.value.total != null) {
                if (finance.total == 0) {
                  return Center(
                    child: Text("No data for " +
                        convertConstantsToMessage(
                            con: _filterPeriod,
                            from: frm ?? "",
                            to: too ?? "")),
                  );
                }
                return FinanceFragment(
                  propertyId: widget.propertyId ?? null,
                  propertyName: widget.propertyName,
                  finance: finance,
                  type: "Others",
                  typeQuery: "withdrawal,sdo",
                  period: _filterPeriod,
                );
              } else {
                return Center(
                  child: Text("Error"),
                );
              }
            }),
            // FutureBuilder(
            //     future: controller.getIncome(
            //         propertyID: 1, dataToLoad: "this_month", type: "Expense"),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         //print(snapshot);
            //         Finance finance = snapshot.data;
            //         //print(finance.total);
            //         if (finance.total == 0) {
            //           return Center(
            //             child: Text("No data"),
            //           );
            //         }
            //         return FinanceFragment(
            //           propertyId: widget.propertyId,
            //           propertyName: widget.propertyName,
            //           finance: finance,
            //           type: "Expense",
            //         );
            //       } else {
            //         return Container(
            //           child: Center(
            //             child: CustomLoader(),
            //           ),
            //         );
            //       }
            //     }),
          ],
        ),
      ),
    );
  }
}

class IncomePage extends StatefulWidget {
  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  int _currentColor = 0;
  int? _selectedNode = -1;
  List colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.deepPurple,
    Colors.amber,
    Colors.blueGrey
  ];

  Color getColor(int i) {
    if (colors.length <= _currentColor) {
      _currentColor = 0;
    }

    Color c = colors[_currentColor];
    _currentColor++;
    return HSLColor.fromColor(c).withLightness(0.7).toColor();
  }

  @override
  Widget build(BuildContext context) {
    _currentColor = 0;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            // padding: EdgeInsets.all(16),

            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(8),
              shadowColor: Colors.black.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Outstanding balance",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Rs.5001",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.5),
                      indent: 10,
                      endIndent: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Income",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Rs. 50001",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 0,
                  pieTouchData: PieTouchData(
                      enabled: true,
                      touchCallback: (PieTouchResponse s) {
                        //print(s.touchedSection.touchedSectionIndex);
                        setState(() {
                          _selectedNode = s.touchedSection?.touchedSectionIndex;
                        });
                      }),
                  sections: [
                    PieChartSectionData(
                      value: 5,
                      color: getColor(1),
                      radius: _selectedNode == 0 ? 130 : 100,
                    ),
                    PieChartSectionData(
                      value: 23,
                      color: getColor(2),
                      radius: _selectedNode == 1 ? 130 : 100,
                    ),
                    PieChartSectionData(
                      value: 30,
                      color: getColor(3),
                      radius: _selectedNode == 2 ? 130 : 100,
                    ),
                    PieChartSectionData(
                      value: 50,
                      color: getColor(4),
                      radius: _selectedNode == 3 ? 130 : 100,
                    ),
                  ],
                  // centerSpaceRadius: 10,
                ),
                swapAnimationCurve: Curves.elasticInOut,
                swapAnimationDuration: Duration(milliseconds: 300),
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
                children: [
                  Indicator(color: getColor(1), text: "Food", isSquare: false),
                  Indicator(
                      color: getColor(2), text: "Travel", isSquare: false),
                  Indicator(
                      color: getColor(3), text: "Travel", isSquare: false),
                  Indicator(
                      color: getColor(4), text: "Travel", isSquare: false),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          ListView.separated(
            separatorBuilder: (bx, i) {
              return Divider();
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (bc, i) {
              return ListTile(
                isThreeLine: false,
                title: Text("Hello"),
                subtitle: Text("12 Aug 2021"),
                trailing: Text(
                  "500",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
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
