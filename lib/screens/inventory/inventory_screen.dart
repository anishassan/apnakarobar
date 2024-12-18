import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/gen/assets.gen.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/provider/inventory_provider.dart';
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
                            return Container(
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
                                        appText(
                                            textColor: ColorPalette.white,
                                            context: context,
                                            title: DateFormat('dd MMMM yyyy')
                                                    .format(DateTime(
                                                        int.parse(inv
                                                            .addingDate!
                                                            .split('-')[0]),
                                                        int.parse(inv
                                                            .addingDate!
                                                            .split('-')[1]),
                                                        int.parse(inv
                                                            .addingDate!
                                                            .split('-')[2]))) ??
                                                '',
                                            fontSize: 16),
                                        // appText(
                                        //     textColor: ColorPalette.white,
                                        //     context: context,
                                        //     title: 'PKR: ${inv.totalprice}',
                                        //     fontSize: 16)
                                      ],
                                    ),
                                  ),
                                  context.heightBox(0.005),
                                  Column(
                                    children: List.generate(inv.data.length,
                                        (index2) {
                                      InventoryItem item = inv.data[index2];
                                      print(item.lastPurchase);
                                      return Container(
                                        padding: const EdgeInsets.all(20),
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            color: ColorPalette.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: ColorPalette.black
                                                      .withOpacity(0.2),
                                                  offset: const Offset(0, 5),
                                                  blurRadius: 5)
                                            ]),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appText(
                                                    context: context,
                                                    title: 'Product Title',
                                                    fontSize: 15),
                                                appText(
                                                    context: context,
                                                    title: item.title ?? "",
                                                    fontSize: 15),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appText(
                                                    context: context,
                                                    title: 'Stock',
                                                    fontSize: 15),
                                                appText(
                                                    context: context,
                                                    title: item.quantity ?? '',
                                                    fontSize: 15),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appText(
                                                    context: context,
                                                    title: 'Measurment Unit',
                                                    fontSize: 15),
                                                appText(
                                                    context: context,
                                                    title: item.stock ?? "",
                                                    fontSize: 15),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appText(
                                                    context: context,
                                                    title: 'Product Price',
                                                    fontSize: 15),
                                                appText(
                                                    context: context,
                                                    title: 'PKR: ' +
                                                        " ${item.productprice ?? ""}",
                                                    fontSize: 15),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appText(
                                                    context: context,
                                                    title: 'Last Purchase',
                                                    fontSize: 15),
                                                appText(
                                                    context: context,
                                                    title: 'PKR: ' +
                                                        "${item.lastPurchase ?? ''}",
                                                    fontSize: 15),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appText(
                                                    context: context,
                                                    title: 'Last Sale',
                                                    fontSize: 15),
                                                appText(
                                                    context: context,
                                                    title: 'PKR: ' +
                                                        "${item.lastSale ?? ''}",
                                                    fontSize: 15),
                                              ],
                                            ),
                                            context.heightBox(0.01),
                                            appText(
                                                context: context,
                                                title: 'Description'),
                                            appText(
                                                textAlign: TextAlign.left,
                                                context: context,
                                                title: "${item.desc ?? ''}",
                                                fontSize: 15),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
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
