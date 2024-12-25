import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sales_management/db/database_helper.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/sales_model.dart';

class PurchaseProvider extends ChangeNotifier {
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
  List<Datum> _supplierList = [];
  List<Datum> get supplierList => _supplierList;
  List<InventoryItem> _soldProducts = [];
  List<InventoryItem> get soldProducts => _soldProducts;
  Future getPurchase() async {
    _salesList.clear();
    _supplierList.clear();
    _soldProducts.clear();
    final data = await DatabaseHelper.getAllPurchaseData();
    final List<InventoryItem> sold = data
        .expand((entry) => entry.data)
        .expand((dataEntry) => dataEntry.soldProducts ?? [])
        .cast<InventoryItem>() // Ensure type safety
        .toList();

    _soldProducts.addAll(sold);
    for (var v in data) {
      bool exists = _salesList.any((element) => element.soldDate == v.soldDate);
      if (!exists) {
        _salesList.add(v);
        for (var x in v.data) {
          bool isExist = _supplierList.any((e) => e.name == x.name);
          if (!isExist) {
            _supplierList.add(x);
            // _supplierList.sort();
          }
        }
      }
    }

    notifyListeners();
  }


  List<Datum> mergeSupplier(List<SalesModel> rawData) {
  Map<String, Datum> merged = {};

  for (var item in rawData) {
    for (var customer in item.data) {
    
      String key = "${customer.name}_${customer.contact}_${item.soldDate}";

      if (merged.containsKey(key)) {
        merged[key]?.soldProducts!.addAll(customer.soldProducts!);
      } else {
        merged[key] = customer;
      }
    }
  }

  return merged.values.toList();
}

String calculateProductMetrics(List<InventoryItem> products, String metric) {
  if (metric == 'quantity') {
    int totalQuantity = products.fold(0, (sum, item) => sum + int.parse(item.quantity??'0'));
    return totalQuantity.toString();
  } else if (metric == 'totalprice') {
    double totalPrice = products.fold(0.0, (sum, item) => sum + double.parse(item.totalprice??'0.0'));
    return totalPrice.toString();
  }
  return 'Invalid metric';
}
}
