import 'package:customer_portal/others/pie_chart.dart';
import 'package:customer_portal/pages/finance/financeReport.dart';
import 'package:customer_portal/pages/finance/incomeReportPage.dart';
import 'package:flutter/material.dart';

class FinanceReportCategoryPage extends StatefulWidget {
  int propertId;
  String propertyName;
  FinanceReportCategoryPage(
      {required this.propertId, required this.propertyName});
  @override
  _FinanceReportCategoryPageState createState() =>
      _FinanceReportCategoryPageState();
}

class _FinanceReportCategoryPageState extends State<FinanceReportCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        title: Text("Reports"),
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: [
          GestureDetector(
            onTap: () {
              navigateWithFade(
                context,
                FinanceReportPage(
                  propertyId: widget.propertId,
                  propertyName: widget.propertyName,
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(3, 3),
                    )
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder,
                    size: 130,
                    color: Colors.grey,
                  ),
                  Text("Finance")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
