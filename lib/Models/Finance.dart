// To parse this JSON data, do
//
//     final finance = financeFromJson(jsonString);

import 'dart:convert';

Finance financeFromJson(String str) => Finance.fromJson(json.decode(str));

String financeToJson(Finance data) => json.encode(data.toJson());

class Finance {
  Finance({
    this.outstandingAmount,
    this.total,
    this.categories,
    this.entries,
    this.dates,
  });

  String? outstandingAmount;
  double? total;
  List<Category>? categories;
  List<Entry>? entries;
  List<Date>? dates;

  factory Finance.fromJson(Map<String, dynamic> json) => Finance(
        outstandingAmount: json["outstanding_amount"],
        total: double.tryParse(json["total"].toString()) ?? 0.0,
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        entries:
            List<Entry>.from(json["entries"].map((x) => Entry.fromJson(x))),
        dates: List<Date>.from(json["dates"].map((x) => Date.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "outstanding_amount": outstandingAmount,
        "total": total,
        "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
        "entries": List<dynamic>.from(entries!.map((x) => x.toJson())),
        "dates": List<dynamic>.from(dates!.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.category,
    this.total,
  });

  String? category;
  double? total;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        category: json["category"],
        total: double.tryParse(json["total"].toString()) ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "total": total,
      };
}

class Date {
  Date({
    this.createdAt,
    this.total,
  });

  DateTime? createdAt;
  double? total;

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        createdAt: DateTime.tryParse(json["created_at"]),
        total: double.tryParse(json["total"].toString()) ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt!.toIso8601String(),
        "total": total,
      };
}

class Entry {
  Entry({
    this.category,
    this.description,
    this.date,
    this.amount,
  });

  String? category;
  String? description;
  DateTime? date;
  double? amount;

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        category: json["category"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        amount: double.tryParse(json["amount"].toString()) ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "description": description,
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "amount": amount,
      };
}
