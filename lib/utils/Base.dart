import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class Base {
  // static var baseUrl = "http://192.168.1.10:8000/api/";
  // static var baseUrlWithoutApi = "http://192.168.1.10:8000/";
  static DateFormat formaterr = DateFormat('dd-MM-yyyy');
  static DateFormat userDate = DateFormat('MMM y');

  static var baseUrl = "http://uat.enrix.in/api/";
  static var baseUrlWithoutApi = "http://uat.enrix.in/";
}

Color accent = const Color(0xFFC74B50);

Color getColor(String text) {
  switch (text) {
    case "open":
      return Colors.red;
    case "rejected":
      return Colors.red;
    case "priority":
      return Colors.red;
    case "on process":
      return Colors.orange;
    case "closed":
      return Colors.green;
    default:
      return Colors.orange;
  }
}
