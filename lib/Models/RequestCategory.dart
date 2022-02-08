// To parse this JSON data, do
//
//     final requestCategory = requestCategoryFromJson(jsonString);

import 'dart:convert';

List<RequestCategory> requestCategoryFromJson(String str) =>
    List<RequestCategory>.from(
        json.decode(str).map((x) => RequestCategory.fromJson(x)));

String requestCategoryToJson(List<RequestCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestCategory {
  RequestCategory({
    required this.id,
    required this.requestCategory,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String requestCategory;
  DateTime createdAt;
  DateTime updatedAt;

  factory RequestCategory.fromJson(Map<String, dynamic> json) =>
      RequestCategory(
        id: json["id"],
        requestCategory: json["request_category"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_category": requestCategory,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
