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
      required List<SalesModel> purchaseData,
      required int currentUserId,
      required List<Datum> supplier}) async {
    try {
    
           
      List<Map<String, dynamic>> newSalesList = [];
      for (var d in purchaseData) {
        for (var x in d.data) {
          newSalesList.add(PostSupplier(
            discount: int.tryParse(x.discount ?? '0') ?? 0,
            supplierId: x.customerId,
            soldDate: d.soldDate,
            paidAmount: int.tryParse(x.paidBalance ?? '0') ?? 0,
            soldProducts: (x.soldProducts ?? [])
                .map((s) => PostSoldProduct(
                      title: s.title,
                      price: (double.tryParse(s.productprice ?? '0.0') ?? 0.0)
                          .toInt(),
                      id: s.id,
                      quantity: int.tryParse(s.buySaleQuantity ?? '0') ?? 0,
                    ))
                .toList(),
          ).toJson());
        }
      }
      final l = {
        "business_id": currentUserId,
        "data": newSalesList,
      };
      print("Purchase Module +++++++++++++++ $l");
      final response = await API().postRequest(context, ApiUrl.purchaseInsert, {
        "business_id": currentUserId,
        "data": newSalesList,
      });
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
