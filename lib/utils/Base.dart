import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class Base {
  // static var baseUrl = "http://192.168.0.101:8000/api/";
  // static var baseUrlWithoutApi = "http://192.168.0.101:8000/";
  static DateFormat formaterr = DateFormat('dd-MM-yyyy');
  static DateFormat userDate = DateFormat('MMM y');

  static var baseUrl = "https://admin.enrixpropertymanagement.in/api/";
  static var baseUrlWithoutApi = "https://admin.enrixpropertymanagement.in/";
}

Color getColor(String text) {
  switch (text) {
    case "open":
      return Colors.red;
      break;
    case "rejected":
      return Colors.red;
      break;
    case "priority":
      return Colors.red;
      break;
    case "on process":
      return Colors.orange;
      break;
    case "closed":
      return Colors.green;
      break;
    default:
      return Colors.orange;
  }
}
