import 'package:flutter/material.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/item_model.dart';

abstract class InventoryRepo {
  Future uploadInventory({required InventoryItem inventory,required int currentUserId,required BuildContext context});
}