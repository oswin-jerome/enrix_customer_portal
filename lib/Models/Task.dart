// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

List<Task> taskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  Task(
      {required this.id,
      this.propertyId,
      required this.discription,
      required this.status,
      this.customerId,
      required this.createdAt,
      required this.updatedAt,
      this.requestId,
      this.userId,
      this.requestCategoryId,
      required this.approved,
      required this.createdBy,
      required this.replies,
      required this.progress});

  int id;
  int? propertyId;
  String discription;
  String status;
  dynamic customerId;
  String createdAt;
  String updatedAt;
  dynamic requestId;
  dynamic userId;
  int? requestCategoryId;
  String approved;
  String createdBy;
  List<Reply> replies;
  int progress;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        propertyId: int.tryParse(json["property_id"].toString()) ?? null,
        discription: json["discription"],
        status: json["status"],
        customerId: json["customer_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        requestId: json["request_id"],
        userId: json["user_id"],
        requestCategoryId:
            int.tryParse(json["request_category_id"].toString()) ?? null,
        approved: json["approved"] ?? "",
        createdBy: json["created_by"],
        progress: json['pogress'] ?? 0,
        replies:
            List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "property_id": propertyId,
        "discription": discription,
        "status": status,
        "customer_id": customerId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "request_id": requestId,
        "user_id": userId,
        "request_category_id": requestCategoryId,
        "approved": approved,
        "created_by": createdBy,
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
      };
}

class Reply {
  Reply({
    required this.description,
    required this.createdAt,
  });

  String description;
  String createdAt;

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        description: json["description"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "created_at": createdAt,
      };
}
