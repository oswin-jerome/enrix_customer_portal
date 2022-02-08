// To parse this JSON data, do
//
//     final document = documentFromJson(jsonString);

import 'dart:convert';

List<Document> documentFromJson(String str) =>
    List<Document>.from(json.decode(str).map((x) => Document.fromJson(x)));

String documentToJson(List<Document> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Document {
  Document({
    this.id,
    this.receiptName,
    this.receiptType,
    this.recFileName,
    this.propertyId,
    this.customerId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? receiptName;
  String? receiptType;
  String? recFileName;
  int? propertyId;
  dynamic customerId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"],
        receiptName: json["receipt_name"],
        receiptType: json["receipt_type"],
        recFileName: json["rec_file_name"],
        propertyId: int.parse(json["property_id"]),
        customerId: json["customer_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "receipt_name": receiptName,
        "receipt_type": receiptType,
        "rec_file_name": recFileName,
        "property_id": propertyId,
        "customer_id": customerId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
