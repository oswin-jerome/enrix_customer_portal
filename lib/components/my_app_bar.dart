import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  MyTabBar({this.tabs, this.tabController});

  final TabController? tabController;
  final List<Widget>? tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.transparent,
        indicatorPadding: EdgeInsets.symmetric(horizontal: 3),
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(3, 3),
              spreadRadius: 1,
            ),
          ],
        ),
        labelPadding: EdgeInsets.all(0),
        indicatorWeight: 0,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
        ),
        tabs: tabs!);
  }
}
