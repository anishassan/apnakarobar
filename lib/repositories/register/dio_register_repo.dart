import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:sales_management/models/register_res_model.dart';
import 'package:sales_management/network/api_services.dart';
import 'package:sales_management/network/api_url.dart';
import 'package:sales_management/repositories/register/register_repo.dart';
import 'package:sales_management/utils/toast.dart';

class DioRegisterRepo implements RegisterRepo{
  @override
  Future<RegisterResModel> register({required BuildContext context, required String name,required String category, required String email, required String address, required String contact})async {
    RegisterResModel model = RegisterResModel.fromJson({});
    final data = {
	"title" : name,
	"email" : email,
	"contact" : contact,
	"address" : address,
  "category":category,
};
    try{
      final res = await API().postRequest(context, ApiUrl.register, jsonEncode(data));
      if(res.statusCode == 200){
        // final decode = jsonDecode(res.data);
        
        model = RegisterResModel.fromJson(res.data);
      }else{
         final decode = jsonDecode(res.data);
         toast(msg: decode['message'], context: context);
      }
    }catch(e){
      print(e);
    }
    return model;
  }
  
}