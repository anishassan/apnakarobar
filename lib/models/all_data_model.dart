import 'dart:convert';

AllDataModel allDataModelFromJson(String str) => AllDataModel.fromJson(json.decode(str));

String allDataModelToJson(AllDataModel data) => json.encode(data.toJson());

class AllDataModel {
    bool? success;
    BusinessInfo? businessInfo;
    List<Inventory>? inventory;
    List<Customer>? suppliers;
    List<Customer>? customers;
    List<Purchase>? purchases;
    List<Purchase>? sales;

    AllDataModel({
        this.success,
        this.businessInfo,
        this.inventory,
        this.suppliers,
        this.customers,
        this.purchases,
        this.sales,
    });

    factory AllDataModel.fromJson(Map<String, dynamic> json) => AllDataModel(
        success: json["success"],
        businessInfo: json["business_info"] == null ? null : BusinessInfo.fromJson(json["business_info"]),
        inventory: json["inventory"] == null ? [] : List<Inventory>.from(json["inventory"]!.map((x) => Inventory.fromJson(x))),
        suppliers: json["suppliers"] == null ? [] : List<Customer>.from(json["suppliers"]!.map((x) => Customer.fromJson(x))),
        customers: json["customers"] == null ? [] : List<Customer>.from(json["customers"]!.map((x) => Customer.fromJson(x))),
        purchases: json["purchases"] == null ? [] : List<Purchase>.from(json["purchases"]!.map((x) => Purchase.fromJson(x))),
        sales: json["sales"] == null ? [] : List<Purchase>.from(json["sales"]!.map((x) => Purchase.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "business_info": businessInfo?.toJson(),
        "inventory": inventory == null ? [] : List<dynamic>.from(inventory!.map((x) => x.toJson())),
        "suppliers": suppliers == null ? [] : List<dynamic>.from(suppliers!.map((x) => x.toJson())),
        "customers": customers == null ? [] : List<dynamic>.from(customers!.map((x) => x.toJson())),
        "purchases": purchases == null ? [] : List<dynamic>.from(purchases!.map((x) => x.toJson())),
        "sales": sales == null ? [] : List<dynamic>.from(sales!.map((x) => x.toJson())),
    };
}

class BusinessInfo {
    int? id;
    String? title;
    String? slug;
    String? email;
    String? contact;
    String? address;
    dynamic category;
    DateTime? createdAt;
    DateTime? updatedAt;

    BusinessInfo({
        this.id,
        this.title,
        this.slug,
        this.email,
        this.contact,
        this.address,
        this.category,
        this.createdAt,
        this.updatedAt,
    });

    factory BusinessInfo.fromJson(Map<String, dynamic> json) => BusinessInfo(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        email: json["email"],
        contact: json["contact"],
        address: json["address"],
        category: json["category"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "email": email,
        "contact": contact,
        "address": address,
        "category": category,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Customer {
    int? id;
    String? name;
    String? contact;
    dynamic address;
    int? balance;

    Customer({
        this.id,
        this.name,
        this.contact,
        this.address,
        this.balance,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        contact: json["contact"],
        address: json["address"],
        balance: json["balance"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contact": contact,
        "address": address,
        "balance": balance,
    };
}

class Inventory {
    int? businessId;
    int? id;
    String? title;
    String? measurement;
    dynamic description;
    int? purchasePrice;
    int? salePrice;
    int? currentStock;
    int? currentValue;

    Inventory({
        this.businessId,
        this.id,
        this.title,
        this.measurement,
        this.description,
        this.purchasePrice,
        this.salePrice,
        this.currentStock,
        this.currentValue,
    });

    factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        businessId: json["business_id"],
        id: json["id"],
        title: json['title'],
        measurement:json["measurement"],
        description: json["description"],
        purchasePrice: json["purchase_price"],
        salePrice: json["sale_price"],
        currentStock: json["current_stock"],
        currentValue: json["current_value"],
    );

    Map<String, dynamic> toJson() => {
        "business_id": businessId,
        "id": id,
        "title": title,
        "measurement": measurement,
        "description": description,
        "purchase_price": purchasePrice,
        "sale_price": salePrice,
        "current_stock": currentStock,
        "current_value": currentValue,
    };
}





class Purchase {
    int? id;
    String? soldDate;
    List<Datum2>? data;

    Purchase({
        this.id,
        this.soldDate,
        this.data,
    });

    factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        id: json["id"],
        soldDate: json["soldDate"],
        data: json["data"] == null ? [] : List<Datum2>.from(json["data"]!.map((x) => Datum2.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "soldDate": soldDate,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum2 {
    int? id;
    String? name;
    int? discount;
    String? contact;
    int? remainigBalance;
    int? paidBalance;
    List<SoldProduct>? soldProducts;

    Datum2({
        this.id,
        this.name,
        this.discount,
        this.contact,
        this.remainigBalance,
        this.paidBalance,
        this.soldProducts,
    });

    factory Datum2.fromJson(Map<String, dynamic> json) => Datum2(
        id: json["id"],
        name: json["name"],
        discount: json["discount"],
        contact: json["contact"],
        remainigBalance: json["remainigBalance"],
        paidBalance: json["paidBalance"],
        soldProducts: json["soldProducts"] == null ? [] : List<SoldProduct>.from(json["soldProducts"]!.map((x) => SoldProduct.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "discount": discount,
        "contact": contact,
        "remainigBalance": remainigBalance,
        "paidBalance": paidBalance,
        "soldProducts": soldProducts == null ? [] : List<dynamic>.from(soldProducts!.map((x) => x.toJson())),
    };
}

class SoldProduct {
    int? id;
    String? title;
    String? date;
    int? totalprice;
    int? productprice;
    int? quantity;
    int? lastPurchase;
    int? lastSale;
    int? buySaleQ;
    String? desc;
    String? stock;

    SoldProduct({
        this.id,
        this.title,
        this.date,
        this.totalprice,
        this.productprice,
        this.quantity,
        this.lastPurchase,
        this.lastSale,
        this.buySaleQ,
        this.desc,
        this.stock,
    });

    factory SoldProduct.fromJson(Map<String, dynamic> json) => SoldProduct(
        id: json["id"],
        title: json["title"],
        date: json["date"],
        totalprice: json["totalprice"],
        productprice: json["productprice"],
        quantity: json["quantity"],
        lastPurchase: json["lastPurchase"],
        lastSale: json["lastSale"],
        buySaleQ: json["buySaleQ"],
        desc: json["desc"],
        stock:json["stock"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "date": date,
        "totalprice": totalprice,
        "productprice": productprice,
        "quantity": quantity,
        "lastPurchase": lastPurchase,
        "lastSale": lastSale,
        "buySaleQ": buySaleQ,
        "desc": desc,
        "stock": stock,
    };
}

