import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/db/database_helper.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/item_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/provider/dashboard_provider.dart';
import 'package:sales_management/utils/toast.dart';

class AddProductProvider extends ChangeNotifier {
  //inventory
  TextEditingController title = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController search = TextEditingController();
  TextEditingController totalprice = TextEditingController();
  TextEditingController productprice = TextEditingController();
  TextEditingController selectedId = TextEditingController();
  TextEditingController unitVal = TextEditingController();
  TextEditingController lastSale = TextEditingController();
  TextEditingController lastPurchase = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController searchProduct = TextEditingController();
//Sales and purchase
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController dicount = TextEditingController();
  TextEditingController payment = TextEditingController();
  double _remainingBalance = 0.0;
  double get remainingBalance => _remainingBalance;
  getRemainingBalanc() {
    if (dicount.text.isEmpty || dicount.text == '') {
      _remainingBalance = _completePrice - double.parse(payment.text);
    } else {
      _remainingBalance = _completePrice -
          double.parse(payment.text) -
          double.parse(dicount.text);
    }

    notifyListeners();
  }

  String _selectedUnit = 'Kg';
  String get selectedUnit => _selectedUnit;
  selectNewUnit(String val) {
    _selectedUnit = val;
    notifyListeners();
  }

  List<String> unitsList = [
    "Bags",
    "Kg",
    "Gram",
    "Bundle",
    "Pcs",
    "Ltr",
    "Meter",
    "Carton",
    "Box",
    "Pkt",
    "Dozen",
    "Bottle",
    "ml",
    'Tin',
    'Jar',
    "Other"
  ];
  bool _showUnits = false;
  bool get showUnits => _showUnits;
  toggleShowUnit() {
    _showUnits = !_showUnits;
    notifyListeners();
  }

  List<ItemModel> _productItems = <ItemModel>[];
  List<ItemModel> get productItems => _productItems;
  List<InventoryItem> _salesItems = <InventoryItem>[];
  List<InventoryItem> get salesItems => _salesItems;
  List<InventoryItem> _purchaseItems = <InventoryItem>[];
  List<InventoryItem> get purchaseItems => _purchaseItems;
  bool _isInsert = false;
  bool get isInsert => _isInsert;
  removeItem(int index, int type) {
    if (type == 1) {
      _completePrice =
          _completePrice - double.parse(_salesItems[index].totalprice ?? "0.0");
      _remainingBalance = _remainingBalance -
          double.parse(_salesItems[index].totalprice ?? "0.0");
      _salesItems.removeAt(index);
    } else {
      _completePrice = _completePrice -
          double.parse(_purchaseItems[index].totalprice ?? "0.0");
      _remainingBalance = _remainingBalance -
          double.parse(_purchaseItems[index].totalprice ?? "0.0");
      _purchaseItems.removeAt(index);
    }
    notifyListeners();
  }

  toggleInsert(bool val) {
    _isInsert = val;
    notifyListeners();
  }

  Future addItem(
      {required BuildContext context,
      required int type,
      required InventoryItem item}) async {
    toggleInsert(false);
    if (type == 0) {
      if (title.text.isEmpty) {
        toast(msg: 'Please enter title', context: context);
      } else {
        _productItems.insert(
            0,
            ItemModel(
              id: DateTime.now().millisecondsSinceEpoch,
              lastPurchase: lastPurchase.text.isEmpty || lastPurchase.text == ''
                  ? '0.00'
                  : lastPurchase.text,
              lastSale: lastSale.text.isEmpty || lastSale.text == ""
                  ? '0.00'
                  : lastSale.text,
              desc: description.text,
              title: title.text,
              productprice: productprice.text.isEmpty || productprice.text == ""
                  ? '0.00'
                  : productprice.text,
              quantity: quantity.text.isEmpty || quantity.text == ""
                  ? "0"
                  : quantity.text,
              totalprice: totalprice.text.isEmpty || totalprice.text == ""
                  ? '0.00'
                  : totalprice.text,
              stock: unitVal.text + ' ' + _selectedUnit,
              date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            ));

        toggleInsert(true);
      }
    } else if (type == 1) {
      if (_selectedInventoryItem == 'Product/Services') {
        toast(msg: 'Please select product first.', context: context);
      } else if (item.quantity == null ||
          item.quantity == '0' ||
          int.parse(item.quantity ?? '0') < int.parse(quantity.text)) {
        toast(msg: 'Do not have enough quantity', context: context);
      } else {
        final d = item.copyWith(
          lastSale: item.lastSale == "" ? '0.00' : item.lastSale,
          lastPurchase: item.lastPurchase == "" ? '0.00' : item.lastPurchase,
          buySaleQuantity: quantity.text.isEmpty || quantity.text == ""
              ? "0"
              : quantity.text,
          quantity: quantity.text.isEmpty || quantity.text == ""
              ? "0"
              : quantity.text,
          productprice: productprice.text.isEmpty || productprice.text == ""
              ? '0.00'
              : productprice.text,
          totalprice: totalprice.text.isEmpty || totalprice.text == ""
              ? '0.00'
              : totalprice.text,
        );
        _salesItems.insert(0, d);
        toggleInsert(true);
        _remainingBalance += double.parse(totalprice.text);
        // if (dicount.text.isEmpty) {
        _completePrice += double.parse(d.totalprice ?? '0.0');
        // }
        // else {
        //   _completePrice +=
        //       double.parse(d.totalprice ?? '0.0') - double.parse(dicount.text);
        // }
      }
    } else if (type == 2) {
      if (_selectedInventoryItem == 'Product/Services') {
        toast(msg: 'Please select product first.', context: context);
      } else {
        final d = item.copyWith(
          lastSale: (int.parse(quantity.text) * double.parse(productprice.text))
              .toString(),
          buySaleQuantity: quantity.text.isEmpty || quantity.text == ""
              ? '0'
              : quantity.text,
          lastPurchase: lastPurchase.text.isEmpty || lastPurchase.text == ""
              ? '0.00'
              : lastPurchase.text,
          quantity: item.quantity.isEmpty || item.quantity == ""
              ? quantity.text
              : (int.parse(item.quantity ?? '0') + int.parse(quantity.text))
                  .toString(),
          productprice: productprice.text.isEmpty || productprice.text == ""
              ? '0.00'
              : productprice.text,
          totalprice: totalprice.text.isEmpty || totalprice.text == ""
              ? '0.00'
              : totalprice.text,
        );
        _purchaseItems.insert(0, d);
        toggleInsert(true);
        _remainingBalance += double.parse(totalprice.text);
        // if (dicount.text.isEmpty) {
        _completePrice += double.parse(d.totalprice ?? '0.0');
        // } else {
        //   _completePrice +=
        //       double.parse(d.totalprice ?? '0.0') - double.parse(dicount.text);
        // }
      }
    }
    notifyListeners();
  }

  bool _isDiscountAdded = false;
  bool get isDiscountAdded => _isDiscountAdded;
  addDiscount() {
    // _completePrice = _completePrice - double.parse(dicount.text);
    final dic = _remainingBalance - double.parse(dicount.text);

    _remainingBalance = dic;
    changeDiscountAdded(true);
    notifyListeners();
  }

  changeDiscountAdded(bool val) {
    _isDiscountAdded = val;
    print('Is Discount $_isDiscountAdded');
    notifyListeners();
  }

  clearField() {
    quantity.clear();
    selectedId.clear();
    lastPurchase.clear();
    lastSale.clear();
    description.clear();
    title.clear();
    totalprice.clear();
    unitVal.clear();
    phone.clear();
    name.clear();
    payment.clear();
    _completePrice = 0.0;
    _remainingBalance = 0.0;
    _showAddItem = false;
    _expandedName = false;
    _selectedItem = InventoryItem.fromJson({});
    _selectedInventoryItem = 'Product/Services';
    productprice.clear();
    // notifyListeners();
  }

  clearSalesAndPurchaseField() {
    quantity.clear();
    title.clear();
    totalprice.clear();
    unitVal.clear();
    lastPurchase.clear();

    payment.clear();

    productprice.clear();
  }

  clearAllData() {
    _productItems.clear();
    _inventoryList.clear();
    _salesItems.clear();
    _purchaseItems.clear();
    dicount.clear();
    changeDiscountAdded(false);
    changePickedDate(DateTime.now());
  }

  Future addInventoryProduct(
      {required List<ItemModel> d, required BuildContext context}) async {
    bool isSuccess = await DatabaseHelper.addInventory(d);
    if (isSuccess) {
      toast(msg: 'New Product Add Successfully.', context: context);
      _productItems.clear();
      notifyListeners();
    }
  }

  List<int> _selectedItemIndexList = [];
  List<int> get selecteditemIndexList => _selectedItemIndexList;
  addSelectedItemIndex(int index) {
    if (_selectedItemIndexList.contains(index)) {
      _selectedItemIndexList.removeWhere((e) => e == index);
    } else {
      _selectedItemIndexList.add(index);
    }
    notifyListeners();
  }

  replaceModel(
      {required ItemModel model, required int index, required int type}) {
    if (type == 0) {
      _productItems[index] = model;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _productItems.clear();
    _salesItems.clear();
    _purchaseItems.clear();

    _selectedItemIndexList.clear();
    _productItems.clear();
    productItems.clear();
    clearField();
    // TODO: implement dispose
    super.dispose();
  }

  bool _expandedName = false;
  bool get expandedName => _expandedName;
  toggleExpandedName() {
    _expandedName = !_expandedName;
    notifyListeners();
  }

  bool _showAddItem = false;
  bool get showAddItem => _showAddItem;
  toggleAddItem() {
    _showAddItem = !_showAddItem;
    notifyListeners();
  }

  List<InventoryItem> _inventoryList = [];
  List<InventoryItem> get inventoryList => _inventoryList;
  List<InventoryItem> _filterinventoryList = [];
  List<InventoryItem> get filterinventoryList => _filterinventoryList;

  double _completePrice = 0.0;
  double get completetPrice => _completePrice;
  getInventoryData() async {
    _inventoryList.clear();
    List<Map<String, dynamic>> data = await DatabaseHelper.getInventory();
    List<InventoryModel> modelList =
        data.map((e) => InventoryModel.fromJson(e)).toList();
    for (var item in modelList) {
      _inventoryList.addAll(item.data);

      notifyListeners();
    }
  }

  String _selectedInventoryItem = 'Product/Services';
  String get selectedInventoryItem => _selectedInventoryItem;
  InventoryItem _selectedItem = InventoryItem.fromJson({});
  InventoryItem get selectedItem => _selectedItem;
  onSelectInventoryItem(InventoryItem val) {
    // quantity.text = val.quantity ?? '';
    // productprice.text = val.productprice ?? "";
    print(val.lastPurchase);
    unitVal.text = val.stock ?? "";
    _selectedInventoryItem = val.title ?? '';

    _selectedItem = val;
    notifyListeners();
  }

  filterInventory(String val) {
    _filterinventoryList = inventoryList
        .where((item) => item.title!.toLowerCase().contains(val.toLowerCase()))
        .toList();
    notifyListeners();
  }

  clearInventorySearch() {
    searchProduct.clear();
    _filterinventoryList.clear();
  }
 Random num1 = Random(1000);
    Random num2 = Random(1000);
  addSalesData(
    List<InventoryItem> data,
    BuildContext context,
    int type,
  ) async {
   
    
    if (data == []) {
      toast(msg: 'Please select any item first to sold', context: context);
    } else {
      DatabaseHelper().insertOrUpdateData(
          soldDate: DateFormat('yyyy-MM-dd').format(_pickedDate),
          Datum(
            discount: dicount.text.isEmpty || dicount.text == ''
                ? '0.0'
                : dicount.text,
            contact: phone.text.isEmpty ? '0300 00000 ${num1.nextInt(999)+num2.nextInt(999)}' : phone.text,
            customerId: selectedId.text.isEmpty &&
                    phone.text.isEmpty &&
                    name.text.isEmpty
                ? 30000000001+num1.nextInt(999)+num2.nextInt(999)
                : selectedId.text.isEmpty
                    ? DateTime(
                            _pickedDate.year,
                            _pickedDate.month,
                            _pickedDate.day,
                            now.hour,
                            now.minute,
                            now.second,
                            now.millisecond)
                        .millisecondsSinceEpoch + num1.nextInt(999) + num2.nextInt(999)
                    : int.parse(selectedId.text),
            name: name.text.isEmpty ? 'Walking' : name.text,
            remainigBalance: _remainingBalance.toString(),
            paidBalance: payment.text.isEmpty || payment.text == ""
                ? '0.0'
                : payment.text,
            soldProducts: data
                .map((e) => e.copyWith(
                    date: DateFormat('yyyy-MM-dd').format(_pickedDate)))
                .toList(),
          ),
          true,
          _pickedDate.toString());
      bool isSuccess = await DatabaseHelper().addSalesData(SalesModel(
        soldDate: DateFormat('yyyy-MM-dd').format(_pickedDate),
        data: [
          Datum(
            discount: dicount.text.isEmpty || dicount.text == ''
                ? '0.0'
                : dicount.text,
            contact: phone.text.isEmpty ? '0300 00000${num1.nextInt(999) + num2.nextInt(999)}' : phone.text,
            customerId: selectedId.text.isEmpty &&
                    phone.text.isEmpty &&
                    name.text.isEmpty
                ? 30000000001+ num1.nextInt(999) + num2.nextInt(999)
                : selectedId.text.isEmpty
                    ? DateTime(
                            _pickedDate.year,
                            _pickedDate.month,
                            _pickedDate.day,
                            now.hour,
                            now.minute,
                            now.second,
                            now.millisecond)
                        .millisecondsSinceEpoch+ num1.nextInt(999) + num2.nextInt(999)
                    : int.parse(selectedId.text),
            name: name.text.isEmpty ? 'Walking' : name.text,
            remainigBalance: _remainingBalance.toString(),
            paidBalance: payment.text.isEmpty || payment.text == ""
                ? '0.0'
                : payment.text,
            soldProducts: data
                .map((e) => e.copyWith(
                    date: DateFormat('yyyy-MM-dd').format(_pickedDate)))
                .toList(),
          )
        ].toList(),
      ));

      if (isSuccess) {
        clearAllData();
        clearField();
        Navigator.of(context).pushReplacementNamed(Routes.dashboard).then((e) {
          Provider.of<DashboardProvider>(context, listen: false).changeIndex(
            type,
          );
        });
      }
    }
  }

  DateTime now = DateTime.now();
  addPurchaseData(
      List<InventoryItem> data, BuildContext context, int type) async {
    if (data == []) {
      toast(msg: 'Please select any item first to sold', context: context);
    } else {
      print(name.text);
      print(phone.text);
      DatabaseHelper().insertOrUpdateData(
          soldDate: DateFormat('yyyy-MM-dd').format(_pickedDate),
          Datum(
            discount: dicount.text.isEmpty || dicount.text == ''
                ? '0.0'
                : dicount.text,
            name: name.text.isEmpty ? 'Walking' : name.text,
            contact: phone.text.isEmpty ? '0300 00000${ num1.nextInt(999) + num2.nextInt(999)}' : phone.text,
            customerId: selectedId.text.isEmpty &&
                    phone.text.isEmpty &&
                    name.text.isEmpty
                ? 30000000001+ num1.nextInt(999) + num2.nextInt(999)
                : selectedId.text.isEmpty
                    ? DateTime(
                            _pickedDate.year,
                            _pickedDate.month,
                            _pickedDate.day,
                            now.hour,
                            now.minute,
                            now.second,
                            now.millisecond)
                        .millisecondsSinceEpoch+ num1.nextInt(999) + num2.nextInt(999)
                    : int.parse(selectedId.text),
            remainigBalance: _remainingBalance.toString(),
            paidBalance: payment.text.isEmpty || payment.text == ""
                ? '0.0'
                : payment.text,
            soldProducts: data
                .map((e) => e.copyWith(
                    date: DateFormat('yyyy-MM-dd').format(_pickedDate)))
                .toList(),
          ),
          false,
          _pickedDate.toString());
      bool isSuccess = await DatabaseHelper().addPurchaseData(SalesModel(
        soldDate: DateFormat('yyyy-MM-dd').format(_pickedDate),
        data: [
          Datum(
            discount: dicount.text.isEmpty || dicount.text == ''
                ? '0.0'
                : dicount.text,
            name: name.text.isEmpty ? 'Walking' : name.text,
            contact: phone.text.isEmpty ? '0300 00000${ num1.nextInt(999) + num2.nextInt(999)}' : phone.text,
            customerId: selectedId.text.isEmpty &&
                    phone.text.isEmpty &&
                    name.text.isEmpty
                ? 30000000001+ num1.nextInt(999) + num2.nextInt(999)
                : selectedId.text.isEmpty
                    ? DateTime(
                            _pickedDate.year,
                            _pickedDate.month,
                            _pickedDate.day,
                            now.hour,
                            now.minute,
                            now.second,
                            now.millisecond)
                        .millisecondsSinceEpoch+ num1.nextInt(999) + num2.nextInt(999)
                    : int.parse(selectedId.text),
            remainigBalance: _remainingBalance.toString(),
            paidBalance: payment.text.isEmpty || payment.text == ""
                ? '0.0'
                : payment.text,
            soldProducts: data
                .map((e) => e.copyWith(
                    date: DateFormat('yyyy-MM-dd').format(_pickedDate)))
                .toList(),
          ),
        ],
      ));

      if (isSuccess) {
        clearAllData();
        clearField();
        Navigator.of(context).pushReplacementNamed(Routes.dashboard).then((e) {
          Provider.of<DashboardProvider>(context, listen: false)
              .changeIndex(type);
        });
      }
    }
  }

  List<SalesModel> _salesList = [];
  List<SalesModel> get salesList => _salesList;
  List<Datum> _customerList = [];
  List<Datum> get customerList => _customerList;
  getSales() async {
    _salesList.clear();
    _customerList.clear();
    final data = await DatabaseHelper.getAllSalesData();
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

  List<SalesModel> _puschaseList = [];
  List<SalesModel> get puschaseList => _puschaseList;
  List<Datum> _supplierList = [];
  List<Datum> get supplierList => _supplierList;
  getPurchase() async {
    _puschaseList.clear();
    puschaseList.clear();
    _supplierList.clear();
    supplierList.clear();
    final data = await DatabaseHelper.getAllPurchaseData();
    for (var v in data) {
      bool exists =
          _puschaseList.any((element) => element.soldDate == v.soldDate);
      if (!exists) {
        _puschaseList.add(v);
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

  DateTime _pickedDate = DateTime.now();
  DateTime get pickedDate => _pickedDate;
  changePickedDate(DateTime date) {
    _pickedDate = date;
    notifyListeners();
  }

  removeInventoryItem(index) {
    _productItems.removeAt(index);
    notifyListeners();
  }
}
