import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/constant/enums.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/gen/assets.gen.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/provider/add_product_provider.dart';
import 'package:sales_management/provider/dashboard_provider.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/box_shadow.dart';
import 'package:sales_management/utils/expanded_tile.dart';
import 'package:sales_management/utils/popup_menu.dart';
import 'package:sales_management/utils/text_button.dart';
import 'package:sales_management/utils/text_field.dart';
import 'package:sales_management/utils/toast.dart';

import '../../../bindings/routes.dart';
import 'add_new_prdouct_expended_tile.dart';

class AddNewItem extends StatefulWidget {
  final int type;
  const AddNewItem({super.key, required this.type});

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AddProductProvider>(context, listen: false)
        .getInventoryData(widget.type == 2 ? false : true);
    Provider.of<AddProductProvider>(context, listen: false).getSales();
    Provider.of<AddProductProvider>(context, listen: false).getPurchase();

    super.initState();
  }

  TextEditingController phoneCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            if (widget.type == 0) {
              // Navigator.pop(context);
              // Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, Routes.add,
                  arguments: widget.type);
            }
            if (widget.type != 0) {
              Navigator.pushReplacementNamed(context, Routes.dashboard)
                  .then((val) {
                Provider.of<DashboardProvider>(context, listen: false)
                    .changeIndex(widget.type);
              });
              Provider.of<AddProductProvider>(context, listen: false)
                  .clearField();
              Provider.of<AddProductProvider>(context, listen: false)
                  .clearAllData();
            }
          },
          child: const Icon(
            Icons.keyboard_arrow_left,
            color: ColorPalette.white,
            size: 30,
          ),
        ),
        backgroundColor: ColorPalette.green,
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (val) {
          if (widget.type == 0) {
            // Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, Routes.add,
                arguments: widget.type);
          }
          if (widget.type != 0) {
            Navigator.pushReplacementNamed(context, Routes.dashboard).then((v) {
              Provider.of<DashboardProvider>(context, listen: false)
                  .changeIndex(widget.type);
            });
            Provider.of<AddProductProvider>(context, listen: false)
                .clearField();
            Provider.of<AddProductProvider>(context, listen: false)
                .clearAllData();
          }
        },
        child: Consumer<AddProductProvider>(builder: (context, provider, __) {
          return widget.type == 0
              ? ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shrinkWrap: true,
                  children: [
                    textField(
                        suffixIcon: GestureDetector(
                            child: Icon(
                          provider.showModule
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: ColorPalette.white,
                        )),
                        hintColor: ColorPalette.white,
                        bgColor: ColorPalette.green,
                        readOnly: true,
                        onTap: () {
                          provider.toggleShowModule();
                        },
                        context: context,
                        controller: TextEditingController(),
                        hintText: provider.selectedModuleType.name),
                    if (provider.showModule) context.heightBox(0.01),
                    if (provider.showModule)
                      expandedTile(
                          context: context,
                          dataList: provider.modulesType,
                          onTap: (val) {
                            provider.changeModuleType(val);
                            provider.toggleShowModule();
                          }),
                    context.heightBox(0.01),
                    textField(
                        context: context,
                        controller: provider.title,
                        hintText: 'Product Title'),
                    context.heightBox(0.01),
                    if (provider.selectedModuleType == ModuleType.inventory)
                      textField(
                          suffixIcon: GestureDetector(
                              child: Icon(
                            provider.showUnits
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: ColorPalette.white,
                          )),
                          hintColor: ColorPalette.white,
                          bgColor: ColorPalette.green,
                          readOnly: true,
                          onTap: () {
                            provider.toggleShowUnit();
                          },
                          context: context,
                          controller: TextEditingController(),
                          hintText: provider.selectedUnit),
                    if (provider.showUnits) context.heightBox(0.01),
                    if (provider.showUnits)
                      expandedTile(
                          context: context,
                          dataList: provider.unitsList,
                          onTap: (val) {
                            provider.selectNewUnit(val);
                            provider.toggleShowUnit();
                          }),
                    if (provider.selectedModuleType == ModuleType.inventory)
                      context.heightBox(0.01),
                    if (provider.selectedModuleType == ModuleType.inventory)
                      Row(
                        children: [
                          Expanded(
                            child: numberTextField(
                                context: context,
                                textInputType: TextInputType.number,
                                controller: provider.lastSale,
                                hintText: 'Last Sale'),
                          ),
                          context.widthBox(0.01),
                          Expanded(
                            child: numberTextField(
                                context: context,
                                textInputType: TextInputType.number,
                                controller: provider.lastPurchase,
                                hintText: 'Last Purchase'),
                          )
                        ],
                      ),
                    if (provider.selectedModuleType == ModuleType.inventory)
                      context.heightBox(0.01),
                    if (provider.selectedModuleType == ModuleType.inventory)
                      numberTextField(
                        textInputType: TextInputType.number,
                        context: context,
                        controller: provider.quantity,
                        hintText: 'Current Stock',
                        onChange: (val) {
                          if (val == null ||
                              provider.productprice.text.isEmpty ||
                              val == '') {
                          } else {
                            provider.totalprice.text =
                                (double.parse(provider.productprice.text) *
                                        double.parse(val ?? '0.0'))
                                    .toString();
                          }
                        },
                      ),
                    if (provider.selectedModuleType == ModuleType.inventory)
                      context.heightBox(0.01),
                    if (provider.selectedModuleType == ModuleType.inventory)
                      textField(
                          context: context,
                          controller: provider.description,
                          hintText: 'Description'),
                    context.heightBox(0.01),
                    Row(
                      children: [
                        Expanded(
                            child: numberTextField(
                                textInputType: TextInputType.number,
                                context: context,
                                onChange: (val) {
                                  if (provider.selectedModuleType !=
                                      ModuleType.inventory) {
                                  } else {
                                    if (val == null &&
                                        provider.quantity.text.isEmpty) {
                                    } else {
                                      provider.totalprice.text = (double.parse(
                                                  provider.quantity.text) *
                                              double.parse(val ?? '0.0'))
                                          .toString();
                                    }
                                  }
                                },
                                controller: provider.productprice,
                                hintText: 'Current Price')),
                        if (provider.selectedModuleType == ModuleType.inventory)
                          context.widthBox(0.01),
                        if (provider.selectedModuleType == ModuleType.inventory)
                          Expanded(
                              child: numberTextField(
                                  textInputType: TextInputType.number,
                                  context: context,
                                  readOnly: true,
                                  controller: provider.totalprice,
                                  hintText: 'Total Price')),
                      ],
                    ),
                    context.heightBox(0.01),
                    textButton(
                        context: context,
                        onTap: () {
                          provider
                              .addItem(
                                  context: context,
                                  type: widget.type,
                                  item: InventoryItem.fromJson({}))
                              .then((e) {
                            if (provider.isInsert) {
                              provider.clearField();
                            }
                          });
                        },
                        title: 'Add',
                        radius: 4),
                    context.heightBox(0.01),
                    textButton(
                        bgColor: ColorPalette.red,
                        context: context,
                        onTap: () {
                          provider.clearField();
                          Navigator.pushReplacementNamed(context, Routes.add,
                              arguments: widget.type);
                        },
                        title: 'Cancel',
                        radius: 4),
                  ],
                )
              : ListView(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  children: [
                    context.heightBox(0.01),
                    GestureDetector(
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1991),
                            lastDate: DateTime.now());
                        if (date != null) {
                          provider.changePickedDate(date);
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: ColorPalette.green,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                boxShadow(
                                    context: context,
                                    blur: 5,
                                    y: 5,
                                    color: ColorPalette.black,
                                    opacity: 0.2)
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.date_range,
                                color: ColorPalette.white,
                              ),
                              appText(
                                  context: context,
                                  title: DateFormat('yyyy-MM-dd')
                                      .format(provider.pickedDate),
                                  textColor: ColorPalette.white,
                                  fontSize: 16),
                            ],
                          )),
                    ),
                    context.heightBox(0.01),
                    addNewProductExpandedTile(
                        icon: Assets.svg.box,
                        onTap: () {
                          provider.toggleExpandedName();
                        },
                        context: context,
                        isExpanded: provider.expandedName,
                        title: widget.type == 1
                            ? 'Customer Name'
                            : 'Supplier Name'),
                    if (provider.expandedName)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          context.heightBox(0.01),
                          popupMenuSupplierAndCustomer(
                              context: context,
                              dataList: widget.type == 1
                                  ? provider.customerList
                                  : provider.supplierList,
                              selectedItem: widget.type == 2
                                  ? 'Select Old Supplier'
                                  : 'Select Old Customer',
                              onSelect: (val) {
                                print(val.contact);
                                provider.selectedId.text =
                                    val.customerId.toString();
                                provider.name.text = val.name ?? "";

                                provider.phone.text = val.contact ?? '';
                                // print(provider.phone.text);
                              }),
                          context.heightBox(0.01),
                          textField(
                              onChange: (v) {
                                if (v != null) {
                                  provider.name.text = v;
                                  provider.selectedId.text = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                }
                              },
                              prefixIcon: GestureDetector(
                                  child: const Icon(
                                Ionicons.person,
                                color: ColorPalette.green,
                              )),
                              bgColor: ColorPalette.white,
                              opacity: 1,
                              context: context,
                              controller: provider.name,
                              hintText: widget.type == 1
                                  ? 'Customer Name'
                                  : 'Supplier Name'),
                          context.heightBox(0.01),
                          phoneField(
                              onChangePhone: (val) {
                                if (val != null) {
                                  provider.selectedId.text = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  print(provider.phone.text);
                                }
                              },
                              context: context,
                              textInputType: TextInputType.number,
                              controller: provider.phone,
                              hintText: 'Contact Number',
                              initialValue: PhoneNumber(isoCode: 'PK'))
                        ],
                      ),
                    context.heightBox(0.02),
                    addNewProductExpandedTile(
                        icon: Assets.svg.addItem,
                        onTap: () {
                          provider.toggleAddItem();
                        },
                        context: context,
                        isExpanded: provider.showAddItem,
                        title: "Add Item"),
                    if (!provider.showAddItem)
                      SizedBox(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: ColorPalette.white,
                              boxShadow: [
                                boxShadow(
                                    context: context,
                                    y: 5,
                                    opacity: 0.2,
                                    blur: 5,
                                    color: ColorPalette.black)
                              ]),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: context.getSize.width * 0.2,
                                        child: appText(
                                            textAlign: TextAlign.center,
                                            context: context,
                                            title: 'Product',
                                            fontSize: 13),
                                      ),
                                      SizedBox(
                                        width: context.getSize.width * 0.19,
                                        child: appText(
                                            textAlign: TextAlign.center,
                                            context: context,
                                            title: "Unit Price",
                                            fontSize: 13),
                                      ),
                                      SizedBox(
                                        width: context.getSize.width * 0.18,
                                        child: appText(
                                            textAlign: TextAlign.center,
                                            context: context,
                                            title: "Quantity",
                                            fontSize: 13),
                                      ),
                                      SizedBox(
                                        width: context.getSize.width * 0.19,
                                        child: appText(
                                            textAlign: TextAlign.center,
                                            context: context,
                                            title: "Total Price",
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  context.widthBox(0.01),
                                  const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              context.heightBox(0.01),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                    widget.type == 1
                                        ? provider.salesItems.length
                                        : provider.purchaseItems.length,
                                    (index) {
                                  InventoryItem item = widget.type == 1
                                      ? provider.salesItems[index]
                                      : provider.purchaseItems[index];
                                  return Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: context.getSize.width * 0.2,
                                            child: appText(
                                                textAlign: TextAlign.center,
                                                maxLine: 2,
                                                context: context,
                                                title: item.title ?? "",
                                                fontSize: 13),
                                          ),
                                          SizedBox(
                                            width: context.getSize.width * 0.19,
                                            child: appText(
                                                textAlign: TextAlign.center,
                                                context: context,
                                                title: (item.lastPurchase
                                                            .toString() +
                                                        '/' +
                                                        item.stock
                                                            .toString()) ??
                                                    '',
                                                fontSize: 13),
                                          ),
                                          SizedBox(
                                              width:
                                                  context.getSize.width * 0.18,
                                              child: Center(
                                                child: appText(
                                                    textAlign: TextAlign.center,
                                                    context: context,
                                                    title:
                                                        item.buySaleQuantity ??
                                                            '',
                                                    fontSize: 13),
                                              )),
                                          SizedBox(
                                            width: context.getSize.width * 0.19,
                                            child: appText(
                                                textAlign: TextAlign.center,
                                                context: context,
                                                title: item.totalprice ?? '',
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      context.widthBox(0.01),
                                      GestureDetector(
                                        onTap: () {
                                          provider.removeItem(
                                              index, widget.type);
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          context.heightBox(0.01),
                          Row(
                            children: [
                              Expanded(
                                child: textField(
                                  bgColor: ColorPalette.green,
                                  hintColor: ColorPalette.white,
                                  controller: TextEditingController(),
                                  hintText: provider.selectedInventoryItem,
                                  readOnly: true,
                                  onTap: () {
                                    popupMenuProduct(
                                        context: context,
                                        selectedItem:
                                            provider.selectedInventoryItem,
                                        onSelect: (val) {
                                          provider.onSelectInventoryItem(val);
                                          if (widget.type == 1) {
                                            provider.productprice.text =
                                                val.productprice ?? '0.0';
                                          }
                                        });
                                  },
                                  context: context,
                                ),
                              ),
                              if (provider.selectedItem.type !=
                                  ModuleType.services.name)
                                context.widthBox(0.01),
                              if (provider.selectedItem.type !=
                                  ModuleType.services.name)
                                Expanded(
                                  child: numberTextField(
                                      isFormatter: false,
                                      textInputType: TextInputType.number,
                                      onChange: (val) {
                                        if (val == null ||
                                            provider
                                                .productprice.text.isEmpty ||
                                            val == '') {
                                        } else {
                                          provider.totalprice
                                              .text = (double.parse(provider
                                                      .productprice.text) *
                                                  double.parse(val ?? '0.0'))
                                              .toString();
                                        }
                                      },
                                      bgColor: ColorPalette.white,
                                      opacity: 1,
                                      context: context,
                                      controller: provider.quantity,
                                      hintText: 'Quantity'),
                                )
                            ],
                          ),
                          context.heightBox(0.01),
                          if (widget.type == 2)
                            numberTextField(
                                textInputType: TextInputType.number,
                                bgColor: ColorPalette.white,
                                opacity: 1,
                                context: context,
                                controller: provider.lastPurchase,
                                hintText: 'Purchase Rate (per Unit)'),
                          if (widget.type == 2) context.heightBox(0.01),
                          Row(
                            children: [
                              Expanded(
                                  child: numberTextField(
                                      isFormatter: false,
                                      textInputType: TextInputType.number,
                                      readOnly: widget.type == 1 ? true : false,
                                      onChange: (val) {
                                        // if (widget.type == 1) {
                                        //
                                        // }
                                        if (val == null &&
                                            provider.quantity.text.isEmpty) {
                                        } else {
                                          provider
                                              .totalprice.text = (double.parse(
                                                      provider.quantity.text) *
                                                  double.parse(val ?? '0.0'))
                                              .toString();
                                        }
                                      },
                                      bgColor: ColorPalette.white,
                                      opacity: 1,
                                      context: context,
                                      controller: provider.productprice,
                                      hintText: 'Sale Rate (per Unit)')),
                              context.widthBox(0.01),
                              if (provider.selectedItem.type !=
                                  ModuleType.services.name)
                                Expanded(
                                  child: textField(
                                      readOnly: true,
                                      bgColor: ColorPalette.white,
                                      opacity: 1,
                                      context: context,
                                      controller: provider.unitVal,
                                      hintText: 'Measurement Unit'),
                                )
                            ],
                          ),
                          context.heightBox(0.01),
                          if (widget.type == 1 &&
                              provider.selectedItem.type !=
                                  ModuleType.services.name)
                            textField(
                                onChange: (val) {
                                  final v = double.parse(val ?? '0.0') /
                                      double.parse(
                                          provider.selectedItem.productprice ??
                                              '0.0');
                                  provider.quantity.text = v.toStringAsFixed(2);
                                },
                                readOnly: widget.type == 1 ? false : true,
                                bgColor: ColorPalette.white,
                                opacity: 1,
                                context: context,
                                controller: provider.totalprice,
                                hintText: 'Total Price'),
                          if (widget.type == 1) context.heightBox(0.01),
                          GestureDetector(
                            onTap: () {
                              print(
                                  "Selected Data ${provider.selectedItem.quantity}");
                              if (widget.type == 1) {
                                provider
                                    .addItem(
                                        context: context,
                                        type: 1,
                                        item: provider.selectedItem)
                                    .then((e) {
                                  provider.clearSalesAndPurchaseField();
                                  provider.toggleAddItem();
                                });
                              } else {
                                provider
                                    .addItem(
                                        context: context,
                                        type: 2,
                                        item: provider.selectedItem)
                                    .then((e) {
                                  provider.clearSalesAndPurchaseField();
                                  provider.toggleAddItem();
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: ColorPalette.green,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(Assets.svg.addCart),
                                  context.widthBox(0.01),
                                  appText(
                                      context: context,
                                      title: 'Add Cart',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      textColor: ColorPalette.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (!provider.showAddItem) context.heightBox(0.01),
                    if (!provider.showAddItem)
                      numberTextField(
                          onChange: (val) {
                            if (val == null || val == '') {
                              provider.changeDiscountAdded(false);
                            }
                          },
                          textInputType: TextInputType.number,
                          prefixIcon: GestureDetector(
                            child: const Icon(
                              Icons.discount,
                              color: ColorPalette.green,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: provider.isDiscountAdded
                                ? () {}
                                : () {
                                    if (provider.completetPrice >=
                                        double.parse(provider.dicount.text)) {
                                      provider.addDiscount();
                                    }
                                  },
                            child: const Icon(
                              Icons.add_circle,
                              color: ColorPalette.green,
                              size: 30,
                            ),
                          ),
                          context: context,
                          controller: provider.dicount,
                          hintText: "Add Discount"),
                    context.heightBox(0.03),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ColorPalette.green.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          appText(
                              context: context,
                              title: 'Grand Total',
                              fontSize: 16,
                              textColor: ColorPalette.white),
                          appText(
                              context: context,
                              title: 'PKR: ${provider.completetPrice}',
                              fontSize: 16,
                              textColor: ColorPalette.white),
                        ],
                      ),
                    ),
                    context.heightBox(0.01),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorPalette.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            boxShadow(
                                context: context,
                                y: 5,
                                blur: 5,
                                color: ColorPalette.black,
                                opacity: 0.2)
                          ]),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.payments,
                            color: ColorPalette.green,
                          ),
                          context.widthBox(0.02),
                          appText(
                              context: context,
                              title: "Payment",
                              fontWeight: FontWeight.w400),
                          const Spacer(),
                          SizedBox(
                              width: context.getSize.width * 0.3,
                              child: textField(
                                  textInputType: TextInputType.number,
                                  onChange: (val) {
                                    if (val != null) {
                                      if (double.parse(val ?? '0.0') >
                                          provider.completetPrice) {
                                        toast(
                                            msg:
                                                'Paid Price must be less than equal to Grand total',
                                            context: context);
                                      } else {
                                        provider.getRemainingBalanc();
                                      }
                                    }
                                  },
                                  context: context,
                                  controller: provider.payment,
                                  hintText: 'PKR: 0.0')),
                        ],
                      ),
                    ),
                    context.heightBox(0.01),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorPalette.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            boxShadow(
                                context: context,
                                y: 5,
                                blur: 5,
                                color: ColorPalette.black,
                                opacity: 0.2)
                          ]),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.wallet,
                            color: ColorPalette.white,
                          ),
                          context.widthBox(0.02),
                          appText(
                              context: context,
                              title: "Balance",
                              fontWeight: FontWeight.w400,
                              textColor: ColorPalette.white),
                          const Spacer(),
                          appText(
                              context: context,
                              title: 'Pkr: ${provider.remainingBalance}',
                              textColor: ColorPalette.white),
                        ],
                      ),
                    ),
                    context.heightBox(0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: context.getSize.width * 0.3,
                          child: textButton(
                              context: context,
                              onTap: () {
                                if (widget.type != 0) {
                                  provider.clearField();
                                  provider.clearAllData();
                                }
                                Navigator.pushReplacementNamed(
                                        context, Routes.dashboard)
                                    .then((e) {
                                  Provider.of<DashboardProvider>(context)
                                      .changeIndex(widget.type);
                                });
                              },
                              title: 'Cancel',
                              radius: 10,
                              bgColor: ColorPalette.red),
                        ),
                        context.widthBox(0.04),
                        SizedBox(
                          width: context.getSize.width * 0.3,
                          child: textButton(
                              context: context,
                              onTap: () {
                                if (widget.type == 1) {
                                  bool exist = provider.customerList.any((e) =>
                                      e.name!.toLowerCase() ==
                                          provider.name.text
                                              .toLowerCase()
                                              .trimRight() &&
                                      e.customerId.toString() !=
                                          provider.selectedId.text);
                                  print(
                                      'Exist $exist,${provider.selectedId.text}');
                                  if (exist) {
                                    toast(
                                        msg:
                                            'Customer with name ${provider.name.text} already  exist. Try with new name',
                                        maxline: 2,
                                        context: context);
                                  } else {
                                    print(
                                        "Payment ${provider.payment.text} ${provider.name.text},${provider.completetPrice}");
                                    if (double.parse(
                                            provider.payment.text ?? '0.0') >
                                        provider.completetPrice) {
                                      toast(
                                          msg:
                                              'Paid Price must be less than equal to Grand total',
                                          context: context);
                                    } else {
                                      if ((provider.name.text.isEmpty ||
                                              provider.name.text ==
                                                  "Walking") &&
                                          double.parse(provider.payment.text) !=
                                              provider.completetPrice) {
                                        toast(
                                            msg:
                                                'please enter complete payment!. its walking one',
                                            maxline: 2,
                                            context: context);
                                      } else {
                                        provider.addSalesData(
                                          provider.salesItems,
                                          context,
                                          widget.type,
                                        );
                                      }
                                    }
                                  }
                                } else {
                                  bool exist = provider.supplierList.any((e) =>
                                      e.name!.toLowerCase() ==
                                          provider.name.text
                                              .toLowerCase()
                                              .trimRight() &&
                                      e.customerId.toString() !=
                                          provider.selectedId.text);
                                  print(
                                      'Exist $exist,${provider.selectedId.text}');
                                  if (exist) {
                                    toast(
                                        msg:
                                            'Supplier with name ${provider.name.text} already  exist. Try with new name',
                                        maxline: 2,
                                        context: context);
                                  } else {
                                    if (double.parse(
                                            provider.payment.text ?? '0.0') >
                                        provider.completetPrice) {
                                      toast(
                                          msg:
                                              'Paid Price must be less than equal to Grand total',
                                          context: context);
                                    } else {
                                      if ((provider.name.text.isEmpty ||
                                              provider.name.text ==
                                                  "Walking") &&
                                          double.parse(provider.payment.text) !=
                                              provider.completetPrice) {
                                        toast(
                                            msg:
                                                'ok enter complete payment!. its walking one',
                                            maxline: 2,
                                            context: context);
                                      } else {
                                        provider.addPurchaseData(
                                            provider.purchaseItems,
                                            context,
                                            widget.type);
                                      }
                                    }
                                  }
                                }
                              },
                              title: widget.type == 1 ? 'Sold Now' : 'Purchase',
                              radius: 10,
                              bgColor: ColorPalette.parrot),
                        ),
                      ],
                    )
                  ],
                );
        }),
      ),
    );
  }
}
