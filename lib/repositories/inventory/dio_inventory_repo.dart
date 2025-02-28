import 'package:flutter/src/widgets/framework.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/item_model.dart';
import 'package:sales_management/network/api_services.dart';
import 'package:sales_management/network/api_url.dart';
import 'package:sales_management/repositories/inventory/inventory_repo.dart';

class DioInventoryRepo implements InventoryRepo{
  @override
  Future uploadInventory({required InventoryItem inventory, required BuildContext context,required int currentUserId}) async{
   try{

  final data ={
  "business_id":currentUserId,
    "item_id" : inventory.id,
	  "title":inventory.title,
    
    "measurement" : inventory.stock,
    "description" :inventory.desc,
    "purchase_price":double.parse(inventory.lastPurchase??'0.0'),
    "sale_price":double.parse(inventory.lastSale??'0.0'),
    "current_stock":int.parse(inventory.quantity??'0'),
    "current_value":double.parse(inventory.productprice??'0.0')
};
print("Invenroty UPLOAD DATA ++++++ $data");
final res = await API().postRequest(context, ApiUrl.inventoryInsert, data);
if(res.data['success'] == false){
  print('Error ${res.data}');
}else{
  print("Success ${res.data}");
}

   }catch(e){

   }
  }
  
}