// To parse this JSON data, do
//
//     final activityLogGroup = activityLogGroupFromJson(jsonString);

import 'dart:convert';

ActivityLogGroup activityLogGroupFromJson(String str) =>
    ActivityLogGroup.fromJson(json.decode(str));

String activityLogGroupToJson(ActivityLogGroup data) =>
    json.encode(data.toJson());

class ActivityLogGroup {
  ActivityLogGroup({
    this.date,
    this.month,
    this.year,
    this.data,
  });

  DateTime? date;
  String? month;
  String? year;
  List<Datum>? data;

  factory ActivityLogGroup.fromJson(Map<String, dynamic> json) =>
      ActivityLogGroup(
        // date: DateTime.parse(json["date"]),
        month: json["month"].toString(),
        year: json["year"].toString(),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {this.id,
      this.activityType,
      this.analysis,
      this.followUp,
      this.recommentation,
      this.date,
      this.followUpStatus,
      this.activityStatus,
      this.propertyId,
      this.createdAt,
      this.updatedAt,
      this.isPriority,
      this.imageFiles});

  int? id;
  String? activityType;
  String? analysis;
  String? followUp;
  String? recommentation;
  DateTime? date;
  String? followUpStatus;
  String? activityStatus;
  int? propertyId;
  String? createdAt;
  String? updatedAt;
  int? isPriority;
  String? imageFiles;
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        activityType: json["activity_type"],
        analysis: json["analysis"],
        followUp: json["follow_up"].toString(),
        recommentation: json["recommentation"],
        date: DateTime.parse(json["date"]),
        followUpStatus: json["follow_up_status"],
        activityStatus: json["activity_status"],
        propertyId: int.parse(json["property_id"].toString()),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isPriority: int.parse(json["is_priority"].toString()),
        imageFiles: json["imageFile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "activity_type": activityType,
        "analysis": analysis,
        "follow_up": followUp,
        "recommentation": recommentation,
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "follow_up_status": followUpStatus,
        "activity_status": activityStatus,
        "property_id": propertyId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
