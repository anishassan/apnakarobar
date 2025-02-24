import 'dart:convert';

PostPurchaseModel postPurchaseModelFromJson(String str) => PostPurchaseModel.fromJson(json.decode(str));

String postPurchaseModelToJson(PostPurchaseModel data) => json.encode(data.toJson());

class PostPurchaseModel {
    int? businessId;
    List<PostSupplier>? data;

    PostPurchaseModel({
        this.businessId,
        this.data,
    });

    factory PostPurchaseModel.fromJson(Map<String, dynamic> json) => PostPurchaseModel(
        businessId: json["business_id"],
        data: json["data"] == null ? [] : List<PostSupplier>.from(json["data"]!.map((x) => PostSupplier.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "business_id": businessId,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class PostSupplier {
    String? soldDate;
    int? supplierId;
    
    int? discount;
    int? paidAmount;
    List<PostSoldProduct>? soldProducts;

    PostSupplier({
        this.soldDate,
        this.supplierId,
    
        this.discount,
        this.paidAmount,
        this.soldProducts,
    });

    factory PostSupplier.fromJson(Map<String, dynamic> json) => PostSupplier(
        soldDate: json["soldDate"],
        supplierId: json["supplier_id"],
      
        discount: json["discount"],
        paidAmount: json["paidAmount"],
        soldProducts: json["soldProducts"] == null ? [] : List<PostSoldProduct>.from(json["soldProducts"]!.map((x) => PostSoldProduct.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "soldDate": soldDate,
        "supplier_id": supplierId,
       
        "discount": discount,
        "paidAmount": paidAmount,
        "soldProducts": soldProducts == null ? [] : List<dynamic>.from(soldProducts!.map((x) => x.toJson())),
    };
}

class PostSoldProduct {
    int? id;
    String? title;
    int? price;
    int? quantity;

    PostSoldProduct({
        this.id,
        this.title,
        this.price,
        this.quantity,
    });

    factory PostSoldProduct.fromJson(Map<String, dynamic> json) => PostSoldProduct(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "quantity": quantity,
    };
}
