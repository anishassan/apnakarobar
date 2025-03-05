import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sales_management/db/database_helper.dart';
import 'package:sales_management/main.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/repositories/storage/storage_repo.dart';
import 'package:sales_management/repositories/supplier/supplier_repo.dart';

class PurchaseProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  void scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  String _selectedType = "All";
  String get selectedType => _selectedType;
  changeType(String val) {
    _selectedType = val;
    notifyListeners();
  }

  List<String> daysType = ['Daily', 'Weekly', 'Monthly', 'Overall'];
  String _selectedDay = 'Overall';
  String get selectedDay => _selectedDay;
  changeDay(String val,BuildContext context) {
    _selectedDay = val;
    getPurchase(context: context);
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
  Future getPurchase({required BuildContext context}) async {
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
uploadPurchase(context: context, supplier: v.data, repo: getIt(), date: v.soldDate, saleId: v.id??0, storage: getIt());
        for (var x in v.data) {
          bool isExist = _supplierList.any((e) => e.name == x.name);
          if (!isExist) {
            _supplierList.add(x);
            checkInternetConnectivity().whenComplete((){
              if(isConnected){
uploadSupplier(context: context, supplier: x, repo: getIt(),storage: getIt());

              }
            });
            // _supplierList.sort();
          }
        }
      }
    }
    _salesList = filterPurchaseByDate(_salesList, _selectedDay);
    
    notifyListeners();
  }

  String calculateProductMetrics(List<InventoryItem> products, String metric) {
    if (metric == 'quantity') {
      double totalQuantity = products.fold(
          0, (sum, item) => sum + double.parse(item.quantity ?? '0'));
      return totalQuantity.toString();
    } else if (metric == 'totalprice') {
      double totalPrice = products.fold(
          0.0, (sum, item) => sum + double.parse(item.totalprice ?? '0.0'));
      return totalPrice.toString();
    }
    return 'Invalid metric';
  }

  List<Datum> filterSupplierByType(SalesModel salesData, String selectedType) {
    return salesData.data.where((customer) {
      if (selectedType == 'Paid') {
        return double.parse(customer.remainigBalance ?? '0.0') == 0.0;
      } else if (selectedType == 'Unpaid') {
        return double.parse(customer.remainigBalance ?? '0.0') != 0.0;
      } else if (selectedType == 'All') {
        return true;
      }
      return false;
    }).toList();
  }

  List<SalesModel> filterPurchaseByDate(
      List<SalesModel> sales, String filterType) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    return sales.where((sale) {
      DateTime saleDate = DateTime(
          int.parse(sale.soldDate.split('-')[0]),
          int.parse(sale.soldDate.split('-')[1]),
          int.parse(sale.soldDate.split('-')[2]));

      if (filterType == 'Daily') {
        return isSameDay(saleDate, now);
      } else if (filterType == 'Weekly') {
        return saleDate.isAfter(startOfWeek);
      } else if (filterType == 'Monthly') {
        return saleDate.isAfter(startOfMonth);
      } else if (filterType == 'Overall') {
        return true; // Return all sales
      }
      return false;
    }).toList();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<SalesModel> filterPurchaseByCustomerName(
      List<SalesModel> sales, String customerName) {
    return sales
        .map((sale) {
          var filteredCustomers = sale.data
              .where((customer) =>
                  customer.name?.toLowerCase() == customerName.toLowerCase())
              .toList();
          if (filteredCustomers.isNotEmpty) {
            return SalesModel(
              id: sale.id,
              soldDate: sale.soldDate,
              data: filteredCustomers,
            );
          }
          return null;
        })
        .where((sale) => sale != null)
        .cast<SalesModel>()
        .toList();
  }

  TextEditingController search = TextEditingController();
  searchByName(String val,BuildContext context) {
    if (val == '') {
      getPurchase(context: context);
    } else {
      _salesList = filterPurchaseByCustomerName(_salesList, val);
    }
    notifyListeners();
  }

   bool isConnected = true;

  Future<void> checkInternetConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      print("Moble");
   
        isConnected = true;
   
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      print('Wifi');
     
        isConnected = true;
     
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
   
        isConnected = true;

    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      print('VPN');
       isConnected=true;
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      print('Bluetooth');
     isConnected=true;
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      print('other');
       isConnected=true;
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
       isConnected=true;
    }
    notifyListeners();
  }

  Future uploadSupplier({required BuildContext context, required Datum supplier, required SupplierRepo repo,required StorageRepo storage})async{
    String uid = await storage.getUid();
    await repo.insertSupplierData(context: context, supplier: supplier,currentUserId: int.parse(uid));
  }
  uploadPurchase({required BuildContext context,required List<Datum> supplier,required SupplierRepo repo,required String date,required int saleId,required StorageRepo storage}) async{
      String uid = await storage.getUid();
    await repo.uploadPurchase(context: context, date: date, saleId: saleId, supplier: supplier,currentUserId: int.parse(uid),purchaseData: salesList);
  }
}
