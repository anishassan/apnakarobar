import 'package:flutter/material.dart';
import 'package:sales_management/models/sales_model.dart';

abstract class SupplierRepo{
  Future insertSupplierData({
    required BuildContext context,
required  Datum supplier,
required int currentUserId
  });

  Future uploadPurchase({required BuildContext context,required String date,required List<SalesModel> purchaseData, required int currentUserId,required int saleId, required List<Datum> supplier});
}