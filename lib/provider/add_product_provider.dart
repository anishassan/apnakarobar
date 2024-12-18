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
//Sales and purchase
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController dicount = TextEditingController();
  TextEditingController payment = TextEditingController();
  double _remainingBalance = 0.0;
  double get remainingBalance => _remainingBalance;
  getRemainingBalance() {
    _remainingBalance = _completePrice - double.parse(payment.text);
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
    "Bottle"
  ];
  // pickedDate({required BuildContext context}) async {
  //   DateTime? picked = await showDatePicker(
  //       context: context,
  //       firstDate: DateTime.now(),
  //       lastDate: DateTime.now().add(Duration(days: 360 * 10)));
  //   if (picked != null) {
  //     date.text = DateFormat('dd-MM-yyyy').format(picked);
  //   }
  //   notifyListeners();
  // }

  List<ItemModel> _productItems = <ItemModel>[];
  List<ItemModel> get productItems => _productItems;
  List<InventoryItem> _salesItems = <InventoryItem>[];
  List<InventoryItem> get salesItems => _salesItems;
  List<InventoryItem> _purchaseItems = <InventoryItem>[];
  List<InventoryItem> get purchaseItems => _purchaseItems;
  bool _isInsert = false;
  bool get isInsert => _isInsert;
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
              lastPurchase: lastPurchase.text,
              lastSale: lastSale.text,
              desc: description.text,
              title: title.text,
              productprice: productprice.text,
              quantity: quantity.text,
              totalprice: totalprice.text,
              stock: unitVal.text + ' ' + _selectedUnit,
              date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
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
            lastSale: item.lastSale,
            lastPurchase: item.lastPurchase,
            buySaleQuantity: quantity.text,
            quantity: quantity.text,
            productprice: productprice.text,
            totalprice: totalprice.text);
        _salesItems.insert(0, d);
        toggleInsert(true);
        _remainingBalance += double.parse(totalprice.text);
        if (dicount.text.isEmpty) {
          _completePrice += double.parse(d.totalprice ?? '0.0');
        } else {
          _completePrice +=
              double.parse(d.totalprice ?? '0.0') - double.parse(dicount.text);
        }
      }
    } else if (type == 2) {
      if (_selectedInventoryItem == 'Product/Services') {
        toast(msg: 'Please select product first.', context: context);
      } else {
        final d = item.copyWith(
            lastSale:
                (int.parse(quantity.text) * double.parse(productprice.text))
                    .toString(),
            buySaleQuantity: quantity.text,
            lastPurchase: lastPurchase.text,
            quantity: item.quantity == null || item.quantity == ""
                ? quantity.text
                : (int.parse(item.quantity ?? '0') + int.parse(quantity.text))
                    .toString(),
            productprice: productprice.text,
            totalprice: totalprice.text);
        _purchaseItems.insert(0, d);
        toggleInsert(true);
        _remainingBalance += double.parse(totalprice.text);
        if (dicount.text.isEmpty) {
          _completePrice += double.parse(d.totalprice ?? '0.0');
        } else {
          _completePrice +=
              double.parse(d.totalprice ?? '0.0') - double.parse(dicount.text);
        }
      }
    }
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
    dicount.clear();
    productprice.clear();
  }

  clearAllData() {
    _productItems.clear();
    _inventoryList.clear();
    _salesItems.clear();
    _purchaseItems.clear();
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

  addSalesData(
    List<InventoryItem> data,
    BuildContext context,
    int type,
  ) async {
    if (data == []) {
      toast(msg: 'Please select any item first to sold', context: context);
    } else {
      bool isSuccess = await DatabaseHelper().addSalesData(SalesModel(
        soldDate: DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(Duration(days: 2))),
        data: [
          Datum(
            contact: phone.text,
            customerId: selectedId.text.isEmpty
                ? DateTime.now().millisecondsSinceEpoch
                : int.parse(selectedId.text),
            name: name.text,
            remainigBalance: remainingBalance.toString(),
            paidBalance: payment.text,
            soldProducts: data.toList(),
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

  addPurchaseData(
      List<InventoryItem> data, BuildContext context, int type) async {
    if (data == []) {
      toast(msg: 'Please select any item first to sold', context: context);
    } else {
      bool isSuccess = await DatabaseHelper().addPurchaseData(SalesModel(
        soldDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        data: [
          Datum(
            name: name.text,
            contact: phone.text,
            customerId: selectedId.text.isEmpty
                ? DateTime.now().millisecondsSinceEpoch
                : int.parse(selectedId.text),
            remainigBalance: _remainingBalance.toString(),
            paidBalance: payment.text,
            soldProducts: data,
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
}
