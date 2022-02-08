// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

import 'dart:convert';

List<Payment> paymentFromJson(String str) =>
    List<Payment>.from(json.decode(str).map((x) => Payment.fromJson(x)));

String paymentToJson(List<Payment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Payment {
  Payment({
    this.id,
    this.customerId,
    this.propertyId,
    this.amount,
    this.url,
    this.description,
    this.title,
    this.razorId,
    this.paidAt,
    this.razorpayPaymentId,
    this.razorpayInvoiceId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? customerId;
  dynamic propertyId;
  int? amount;
  String? url;
  String? description;
  String? title;
  String? razorId;
  dynamic paidAt;
  dynamic razorpayPaymentId;
  dynamic razorpayInvoiceId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        customerId: int.parse(json["customer_id"].toString()),
        propertyId: json["property_id"],
        amount: int.parse(json["amount"].toString()),
        url: json["url"],
        description: json["description"],
        title: json["title"],
        razorId: json["razor_id"],
        paidAt: json["paid_at"],
        razorpayPaymentId: json["razorpay_payment_id"],
        razorpayInvoiceId: json["razorpay_invoice_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "property_id": propertyId,
        "amount": amount,
        "url": url,
        "description": description,
        "title": title,
        "razor_id": razorId,
        "paid_at": paidAt,
        "razorpay_payment_id": razorpayPaymentId,
        "razorpay_invoice_id": razorpayInvoiceId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
