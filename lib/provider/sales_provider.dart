import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sales_management/db/database_helper.dart';
import 'package:sales_management/main.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/repositories/customer/customer_repo.dart';
import 'package:sales_management/repositories/storage/storage_repo.dart';

class SalesProvider extends ChangeNotifier {
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
    getSales(context: context);
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
  Future getSales({required BuildContext context}) async {
    _salesList.clear();
    _customerList.clear();
    _soldProducts.clear();
    final data = await DatabaseHelper.getAllSalesData();
    final List<InventoryItem> sold = data
        .expand((entry) => entry.data)
        .expand((dataEntry) => dataEntry.soldProducts ?? [])
        .cast<InventoryItem>() // Ensure type safety
        .toList();

    print('Sold Length $sold');
    _soldProducts.addAll(sold);
    for (var v in data) {
      print("Sales List Data ${v.toJson()}");
      bool exists = _salesList.any((element) => element.soldDate == v.soldDate);
      if (!exists) {
        _salesList.add(v);
        uploadSales(context: context, customer: v.data, repo: getIt(), date: v.soldDate, saleId: v.id??0,storage:getIt());
        for (var x in v.data) {
          bool isExist = _customerList.any((e) => e.name == x.name);
          if (!isExist) {
            _customerList.add(x);
            checkInternetConnectivity().whenComplete((){
              if(isConnected){
uploadCustomer(context: context, customer: x, repo: getIt(),storage:getIt());

              }
            });
            // _customerList.sort();
          }
        }
      }
    }
    _salesList = filterSalesByDate(_salesList, _selectedDay);
  
    notifyListeners();
  }

  String calculateProductMetrics(List<InventoryItem> products, String metric) {
    if (metric == 'quantity') {
      double totalQuantity = products.fold(
          0, (sum, item) => sum + double.parse(item.quantity ?? '0.0'));
      return totalQuantity.toString();
    } else if (metric == 'totalprice') {
      double totalPrice = products.fold(
          0.0, (sum, item) => sum + double.parse(item.totalprice ?? '0.0'));
      return totalPrice.toString();
    }
    return 'Invalid metric';
  }

  List<Datum> filterCustomersByType(SalesModel salesData, String selectedType) {
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

  List<SalesModel> filterSalesByDate(
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

  List<SalesModel> filterSalesByCustomerName(
      List<SalesModel> sales, String customerName) {
    return sales
        .map((sale) {
          var filteredCustomers = sale.data
              .where((customer) =>
                  customer.name!.toLowerCase() == customerName.toLowerCase())
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
// String _searchText ='';
// String get searchText => _searchText;
// changeSearchText(String val){
//   _searchText =val;
//   notifyListeners();
// }
  searchByName(String val,BuildContext context) {
    if (val == '') {
      getSales(context: context);
    } else {
      _salesList = filterSalesByCustomerName(_salesList, val);
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
  uploadCustomer({required BuildContext context,required Datum customer,required CustomerRepo repo,required StorageRepo storage}) async{
    String uid = await storage.getUid();
    await repo.uploadCustomer(context: context, customer: customer,currentUserId: int.parse(uid));
  }
  uploadSales({required BuildContext context,required List<Datum> customer,required CustomerRepo repo,required String date,required int saleId,required StorageRepo storage}) async{
      String uid = await storage.getUid();
    await repo.uploadSales(context: context, date: date, saleId: saleId, customer: customer,currentUserId: int.parse(uid),salesData: salesList);
  }
}
