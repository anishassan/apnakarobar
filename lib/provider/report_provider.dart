import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_management/db/database_helper.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/sales_model.dart';

class ReportProvider extends ChangeNotifier {
  //Sales Report
  String _fromDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String _toDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String get fromDate => _fromDate;
  String get toDate => _toDate;
  pickFromAndToDate({required String date, bool isFromDate = true}) {
    if (isFromDate) {
      _fromDate = date;
    } else {
      _toDate = date;
    }
    notifyListeners();
  }

  String _selectedFilter = 'All Time';
  String get selectedFilter => _selectedFilter;
  List<String> filterList = [
    'All Time',
    'This Week',
    'Last Week',
    'This Month',
    'Last Month',
    'This Quarter',
    'This Year',
    'Custom Date',
  ];
  String _totalPaidBalance = '0.0';
  String get totalPaidBalance => _totalPaidBalance;
  changeFilter(String f, List<SalesModel> salesData) {
    Map<String, dynamic> result = filterAndCalculate(salesData, f,
        customStartDate: _fromDate, customEndDate: _toDate);
    _totalSales = result['totalValue'];
    _totalPaidBalance = result['totalPaidBalance'];
    _selectedFilter = f;
    notifyListeners();
  }

  List<String> scndFilterList = ['Monthly', 'Weekly', 'Daily'];
  String _scndSelectedFilter = 'Monthly';
  String get scndSelectedFilter => _scndSelectedFilter;
  changeScndSelectedFilter(String val) {
    _scndSelectedFilter = val;
    notifyListeners();
  }

  String calculateTotalLastSale(List<Datum> data) {
    double totalLastSale = 0.0;

    for (var datum in data) {
      for (var product in datum.soldProducts!) {
        totalLastSale += int.parse(product.quantity) *
            double.parse(product.productprice ?? '0.0');
      }
    }

    return totalLastSale.toString();
  }
  String calculatesingleTotalLastSale(List<Datum> data,int id) {
    double totalLastSale = 0.0;

    for (var datum in data) {
      if(datum.customerId ==id){
      for (var product in datum.soldProducts!) {
        totalLastSale += int.parse(product.quantity) *
            double.parse(product.productprice ?? '0.0');
      }}
    }

    return totalLastSale.toString();
  }
  String customerSupplierTotalSales(List<SalesModel> data,int id) {
    double totalLastSale = 0.0;
for(var v in data){
    for (var datum in v.data) {
      if(datum.customerId ==id){
      for (var product in datum.soldProducts!) {
        totalLastSale += int.parse(product.quantity) *
            double.parse(product.productprice ?? '0.0');
      }}
    }
    }

    return totalLastSale.toString();
  }

  

  String calculateTotalPayment(List<Datum> data) {
    double totalpayment = 0.0;

    for (var datum in data) {
      print("Total Balance ${datum.paidBalance}");
      totalpayment = totalpayment + double.parse(datum.paidBalance ?? '0.0');
    }

    return totalpayment.toString();
  }
  String calculateSingleTotalPayment(List<Datum> data,int id) {
    double totalpayment = 0.0;

    for (var datum in data) {
      if(datum.customerId == id){
      print("Total Balance ${datum.paidBalance}");
      totalpayment = totalpayment + double.parse(datum.paidBalance ?? '0.0');
    }}

    return totalpayment.toString();
  }
  String customerSupplierTotalPayment(List<SalesModel> data,int id) {
    double totalpayment = 0.0;
for(var v in data){
    for (var datum in v.data) {
      if(datum.customerId == id){
      print("Total Balance ${datum.paidBalance}");
      totalpayment = totalpayment + double.parse(datum.paidBalance ?? '0.0');
    }}
}

    return totalpayment.toString();
  }

  String calculateSingleUserSalePurchase(Datum data) {
    double totalLastSale = 0.0;
    print("Quantities ${data.soldProducts!.length}");
    for (InventoryItem p in data.soldProducts ?? []) {
      totalLastSale +=
          double.parse(p.productprice ?? '0.0') * int.parse(p.quantity??'0');
    }
    return totalLastSale.toString();
  }

  String _totalSales = '0.0';
  String get totalSales => _totalSales;
  List<SalesModel> _filteredDataList = [];
  List<SalesModel> get filteredDataList => _filteredDataList;
  List<InventoryItem> _filteredProducts = [];
  List<InventoryItem> get filteredProducts => _filteredProducts;
  List<Datum> _filteredCustomers = [];
  List<Datum> get filteredCustomers => _filteredCustomers;
  Map<String, String> filterAndCalculate(
    List<SalesModel> data,
    String filterOption, {
    required String customStartDate,
    required String customEndDate,
  }) {
    List<SalesModel> filteredDataList = [];
    List<Datum> filteredCustomers = [];
    List<InventoryItem> filteredProducts = [];

    final now = DateTime.now();
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    late DateTime rangeStart;
    late DateTime rangeEnd;

    switch (filterOption) {
      case 'All Time':
        rangeStart = DateTime(1900);
        rangeEnd = DateTime(2100);
        break;
      case 'This Week':
        rangeStart = now.subtract(Duration(days: now.weekday - 1));
        rangeEnd = rangeStart.add(Duration(days: 6));
        break;
      case 'Last Week':
        rangeEnd = now.subtract(Duration(days: now.weekday));
        rangeStart = rangeEnd.subtract(Duration(days: 6));
        break;
      case 'This Month':
        rangeStart = DateTime(now.year, now.month, 1);
        rangeEnd =
            DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));
        break;
      case 'Last Month':
        rangeStart = DateTime(now.year, now.month - 1, 1);
        rangeEnd = DateTime(now.year, now.month, 1).subtract(Duration(days: 1));
        break;
      case 'This Quarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        rangeStart = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
        rangeEnd = DateTime(now.year, currentQuarter * 3 + 1, 1)
            .subtract(Duration(days: 1));
        break;
      case 'This Year':
        rangeStart = DateTime(now.year, 1, 1);
        rangeEnd = DateTime(now.year, 12, 31);
        break;
      case 'Custom Date':
        if (customStartDate.isEmpty || customEndDate.isEmpty) {
          throw ArgumentError(
              "Custom date range requires both start and end dates.");
        }
        rangeStart = dateFormat.parse(customStartDate);
        rangeEnd = dateFormat.parse(customEndDate);
        break;
      default:
        throw ArgumentError("Invalid filter option");
    }

    double totalValue = 0.0;
    double totalPaidBalance = 0.0;

    for (var record in data) {
      filteredCustomers.clear();

      for (var customer in record.data) {
        filteredProducts.clear();

        for (InventoryItem product in customer.soldProducts ?? []) {
          DateTime? productDate =
              product.date != null ? dateFormat.parse(product.date!) : null;

          if (productDate != null &&
              productDate.isAfter(rangeStart.subtract(Duration(days: 1))) &&
              productDate.isBefore(rangeEnd.add(Duration(days: 1)))) {
            filteredProducts.add(product);
            totalValue += double.parse(product.productprice ?? '0.0') *
                int.parse(product.quantity??'0');
            print('Total Value ${totalValue}');
          }
        }

        if (filteredProducts.isNotEmpty) {
          filteredCustomers.add(
              customer.copyWith(soldProducts: List.from(filteredProducts)));
        }

        totalPaidBalance +=
            double.tryParse(customer.paidBalance ?? '0.0') ?? 0.0;
      }

      if (filteredCustomers.isNotEmpty) {
        filteredDataList.add(
          record.copyWith(data: List.from(filteredCustomers)),
        );
      }
    }

    return {
      'totalPaidBalance': totalPaidBalance.toStringAsFixed(2),
      'totalValue': totalValue.toStringAsFixed(2),
    };
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //Customer Report
  TextEditingController search = TextEditingController();
  String getRemainingBalance(List<Datum> values) {
    double total = 0.0;

    for (var value in values) {
      // Parse each string to a double and add it to the total
      total += double.tryParse(value.remainigBalance ?? '0.0') ??
          0.0; // If parsing fails, add 0.0
    }

    return total.toString();
  }
  String getSingleRemainingBalance(List<Datum> values,int id) {
    double total = 0.0;

    for (var value in values) {
      if(value.customerId ==id){
      // Parse each string to a double and add it to the total
      total += double.tryParse(value.remainigBalance ?? '0.0') ??
          0.0; // If parsing fails, add 0.0
    }}

    return total.toString();
  }
String customerSupplierRemainingBalance(List<SalesModel> values,int id) {
    double total = 0.0;
for(var v in values){
    for (var value in v.data) {
      if(value.customerId ==id){
      // Parse each string to a double and add it to the total
      total += double.tryParse(value.remainigBalance ?? '0.0') ??
          0.0; // If parsing fails, add 0.0
    }}
}

    return total.toString();
  }
  clearData() {
    _filteredCustomers.clear();
    filteredCustomers.clear();
    filteredDataList.clear();
    filteredProducts.clear();
    _filteredDataList.clear();
    _filteredProducts.clear();
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
          }
        }
      }
    }

    notifyListeners();
  }

  List<Datum> _customerList = [];
  List<Datum> get customerList => _customerList;

  Future getSales() async {
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
      bool exists = _salesList.any((element) => element.soldDate == v.soldDate);
      if (!exists) {
        _salesList.add(v);
        for (var x in v.data) {
          bool isExist = _customerList.any((e) => e.name == x.name);
          if (!isExist) {
            _customerList.add(x);
          }
        }
      }
    }

    notifyListeners();
  }
}
