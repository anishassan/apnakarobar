import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/sales_model.dart';

class ReportProvider extends ChangeNotifier {
  List<String> reportType = [
    'Sale Report',
    'Purchase Report',
    'Customer Report',
    'Supplier Report',
    'Inventory Report',
  ];

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

  String calculateTotalPayment(List<Datum> data) {
    double totalpayment = 0.0;

    for (var datum in data) {
      totalpayment += double.parse(datum.paidBalance ?? '0.0');
    }

    return totalpayment.toString();
  }

  String calculateSingleUserSalePurchase(List<InventoryItem> data) {
    double totalLastSale = 0.0;

    for (var product in data) {
      totalLastSale += int.parse(product.quantity) *
          double.parse(product.productprice ?? '0.0');
    }

    return totalLastSale.toString();
  }

  String _totalSales = '0.0';
  String get totalSales => _totalSales;
  List<SalesModel> _filteredDataList = [];
  List<SalesModel> get filteredDataList => _filteredDataList;
  List<InventoryItem> filteredProducts = [];
  List<Datum> filteredCustomers = [];
  Map<String, String> filterAndCalculate(
    List<SalesModel> data,
    String filterOption, {
    required String customStartDate,
    required String customEndDate,
  }) {
    _filteredDataList.clear();
    filteredCustomers.clear();
    filteredProducts.clear();

    final now = DateTime.now();
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    late DateTime rangeStart;
    late DateTime rangeEnd;

    // Determine the date range based on the filter option
    switch (filterOption) {
      case 'All Time':
        rangeStart = DateTime(1900); // Arbitrary early date
        rangeEnd = DateTime(2100); // Arbitrary future date
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
        rangeStart = DateFormat('dd-MM-yyyy').parse(customStartDate);
        rangeEnd = DateFormat('dd-MM-yyyy').parse(customEndDate);
        break;
      default:
        throw ArgumentError("Invalid filter option");
    }

    // Calculate the total value and filter data
    double totalValue = 0.0;
    double totalPaidBalance = 0.0; // To track total paid balance

    for (var record in data) {
      for (var customer in record.data) {
        for (InventoryItem product in customer.soldProducts ?? []) {
          DateTime productDate = dateFormat.parse(product.date ?? '');

          if (productDate.isAfter(rangeStart.subtract(Duration(days: 1))) &&
              productDate.isBefore(rangeEnd.add(Duration(days: 1)))) {
            print("PRODUCT ${product.toJson()}");
            filteredProducts.add(product);

            totalValue += double.parse(product.productprice ?? '0.0') *
                int.parse(product.quantity);
          }
        }

        if (filteredProducts.isNotEmpty) {
          // Add the customer with filtered products
          filteredCustomers
              .add(customer.copyWith(soldProducts: filteredProducts));
        }

        // Add paid balance to total
        totalPaidBalance += double.parse(customer.paidBalance ?? '0.0');
      }

      if (filteredCustomers.isNotEmpty) {
        _filteredDataList.add(
          SalesModel(soldDate: record.soldDate, data: filteredCustomers),
        );
      }
    }

    // Return both total paid balance and total value (product prices)
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
    total += double.tryParse(value.remainigBalance??'0.0') ?? 0.0;  // If parsing fails, add 0.0
  }

  return total.toString();
}
}
