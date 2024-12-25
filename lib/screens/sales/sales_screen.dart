import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/constant/color.dart';

import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/gen/assets.gen.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/provider/sales_provider.dart';
import 'package:sales_management/utils/popup_menu.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/text_button.dart';
import 'package:sales_management/utils/text_field.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    Provider.of<SalesProvider>(context, listen: false).getSales();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  popupMenu(
                      context: context,
                      dataList: ['Paid', 'Unpaid'],
                      onSelect: (val) {
                        provider.changeType(val);
                      },
                      selectedItem: provider.selectedType),
                  context.widthBox(0.01),
                  Expanded(
                      child: textField(
                          context: context,
                          controller: TextEditingController(),
                          hintText: 'Search',
                          suffixIcon: GestureDetector(
                            child: Icon(Icons.search),
                          ))),
                ],
              ),
              context.heightBox(0.01),
              Row(
                children: [
                  SizedBox(
                    width: context.getSize.width * 0.26,
                    child: popupMenu(
                        context: context,
                        dataList: provider.daysType,
                        selectedItem: provider.selectedDay,
                        onSelect: (val) {
                          provider.changeDay(val);
                        }),
                  ),
                  context.widthBox(Platform.isAndroid ? 0.005 : 0.002),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          provider.decrementYear();
                        },
                        child: Icon(
                          Icons.arrow_left,
                          size: context.getSize.height * 0.05,
                          color: ColorPalette.green,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.getSize.width * 0.1,
                            vertical: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorPalette.green)),
                        child: appText(
                            textColor: ColorPalette.green,
                            context: context,
                            title: 'PY-${provider.selectedYear}',
                            fontSize: 17),
                      ),
                      GestureDetector(
                        onTap: () {
                          provider.incrementYear();
                        },
                        child: Icon(
                          Icons.arrow_right,
                          size: context.getSize.height * 0.05,
                          color: ColorPalette.green,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              context.heightBox(0.01),
              Expanded(
                child: SingleChildScrollView(
                  controller: provider.scrollController,
                  child: Column(
                    children: List.generate(provider.salesList.length, (index) {
                      SalesModel model = provider.salesList[index];
                      // List<Datum> data =
                      //     provider.mergeCustomers(provider.salesList);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: ColorPalette.green,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  appText(
                                      textColor: ColorPalette.white,
                                      context: context,
                                      title: DateFormat('MMMM yyyy').format(
                                          DateTime(
                                              int.parse(model.soldDate!
                                                  .split('-')[0]),
                                              int.parse(model.soldDate!
                                                  .split('-')[1]))),
                                      fontSize: 16),
                                  // appText(
                                  //     textColor: ColorPalette.white,
                                  //     context: context,
                                  //     title: 'PKR: ${model.remainingBalance}',
                                  // fontSize: 16)
                                ],
                              ),
                            ),
                            context.heightBox(0.005),
                            Column(
                                children:
                                    List.generate(model.data.length, (index3) {
                              final model2 = model.data[index3];
                              String q = provider.calculateProductMetrics(
                                  model2.soldProducts ?? [], 'quantity');
                              String total = provider.calculateProductMetrics(
                                  model2.soldProducts ?? [], 'totalprice');
                              List<String> dateList = model.soldDate.split('-');
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.detail,
                                        arguments: [model2, 1, model2.name]);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          appText(
                                              context: context,
                                              title: DateFormat('MMM\nd')
                                                  .format(DateTime(
                                                      int.parse(dateList[0]),
                                                      int.parse(dateList[1]),
                                                      int.parse(dateList[2]))),
                                              fontSize: 16),
                                          context.widthBox(0.005),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              appText(
                                                  context: context,
                                                  title: model2.name ?? '',
                                                  fontSize: 16),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  appText(
                                                      context: context,
                                                      title: 'INV' ?? '',
                                                      fontSize: 10),
                                                  context.widthBox(0.01),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                      color: double.parse(model2
                                                                      .remainigBalance ??
                                                                  '0.0') !=
                                                              0.0
                                                          ? Colors.amber
                                                          : ColorPalette.green,
                                                    )),
                                                    child: appText(
                                                        textColor: double.parse(
                                                                    model2.remainigBalance ??
                                                                        '0.0') !=
                                                                0.0
                                                            ? Colors.amber
                                                            : ColorPalette
                                                                .green,
                                                        context: context,
                                                        title: double.parse(model2
                                                                        .remainigBalance ??
                                                                    '0.0') !=
                                                                0.0
                                                            ? 'Partially Recieved'
                                                            : 'Recieved',
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      appText(
                                          context: context,
                                          title: 'PKR: ${total}',
                                          fontSize: 16)
                                    ],
                                  ),
                                ),
                              );
                            }))
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
                    Navigator.pushNamed(context, Routes.addItem, arguments: 1);
                  },
                  title: 'Add New Sales',
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
