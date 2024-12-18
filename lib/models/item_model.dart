import 'dart:convert';

ItemModel itemModelFromJson(String str) => ItemModel.fromJson(json.decode(str));

String itemModelToJson(ItemModel data) => json.encode(data.toJson());

class ItemModel {
  int? id;
    String? title;
    String? date;
    String? totalprice;
    String? productprice;
    String? lastSale;
    String? lastPurchase;
    String? desc;
    String? quantity;
    int? dateId;
    String? stock;

    ItemModel({
        this.title,
        this.date,
        this.id,
        this.totalprice,
        this.lastSale,
        this.lastPurchase,
        this.desc,
        this.productprice,
        this.quantity,
        this.dateId,
        this.stock,
    });

    factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        title: json["title"],
        date: json["date"],id:json['id'],
        totalprice: json["totalprice"],
        productprice: json["productprice"],
        lastPurchase: json['lastPurchase'],
        lastSale: json['lastSale'],
        quantity: json["quantity"],
        dateId:json['dateId'],
        stock: json["stock"],
        desc: json['desc']
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "dateId":dateId,
        "date": date,
        "id":id,
        "totalprice": totalprice,
        "productprice": productprice,
        "quantity": quantity,
        "stock": stock,
        'lastSale':lastSale,
        'lastPurchase':lastPurchase,
        "desc":desc,
    };
     ItemModel copyWith({
    int? id,
    String? title,
    String? date,
     String? lastSale,
    String? lastPurchase,
    String? desc,
    String? totalprice,
    String? productprice,
    String? quantity,
    String? stock,
    int? dateId,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      totalprice: totalprice ?? this.totalprice,
      productprice: productprice ?? this.productprice,
      quantity: quantity ?? this.quantity,
      stock: stock ?? this.stock,
      dateId: dateId ?? this.dateId,
      lastPurchase: lastPurchase ?? this.lastPurchase,
      lastSale: lastSale ?? this.lastSale,
      desc: desc?? this.desc,
    );
  }
}
