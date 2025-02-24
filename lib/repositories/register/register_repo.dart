import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sales_management/models/all_data_model.dart';
import 'package:sales_management/models/register_res_model.dart';

abstract class RegisterRepo{
  Future<RegisterResModel> register({
    required BuildContext context,required String name,required String email,required String address,required String category,required String contact,
  });
  Future <AllDataModel> getAllData({required BuildContext context,required String email});
}