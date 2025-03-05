import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/db/database_helper.dart';
import 'package:sales_management/extensions/validation_extension.dart';
import 'package:sales_management/models/all_data_model.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/item_model.dart';
import 'package:sales_management/models/register_res_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/repositories/register/register_repo.dart';
import 'package:sales_management/repositories/storage/storage_repo.dart';
import 'package:sales_management/utils/toast.dart';

class RegisterProvider extends ChangeNotifier {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController category = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;
  changeLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  bool _isCatAdded = true;
  bool get isCatAdded => _isCatAdded;
  changeCatAdded(bool val) {
    _isCatAdded = val;
    notifyListeners();
  }

  Future register(
      {required BuildContext context,
      required RegisterRepo repo,
      required StorageRepo storage}) async {
    if (name.text.isEmpty) {
      toast(msg: 'Enter your name please', context: context);
    } else if (email.text.isEmpty) {
      toast(msg: 'Enter your email please', context: context);
    } else if (!email.text.emailValidator()) {
      toast(msg: 'Enter valid email please', context: context);
    } else if (contact.text.isEmpty) {
      toast(msg: 'Enter your phone number please', context: context);
    } else if (category.text.isEmpty) {
      changeCatAdded(false);
      toast(msg: 'Please enter business category', context: context);
    } else {
      changeLoading(true);
      final data = await repo.register(
          category: category.text,
          context: context,
          name: name.text,
          email: email.text,
          address: address.text,
          contact: contact.text);
      if (data.success != null) {
        if (data.success == false) {
          await DatabaseHelper().deleteDatabaseFile().then((val) async {
            await DatabaseHelper.initDb().then((val) async {
              final d =
                  await repo.getAllData(context: context, email: email.text);
              List<ItemModel> m = d.inventory
                      ?.map((inv) => ItemModel(
                            id: inv.id,
                            title: inv.title,
                            totalprice: ((inv.currentStock ?? 0) *
                                    (inv.currentValue ?? 0))
                                .toString(),
                            productprice: inv.currentValue.toString(),
                            lastSale: inv.salePrice.toString(),
                            lastPurchase: inv.purchasePrice.toString(),
                            desc:
                                inv.description == null ? '' : inv.description,
                            quantity: inv.currentStock.toString(),
                            stock: inv.measurement,
                            date:
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          ))
                      .toList() ??
                  [];

              bool ok = await DatabaseHelper.addInventory(m);
              if (ok == true) {
                print('Geeting Data +++++++++++++ insert');
              }

              for (Purchase s in d.sales ?? []) {
                DatabaseHelper().addSalesData((SalesModel(
                  soldDate: s.soldDate ?? '',
                  id: s.id,
                  data: s.data
                          ?.map((e) => Datum(
                                customerId: e.id,
                                name: e.name,
                                soldProducts: e.soldProducts
                                        ?.map((prod) => InventoryItem(
                                          type: '',
                                            id: prod.id,
                                            title: prod.title,
                                            date: prod.date,
                                            totalprice:
                                                prod.totalprice.toString(),
                                            productprice:
                                                prod.productprice.toString(),
                                            quantity: prod.quantity.toString(),
                                            desc: prod.desc,
                                            buySaleQuantity:
                                                prod.buySaleQ.toString(),
                                            lastPurchase:
                                                prod.lastPurchase.toString(),
                                            lastSale: prod.lastSale.toString(),
                                            stock: prod.stock))
                                        .toList() ??
                                    [],
                                contact: e.contact,
                                remainigBalance: e.remainigBalance.toString(),
                                paidBalance: e.paidBalance.toString(),
                                discount: e.discount.toString(),
                              ))
                          .toList() ??
                      [],
                )));
                for (Datum2 sup in s.data ?? []) {
                  DatabaseHelper().insertOrUpdateData(
                      Datum(
                        customerId: sup.id,
                        name: sup.name,
                        soldProducts: sup.soldProducts
                                ?.map((prod) => InventoryItem(
                                  type: '',
                                    id: prod.id,
                                    title: prod.title,
                                    date: prod.date,
                                    totalprice: prod.totalprice.toString(),
                                    productprice: prod.productprice.toString(),
                                    quantity: prod.quantity.toString(),
                                    desc: prod.desc,
                                    buySaleQuantity: prod.buySaleQ.toString(),
                                    lastPurchase: prod.lastPurchase.toString(),
                                    lastSale: prod.lastSale.toString(),
                                    stock: prod.stock))
                                .toList() ??
                            [],
                        contact: sup.contact,
                        remainigBalance: sup.remainigBalance.toString(),
                        paidBalance: sup.paidBalance.toString(),
                        discount: sup.discount.toString(),
                      ),
                      true,
                      s.soldDate ?? '',
                      soldDate: s.soldDate ?? '');
                }
              }

              for (Purchase s in d.purchases ?? []) {
                DatabaseHelper().addPurchaseData(SalesModel(
                  soldDate: s.soldDate ?? '',
                  id: s.id,
                  data: s.data
                          ?.map((e) => Datum(
                                customerId: e.id,
                                name: e.name,
                                soldProducts: e.soldProducts
                                        ?.map((prod) => InventoryItem(
                                          type: '',
                                            id: prod.id,
                                            title: prod.title,
                                            date: prod.date,
                                            totalprice:
                                                prod.totalprice.toString(),
                                            productprice:
                                                prod.productprice.toString(),
                                            quantity: prod.quantity.toString(),
                                            desc: prod.desc,
                                            buySaleQuantity:
                                                prod.buySaleQ.toString(),
                                            lastPurchase:
                                                prod.lastPurchase.toString(),
                                            lastSale: prod.lastSale.toString(),
                                            stock: prod.stock))
                                        .toList() ??
                                    [],
                                contact: e.contact,
                                remainigBalance: e.remainigBalance.toString(),
                                paidBalance: e.paidBalance.toString(),
                                discount: e.discount.toString(),
                              ))
                          .toList() ??
                      [],
                ));
                for (Datum2 sup in s.data ?? []) {
                  DatabaseHelper().insertOrUpdateData(
                      Datum(
                        customerId: sup.id,
                        name: sup.name,
                        soldProducts: sup.soldProducts
                                ?.map((prod) => InventoryItem(
                                  type: '',
                                    id: prod.id,
                                    title: prod.title,
                                    date: prod.date,
                                    totalprice: prod.totalprice.toString(),
                                    productprice: prod.productprice.toString(),
                                    quantity: prod.quantity.toString(),
                                    desc: prod.desc,
                                    buySaleQuantity: prod.buySaleQ.toString(),
                                    lastPurchase: prod.lastPurchase.toString(),
                                    lastSale: prod.lastSale.toString(),
                                    stock: prod.stock))
                                .toList() ??
                            [],
                        contact: sup.contact,
                        remainigBalance: sup.remainigBalance.toString(),
                        paidBalance: sup.paidBalance.toString(),
                        discount: sup.discount.toString(),
                      ),
                      false,
                      s.soldDate ?? '',
                      soldDate: s.soldDate ?? '');
                
                }
              }

              storage.setUid(d.businessInfo?.id.toString() ?? '');
              storage.setName(d.businessInfo?.title.toString() ?? '');
              storage.setNumber(d.businessInfo?.contact.toString() ?? '');
              storage.setAddress(d.businessInfo?.address.toString() ?? '');
              storage.setEmail(d.businessInfo?.email.toString() ?? '');
            });
          });

          Navigator.pushReplacementNamed(context, Routes.dashboard);
        } else {
          DatabaseHelper.initDb();
          storage.setEmail(email.text);
          print(data.the0!.id);
          storage.setUid(data.the0!.id.toString() ?? '');
          storage.setName(data.the0!.title.toString() ?? '');
          storage.setNumber(data.the0!.contact.toString() ?? '');
          storage.setAddress(data.the0!.address.toString() ?? '');
          Navigator.pushReplacementNamed(context, Routes.dashboard);
        }
        changeLoading(false);
      } else {
        changeLoading(false);
      }
    }
  }

  List<String> categories = <String>[
    "Medical Store",
    "Dry Fruit Store",
    "Tailor Shop",
    "Fruit Shop",
    "Mobile easy load",
    "Mobile Repairing Shop",
    "Computer Shop",
    "Chicken Shop",
    "Restaurant",
    "Grocery Shop",
    "Sports Accessories",
    "Kiryana",
    "Retailers",
    "Bakery",
    "Tailoring",
    "Beauty parlor",
    'Book Shop',
    "Vehical Spear part Shop",
    "Others",
  ];

  bool _showList = false;
  bool get showList => _showList;
  changeShowlist() {
    _showList = !_showList;
    notifyListeners();
  }

  bool _readOnly = true;
  bool get readOnly => _readOnly;
  toggleReadonly() {
    _readOnly = !_readOnly;
    notifyListeners();
  }
}
