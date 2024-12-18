import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sales_management/db/database_helper.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/sales_model.dart';

class SalesProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  void scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  String _selectedType = "Paid";
  String get selectedType => _selectedType;
  changeType(String val) {
    _selectedType = val;
    notifyListeners();
  }

  List<String> daysType = ['All days', 'Daily', 'Weekly', 'Monthly', 'Overall'];
  String _selectedDay = 'All days';
  String get selectedDay => _selectedDay;
  changeDay(String val) {
    _selectedDay = val;
    notifyListeners();
  }

  int _selectedYear = DateTime.now().year;

  int get selectedYear => _selectedYear;
  decrementYear() {
    if (_selectedYear <= 1998) {
    } else {
      _selectedYear--;
      notifyListeners();
    }
  }

  incrementYear() {
    if (_selectedYear == DateTime.now().year) {
    } else {
      _selectedYear++;
      notifyListeners();
    }
  }

  List<SalesModel> _salesList = [];
  List<SalesModel> get salesList => _salesList;
  List<Datum> _customerList = [];
  List<Datum> get customerList => _customerList;
  List<InventoryItem> _soldProducts = [];
  List<InventoryItem> get soldProducts => _soldProducts;
  getSales() async {
    _salesList.clear();
    _customerList.clear();
    _soldProducts.clear();
    final data = await DatabaseHelper.getAllSalesData();
    final List<InventoryItem> sold = data
        .expand((entry) => entry.data) // Expand all `data` arrays
        .expand((dataEntry) =>
            dataEntry.soldProducts ?? []) // Expand `soldProducts`
        .cast<InventoryItem>() // Ensure type safety
        .toList();
    print('Sold Length $sold');
    _soldProducts.addAll(sold);
    for (var v in data) {
      bool exists = _salesList.any((element) => element.soldDate == v.soldDate);
      if (!exists) {
        _salesList.add(v);
        for (var x in v.data) {
          bool isExist = _customerList.any((e) => e.name == x.name);
          if (!isExist) {
            _customerList.add(x);
            _customerList.sort();
          }
        }
      }
    }

    notifyListeners();
  }
}
