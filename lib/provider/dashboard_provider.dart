import 'package:flutter/material.dart';
import 'package:sales_management/gen/assets.gen.dart';
import 'package:sales_management/repositories/storage/storage_repo.dart';

class DashboardProvider extends ChangeNotifier{
List<String> navbarList = [
  Assets.svg.inventory,
  Assets.svg.sales,
  Assets.svg.purchase,
  Assets.svg.report,
  Assets.svg.profile,
];
List<String> navbarName =[
  


"Inventory",
"Sales",
"Purchase",
"Report",
"Profile",
];
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  changeIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }
  clearSession({required StorageRepo repo})async{
    await repo.clearSession();
  }
}
