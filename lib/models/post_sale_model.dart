import 'dart:convert';

import 'package:sales_management/models/post_purchase_model.dart';

PostSaleModel postSaleModelFromJson(String str) => PostSaleModel.fromJson(json.decode(str));

String postSaleModelToJson(PostSaleModel data) => json.encode(data.toJson());

class PostSaleModel {
    int? businessId;
    List<PostCustomer>? data;

    PostSaleModel({
        this.businessId,
        this.data,
    });

    factory PostSaleModel.fromJson(Map<String, dynamic> json) => PostSaleModel(
        businessId: json["business_id"],
        data: json["data"] == null ? [] : List<PostCustomer>.from(json["data"]!.map((x) => PostCustomer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "business_id": businessId,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class PostCustomer {
    String? soldDate;
    int? customerId;
    int? totalAmount;
    int? discount;
    int? paidAmount;
    List<PostSoldProduct>? soldProducts;

    PostCustomer({
        this.soldDate,
        this.customerId,
        this.discount,
        this.paidAmount,
        this.soldProducts,
    });

    factory PostCustomer.fromJson(Map<String, dynamic> json) => PostCustomer(
        soldDate: json["soldDate"],
        customerId: json["customer_id"],
        discount: json["discount"],
        paidAmount: json["paidAmount"],
        soldProducts: json["soldProducts"] == null ? [] : List<PostSoldProduct>.from(json["soldProducts"]!.map((x) => PostSoldProduct.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "soldDate":soldDate!,
        "customer_id": customerId,
        "discount": discount,
        "paidAmount": paidAmount,
        "soldProducts": soldProducts == null ? [] : List<dynamic>.from(soldProducts!.map((x) => x.toJson())),
    };
}

