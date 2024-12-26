import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/db/database_helper.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/gen/assets.gen.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/provider/inventory_provider.dart';
import 'package:sales_management/screens/inventory/component/delete_product_popup.dart';
import 'package:sales_management/screens/inventory/component/item_widget.dart';
import 'package:sales_management/utils/date_formatter.dart';
import 'package:sales_management/utils/popup_menu.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/text_button.dart';
import 'package:sales_management/utils/text_field.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Provider.of<InventoryProvider>(context, listen: false).getInventoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              context.heightBox(0.01),
              textField(
                  onChange: (val) {
                    if (val != null) {
                      provider.searchInventoryByTitle(
                          provider.inventoryList, val);
                    }
                  },
                  suffixIcon: GestureDetector(
                    onTap: () {
                      provider.search.clear();
                      provider.clearFilter();
                    },
                    child: Icon(Icons.close),
                  ),
                  context: context,
                  controller: provider.search,
                  hintText: 'Search',
                  prefixIcon: GestureDetector(
                    child: Icon(Icons.search),
                  )),
              context.heightBox(0.01),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: provider.scrollController,
                  child: provider.filterList.isEmpty
                      ? Column(
                          children: List.generate(provider.inventoryList.length,
                              (index) {
                            final inv = provider.inventoryList[index];
                            return inv.data.isEmpty
                                ? const SizedBox.shrink()
                                : Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: ColorPalette.green,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  appText(
                                                      textColor:
                                                          ColorPalette.white,
                                                      context: context,
                                                      title: dateFormatter('dd',
                                                              inv.addingDate) +
                                                          ' ',
                                                      fontSize: 16),
                                                  appText(
                                                      textColor:
                                                          ColorPalette.white,
                                                      context: context,
                                                      title: dateFormatter(
                                                              'MMMM',
                                                              inv.addingDate) ??
                                                          '',
                                                      fontSize: 16),
                                                  appText(
                                                      textColor:
                                                          ColorPalette.white,
                                                      context: context,
                                                      title: ' ' +
                                                              dateFormatter(
                                                                  'yyyy',
                                                                  inv.addingDate) ??
                                                          '',
                                                      fontSize: 16),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        context.heightBox(0.005),
                                        SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            dataRowHeight:
                                                context.getSize.height * 0.05,
                                            border: TableBorder.all(
                                                color: ColorPalette.black
                                                    .withOpacity(0.2)),
                                            columns: [
                                              DataColumn(
                                                  label: appText(
                                                      textAlign: TextAlign.left,
                                                      fontSize: 14,
                                                      context: context,
                                                      title: 'Product Title')),
                                              DataColumn(
                                                  label: appText(
                                                      fontSize: 14,
                                                      context: context,
                                                      title: 'Stock')),
                                              DataColumn(
                                                  label: appText(
                                                      textAlign: TextAlign.left,
                                                      fontSize: 14,
                                                      context: context,
                                                      title: 'Quantity')),
                                              DataColumn(
                                                  label: appText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontSize: 14,
                                                      context: context,
                                                      title: 'Unit Price')),
                                              DataColumn(
                                                  label: appText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontSize: 14,
                                                      context: context,
                                                      title: 'Last Sale')),
                                              DataColumn(
                                                  label: appText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontSize: 14,
                                                      context: context,
                                                      title: 'Last Purchase')),
                                              DataColumn(
                                                  label: appText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontSize: 14,
                                                      context: context,
                                                      title: 'Description')),
                                              DataColumn(
                                                  label: appText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontSize: 14,
                                                      context: context,
                                                      title: 'Remove')),
                                            ],
                                            rows: inv.data.map((item) {
                                              return DataRow(
                                                  color: MaterialStateProperty
                                                      .resolveWith<Color?>(
                                                    (Set<MaterialState>
                                                        states) {
                                                      int quantity = item
                                                                  .quantity ==
                                                              ""
                                                          ? 0
                                                          : int.parse(
                                                              item.quantity);
                                                      if (quantity < 10 &&
                                                          quantity > 0) {
                                                        return ColorPalette
                                                            .amber
                                                            .withOpacity(
                                                                0.2); // Light red for low quantity
                                                      } else if (quantity <=
                                                          0) {
                                                        return ColorPalette.red
                                                            .withOpacity(0.3);
                                                      }
                                                      return null; // Default row color
                                                    },
                                                  ),
                                                  cells: [
                                                    DataCell(Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: appText(
                                                            context: context,
                                                            title: item.title ??
                                                                '',
                                                            fontSize: 14))),
                                                    DataCell(
                                                      Center(
                                                          child: appText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              context: context,
                                                              title:
                                                                  item.stock ??
                                                                      '',
                                                              fontSize: 14)),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                          child: appText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              context: context,
                                                              title: item.quantity ==
                                                                          '0' ||
                                                                      item.quantity ==
                                                                          ''
                                                                  ? ''
                                                                  : item
                                                                      .quantity,
                                                              fontSize: 14)),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                          child: appText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              context: context,
                                                              title: item.productprice ==
                                                                      ""
                                                                  ? '0.00'
                                                                  : double.parse(
                                                                          item.productprice ??
                                                                              '0.0')
                                                                      .toStringAsFixed(
                                                                          2),
                                                              fontSize: 14)),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                          child: appText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              context: context,
                                                              title: item.lastSale ==
                                                                      ""
                                                                  ? '0.00'
                                                                  : double.parse(
                                                                          item.lastSale ??
                                                                              '0.0')
                                                                      .toStringAsFixed(
                                                                          2),
                                                              fontSize: 14)),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                          child: appText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              context: context,
                                                              title: item.lastPurchase ==
                                                                      ""
                                                                  ? '0.00'
                                                                  : double.parse(
                                                                          item.lastPurchase ??
                                                                              '0.0')
                                                                      .toStringAsFixed(
                                                                          2),
                                                              fontSize: 14)),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                          child: appText(
                                                              maxLine: 10,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              context: context,
                                                              title:
                                                                  item.desc ??
                                                                      '',
                                                              fontSize: 14)),
                                                    ),
                                                    DataCell(Center(
                                                        child:
                                                            deleteProductPopup(
                                                      context: context,
                                                      title: item.title ?? '',
                                                      onPressed: () {
                                                        DatabaseHelper
                                                                .deleteInventoryItem(
                                                                    item.id ??
                                                                        0)
                                                            .then((v) {
                                                          provider
                                                              .getInventoryData();
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                    ))),
                                                  ]);
                                            }).toList(),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                          }),
                        )
                      : Column(
                          children: List.generate(provider.filterList.length,
                              (index2) {
                            InventoryItem item = provider.filterList[index2];
                            return Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: ColorPalette.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            ColorPalette.black.withOpacity(0.2),
                                        offset: const Offset(0, 5),
                                        blurRadius: 5)
                                  ]),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      appText(
                                          context: context,
                                          title: 'Product Title',
                                          fontSize: 15),
                                      appText(
                                          context: context,
                                          title: item.title ?? '',
                                          fontSize: 15),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      appText(
                                          context: context,
                                          title: 'Stock',
                                          fontSize: 15),
                                      appText(
                                          context: context,
                                          title: item.stock ?? '',
                                          fontSize: 15),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      appText(
                                          context: context,
                                          title: 'Quantity',
                                          fontSize: 15),
                                      appText(
                                          context: context,
                                          title: item.quantity ?? '',
                                          fontSize: 15),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      appText(
                                          context: context,
                                          title: 'Product Price',
                                          fontSize: 15),
                                      appText(
                                          context: context,
                                          title:
                                              'PKR: ' + "${item.productprice}",
                                          fontSize: 15),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      appText(
                                          context: context,
                                          title: 'Total Price',
                                          fontSize: 15),
                                      appText(
                                          context: context,
                                          title: 'PKR: ' + "${item.totalprice}",
                                          fontSize: 15),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  provider.scrollToEnd();
                },
                child: SvgPicture.asset(
                  Assets.svg.dropDown,
                  height: context.getSize.height * 0.07,
                  color: ColorPalette.green,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: textButton(
                  context: context,
                  onTap: () {
                    Navigator.pushNamed(context, Routes.add, arguments: 0);
                  },
                  title: 'Add New Product',
                  radius: 10,
                ),
              ),
              context.heightBox(0.01)
            ],
          ),
        );
      },
    );
  }
}
