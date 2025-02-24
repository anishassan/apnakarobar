import 'package:flutter/material.dart';
import 'package:sales_management/gen/assets.gen.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/item_model.dart';
import 'package:sales_management/repositories/inventory/inventory_repo.dart';
import 'package:sales_management/repositories/storage/storage_repo.dart';

class DashboardProvider extends ChangeNotifier {
  List<String> navbarList = [
    Assets.svg.inventory,
    Assets.svg.purchase,
    Assets.svg.sales,
    Assets.svg.report,
    Assets.svg.profile,
  ];
  List<String> navbarName = [
    "Inventory",
    "Purchase",
    "Sales",
    "Report",
    "Profile",
  ];
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  changeIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  clearSession({required StorageRepo repo}) async {
    await repo.clearSession();
  }

  uploadInventory(InventoryItem inventory,BuildContext context, InventoryRepo repo,StorageRepo storage)async{
    String uid = await storage.getUid();
    await repo.uploadInventory(inventory: inventory, context: context,currentUserId:int.parse(uid));

  }
}
