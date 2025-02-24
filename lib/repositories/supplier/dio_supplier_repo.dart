import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales_management/models/post_purchase_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/network/api_services.dart';
import 'package:sales_management/network/api_url.dart';
import 'package:sales_management/repositories/supplier/supplier_repo.dart';

class DioSupplierRepo implements SupplierRepo {
  @override
  Future insertSupplierData(
      {required BuildContext context,
      required Datum supplier,
      required int currentUserId}) async {
    try {
      final data = {
        "supplier_id": supplier.customerId,
        "business_id": currentUserId,
        "name": supplier.name,
        "contact": supplier.contact,
        "balance": double.parse(supplier.remainigBalance ?? '0.0')
      };
      print("SUPPLIER MODEL $data");
      final response =
          await API().postRequest(context, ApiUrl.supplierInsert, data);
      if (response.data['success'] == true) {
        print('Supplier Upload Successfully');
      } else {
        print('Supplier Upload Error ${response.data}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future uploadPurchase(
      {required BuildContext context,
      required String date,
      required int saleId,
      required int currentUserId,
      required List<Datum> supplier}) async {
    try {
      print("Supplier Length ${supplier.length}");
      final model = PostPurchaseModel(
        businessId: currentUserId,
        data: supplier
            .map((e) => PostSupplier(
                  discount: int.tryParse(e.discount ?? '0') ?? 0,
                  supplierId: e.customerId,
                  soldDate: date,
                  paidAmount: int.tryParse(e.paidBalance ?? '0') ?? 0,
                  soldProducts: e.soldProducts!
                          .map((s) => PostSoldProduct(
                                title: s.title,
                                price:
                                    (double.tryParse(s.productprice ?? '0.0') ??
                                            0.0)
                                        .toInt(),
                                id: s.id,
                                quantity:
                                    int.tryParse(s.buySaleQuantity ?? '0') ?? 0,
                              ))
                          .toList() ??
                      [],
                ))
            .toList(),
      );

      print("MODEL DATA ${model.toJson()}");
      // List<int?> productId = supplier.soldProducts!.map((e) => e.id).toList();
      // List<int?> quantity =
      //     supplier.soldProducts!.map((e) => int.parse(e.buySaleQuantity??'0')).toList();
      // List<double> price = supplier.soldProducts!
      //     .map((e) => double.parse(e.productprice ?? '0.0'))
      //     .toList();
      // print('Sale ID $saleId');
      // final data = {
      //   "purchase_id": saleId,
      //   "business_id":currentUserId ,
      //   "purchase_date": date,
      //   "supplier_id": supplier.customerId,
      //   "detail_id": productId,
      //   "cart_items": [1],
      //   "quantity": quantity,

      //   "price": price,
      //   "investments": [supplier.paidBalance],
      //   "profit": [100],
      //   "sub_total": 750,
      //   "discount": double.parse(supplier.discount ?? '0.0'),
      //   "total_amount": double.parse(supplier.remainigBalance ?? '0.0') +
      //       double.parse(supplier.paidBalance ?? '0.0') +
      //       double.parse(supplier.discount ?? '0.0'),
      //   "paid_amount": double.parse(supplier.paidBalance ?? '0.0'),
      //   "balance": double.parse(supplier.remainigBalance ?? '0.0'),
      //   "status": double.parse(supplier.remainigBalance ?? '0.0') == 0.0
      //       ? 'paid'
      //       : "unpaid"
      // };
      final response = await API()
          .postRequest(context, ApiUrl.purchaseInsert, model.toJson());
      if (response.data['success'] == true) {
        print('Purchase Upload Successfully ${response.data}');
        print(response.data);
      } else {
        print('Purchase Upload Error: ${response.data}');
      }
    } catch (e) {
      print(e);
    }
  }
}
