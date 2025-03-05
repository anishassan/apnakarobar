import 'dart:convert';

// Top-level function to parse JSON into the InventoryModel model
InventoryModel InventoryModelFromJson(String str) =>
    InventoryModel.fromJson(json.decode(str));

// Top-level function to convert InventoryModel model to JSON string
String InventoryModelToJson(InventoryModel data) => json.encode(data.toJson());

class InventoryModel {
  final String addingDate;
  final List<InventoryItem> data;

  InventoryModel({
    required this.addingDate,
    required this.data,
  });

  // Factory method to parse JSON into InventoryModel
  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
        addingDate: json['addingDate'],
        data: List<InventoryItem>.from(
            json['data'].map((x) => InventoryItem.fromJson(x))),
      );

  // Method to convert InventoryModel to JSON
  Map<String, dynamic> toJson() => {
        'addingDate': addingDate,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
class InventoryItem {
  final int? id;
  final String? title;
  final String? date;
   String? totalprice;
   String? productprice;
    String quantity;
    String? type;
   String? lastPurchase;
   String? lastSale;
  final String? buySaleQuantity;
  final String? desc;
  final String? stock;

  InventoryItem({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.totalprice,
    required this.productprice,
    required this.quantity,
    required this.desc,
    required this.buySaleQuantity,
    required this.lastPurchase,
    required this.lastSale,
    required this.stock,
  });

  // Factory method to parse JSON into InventoryItem
  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json['id'],
        lastPurchase: json['lastPurchase'],
        lastSale: json['lastSale'],
        desc: json['desc'],
        type: json['type'],
        title: json['title'],
        buySaleQuantity: json['buySaleQ'],
        date: json['date'],
        totalprice: json['totalprice'].toString(),
        productprice: json['productprice'].toString(),
        quantity: json['quantity'].toString(),
        stock: json['stock'],
      );

  // Method to convert InventoryItem to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type':type,
        'date': date,
        'totalprice': totalprice,
        'productprice': productprice,
        'quantity': quantity,
        'lastPurchase': lastPurchase,
        'lastSale': lastSale,
        "buySaleQ":buySaleQuantity,
        'desc': desc,
        'stock': stock,
      };

  // CopyWith method
  InventoryItem copyWith({
    int? id,
    String? title,
    String? date,
    String? totalprice,
    String? productprice,
    String? quantity,
    String? lastPurchase,
    String? lastSale,
    String? desc,
  String? type,
    String? buySaleQuantity,
    String? stock,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      buySaleQuantity: buySaleQuantity ?? this.buySaleQuantity,
      date: date ?? this.date,
      totalprice: totalprice ?? this.totalprice,
      productprice: productprice ?? this.productprice,
      quantity: quantity ?? this.quantity,
      lastPurchase: lastPurchase ?? this.lastPurchase,
      lastSale: lastSale ?? this.lastSale,
      desc: desc ?? this.desc,
      stock: stock ?? this.stock,
    );
  }
}