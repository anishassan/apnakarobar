import 'dart:convert';

ReportModel reportModelFromJson(String str) =>
    ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportData {
  int? id;
  String? name;
  String? contact;
  String? soldDate;
  List<ReportModel>? data;

  ReportData({
    this.id,
    this.name,
    this.contact,
    this.soldDate,
    this.data,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) => ReportData(
        id: json["id"],
        name: json["name"],
        contact: json["contact"],
        soldDate: json['soldDate'],
        data: json["data"] == null
            ? []
            : List<ReportModel>.from(
                json["data"]!.map((x) => ReportModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contact": contact,
        'soldDate': soldDate,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ReportModel {
  String? date;
  String? sales;
  String? soldDate;
  int? id;
  String? productName;

  String? paidBalance;
  String? remainingBalance;

  ReportModel({
    this.date,
    this.sales,
    this.soldDate,
    this.id,
    this.productName,
    this.paidBalance,
    this.remainingBalance,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        date: json["date"],
        sales: json["sales"],
        paidBalance: json["paidBalance"],
        id: json['id'],
        soldDate: json['soldDate'],
        productName: json['productName'],
        remainingBalance: json["remainingBalance"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "id": id,
        "productName": productName,
        "sales": sales,
        'soldDate': soldDate,
        "paidBalance": paidBalance,
        "remainingBalance": remainingBalance,
      };
}
