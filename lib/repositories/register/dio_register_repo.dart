import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:sales_management/models/all_data_model.dart';
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
  
  @override
  Future<AllDataModel> getAllData({required BuildContext context, required String email}) async{
    AllDataModel data = AllDataModel.fromJson({});
 try{
  final response = await API().getRequest(context, "${ApiUrl.getCompleteData}/$email");
 if(response.data['success']== true){
  
  data = AllDataModel.fromJson(response.data);
  print(data.businessInfo?.email??'');
 }

 }catch(e){
  print(e);
 }
 return data;
  }
  
}