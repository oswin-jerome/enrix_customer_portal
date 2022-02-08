// To parse this JSON data, do
//
//     final property = propertyFromJson(jsonString);

import 'dart:convert';

Property propertyFromJson(String str) => Property.fromJson(json.decode(str));

// String propertyToJson(Property data) => json.encode(data.toJson());

class Property {
  Property({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.customerId,
    this.ownerName,
    this.propertyType,
    this.noOfUnits,
    this.propertyAddress,
    this.pcity,
    this.plandmark,
    this.yearOfConstruction,
    this.totalSqFt,
    this.noOfFloors,
    this.facing,
    this.contactPname,
    this.mobileNo,
    this.emailId,
    this.paddress,
    this.contactPcity,
    this.pstate,
    this.pidproof,
    this.relationship,
    this.currentlyRented,
    this.ebConsumerNo,
    this.propertyTaxNo,
    this.waterTaxNo,
    this.surveyNo,
    this.pdetails,
    this.bankloan,
    this.propertyName,
    this.authorizationLetter,
    this.rating,
    this.statusPropertyDetails,
    this.statusInspection,
    this.statusApproval,
    this.statusAgreement,
    this.position,
    this.taskCount,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? customerId;
  String? ownerName;
  String? propertyType;
  int? noOfUnits;
  String? propertyAddress;
  String? pcity;
  String? plandmark;
  int? yearOfConstruction;
  int? totalSqFt;
  int? noOfFloors;
  String? facing;
  String? contactPname;
  int? mobileNo;
  String? emailId;
  String? paddress;
  String? contactPcity;
  String? pstate;
  dynamic? pidproof;
  String? relationship;
  int? currentlyRented;
  String? ebConsumerNo;
  String? propertyTaxNo;
  String? waterTaxNo;
  String? surveyNo;
  dynamic? pdetails;
  int? bankloan;
  dynamic? propertyName;
  dynamic? authorizationLetter;
  int? rating;
  String? statusPropertyDetails;
  String? statusInspection;
  String? statusApproval;
  String? statusAgreement;
  int? position;
  int? taskCount;
  bool isApproved() {
    if (statusPropertyDetails != null &&
        statusInspection != null &&
        statusApproval != null &&
        statusAgreement != null) {
      return true;
    }

    return false;
  }

  int stepsApproved() {
    int steps = 0;
    if (statusPropertyDetails != null) {
      steps++;
    }
    if (statusInspection != null) {
      steps++;
    }
    if (statusApproval != null) {
      steps++;
    }
    if (statusAgreement != null) {
      steps++;
    }

    return steps;
  }

  List<String> approvalSteps() {
    return [
      statusPropertyDetails!,
      statusInspection!,
      statusApproval!,
      statusAgreement!
    ];
  }

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customerId: int.parse(json["customer_id"].toString()),
        ownerName: json["owner_name"],
        propertyType: json["property_type"],
        noOfUnits: int.parse(json["no_of_units"].toString()),
        propertyAddress: json["property_address"],
        pcity: json["pcity"],
        plandmark: json["plandmark"],
        yearOfConstruction:
            int.tryParse(json["year_of_construction"].toString()) ?? -1,
        totalSqFt: int.parse(json["total_sq_ft"].toString()),
        noOfFloors: int.parse(json["no_of_floors"].toString()),
        facing: json["facing"],
        contactPname: json["contact_pname"],
        mobileNo: int.tryParse(json["mobile_no"].toString()) ?? 0,
        emailId: json["email_id"],
        paddress: json["paddress"],
        contactPcity: json["contact_pcity"],
        pstate: json["pstate"],
        pidproof: json["pidproof"],
        relationship: json["relationship"],
        currentlyRented:
            int.tryParse(json["currently_rented"].toString()) ?? null,
        ebConsumerNo: json["eb_consumer_no"],
        propertyTaxNo: json["property_tax_no"].toString(),
        waterTaxNo: json["water_tax_no"].toString(),
        surveyNo: json["survey_no"].toString(),
        pdetails: json["pdetails"],
        bankloan: int.tryParse(json["bankloan"].toString()) ?? null,
        propertyName: json["property_name"],
        authorizationLetter: json["authorization_letter"],
        rating: int.parse(json["rating"].toString()),
        statusPropertyDetails: json["status_property_details"],
        statusInspection: json["status_inspection"],
        statusApproval: json["status_approval"],
        statusAgreement: json["status_agreement"],
        position: json['position'] != null
            ? int.parse(json['position'].toString())
            : 0,
        taskCount: json['tasks_count'] != null
            ? int.parse(json['tasks_count'].toString())
            : 0,
      );
}
