import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sales_management/models/sales_model.dart';

abstract class CustomerRepo{
  Future uploadCustomer({required BuildContext context, required int currentUserId, required Datum customer});
  Future uploadSales({required BuildContext context,required String date, required int currentUserId,required int saleId, required List<Datum> customer});
}