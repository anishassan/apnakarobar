import 'dart:convert';

import 'package:sales_management/models/inventory_model.dart';

List<SalesModel> salesModelFromJson(String str) =>
    List<SalesModel>.from(json.decode(str).map((x) => SalesModel.fromJson(x)));

String salesModelToJson(List<SalesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesModel {
  int? id;
  String soldDate;
  List<Datum> data;

  SalesModel({
    this.id,
    required this.soldDate,
    required this.data,
  });

  factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        id: json["id"],
        soldDate: json["soldDate"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => x)).toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "soldDate": soldDate,
        "data": data == null
            ? []
            : List<dynamic>.from(data.map((x) => x.toJson())).toList(),
      };
}
class Datum {
  int? customerId;
  String? name;
  String? contact;
  String? remainigBalance;
  String? paidBalance;
  List<InventoryItem>? soldProducts;

  Datum({
    this.customerId,
    this.name,
    this.contact,
    this.remainigBalance,
    this.paidBalance,
    this.soldProducts,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        customerId: json["id"],
        name: json["name"],
        contact: json["contact"],
        remainigBalance: json["remainigBalance"],
        paidBalance: json["paidBalance"],
        soldProducts: json["soldProducts"] == null
            ? []
            : List<InventoryItem>.from(
                json["soldProducts"]!.map((x) => InventoryItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": customerId,
        "name": name,
        "contact": contact,
        "remainigBalance": remainigBalance,
        "paidBalance": paidBalance,
        "soldProducts": soldProducts == null
            ? []
            : List<dynamic>.from(soldProducts!.map((x) => x.toJson())),
      };

  Datum copyWith({
    int? customerId,
    String? name,
    String? contact,
    String? remainigBalance,
    String? paidBalance,
    List<InventoryItem>? soldProducts,
  }) {
    return Datum(
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      remainigBalance: remainigBalance ?? this.remainigBalance,
      paidBalance: paidBalance ?? this.paidBalance,
      soldProducts: soldProducts ?? this.soldProducts,
    );
  }
}