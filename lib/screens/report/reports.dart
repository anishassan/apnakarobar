import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/provider/purchase_provider.dart';
import 'package:sales_management/provider/report_provider.dart';
import 'package:sales_management/provider/sales_provider.dart';
import 'package:sales_management/screens/report/inventory_report.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/box_shadow.dart';
import 'package:sales_management/utils/popup_menu.dart';
import 'package:sales_management/utils/text_field.dart';

class Reports extends StatefulWidget {
  final String title;
  final int type;
  const Reports({super.key, required this.title, required this.type});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  late ReportProvider _reportProvider;

  List<SalesModel> _salesList = [];
  @override
  void initState() {
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    print("TYPE ${widget.type}");

    fetchData();
    super.initState();
  }

  fetchData() async {
    _salesList.clear();

    await fetch();
    _salesList.addAll(_reportProvider.salesList);
    Future.delayed(const Duration(milliseconds: 300));
    _reportProvider.changeFilter(
      _reportProvider.selectedFilter,
      _reportProvider.salesList,
    );
    setState(() {});
  }

  fetch() async {
    switch (widget.type) {
      case 0:
        return await _reportProvider.getSales();

      case 2:
        return await _reportProvider.getCustomer();

      case 1:
        return await _reportProvider.getPurchase();

      case 3:
        return await _reportProvider.getSuppler();
    }
  }

  @override
  void dispose() {
    _salesList.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(builder: (context, provider, __) {
      return PopScope(
        canPop: false,
        onPopInvoked: (val) {
          if (val == false) {
            _salesList.clear();
            provider.clearData();
            Navigator.pushReplacementNamed(
              context,
              Routes.dashboard,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                _salesList.clear();
                provider.clearData();
                Navigator.pushReplacementNamed(
                  context,
                  Routes.dashboard,
                );
              },
              child: const Icon(
                Icons.keyboard_arrow_left,
                color: ColorPalette.white,
                size: 30,
              ),
            ),
            backgroundColor: ColorPalette.green,
            title: appText(
                context: context,
                title: widget.title,
                textColor: ColorPalette.white),
          ),
          body: widget.type == 4
              ? InventoryReport()
              : widget.type == 2 || widget.type == 3
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          textField(
                              context: context,
                              controller: provider.search,
                              hintText: 'Search',
                              prefixIcon: GestureDetector(
                                child: Icon(Icons.search),
                              )),
                          context.heightBox(0.01),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                                color: ColorPalette.green,
                                boxShadow: [boxShadow(context: context)],
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    appText(
                                      context: context,
                                      title: widget.type == 3
                                          ? 'Suppliers'
                                          : 'Customers',
                                      fontSize: 14,
                                      textColor: ColorPalette.white,
                                    ),
                                    appText(
                                        fontSize: 14,
                                        textColor: ColorPalette.white,
                                        context: context,
                                        title: widget.type == 3
                                            ? provider.supplierReport.length
                                                .toString()
                                            : provider.customerReport.length
                                                .toString()),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    appText(
                                      context: context,
                                      title: 'Outstanding Balance',
                                      fontSize: 14,
                                      textColor: ColorPalette.white,
                                    ),
                                    appText(
                                        fontSize: 14,
                                        textColor: ColorPalette.white,
                                        context: context,
                                        title: widget.type == 3
                                            ? provider.getRemainingBalance(
                                                provider.supplierReport)
                                            : provider.getRemainingBalance(
                                                provider.customerReport)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.type == 3
                                  ? provider.supplierReport.length
                                  : provider.customerReport.length,
                              itemBuilder: (context, index) {
                                final user = widget.type == 3
                                    ? provider.supplierReport[index]
                                    : provider.customerReport[index];
                                return GestureDetector(
                                  onTap: () {
                                    if (widget.type == 3) {
                                      Navigator.pushNamed(context,
                                          Routes.customersupplierdetail,
                                          arguments: [1, index]);
                                    } else {
                                      Navigator.pushNamed(context,
                                          Routes.customersupplierdetail,
                                          arguments: [2, index]);
                                    }
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color:
                                          ColorPalette.black.withOpacity(0.35),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorPalette.green,
                                          ),
                                          child: appText(
                                              context: context,
                                              textColor: ColorPalette.white,
                                              title:
                                                  user.name![0].toUpperCase()),
                                        ),
                                        context.widthBox(0.01),
                                        Column(
                                          children: [
                                            appText(
                                              context: context,
                                              title: user.name![0]
                                                          .toUpperCase() +
                                                      user.name!.substring(1) ??
                                                  '',
                                              textColor: ColorPalette.white,
                                            ),
                                            appText(
                                                textColor: ColorPalette.white,
                                                fontSize: 10,
                                                context: context,
                                                title:
                                                    provider.customerSupplierRemainingBalance(
                                                                user.data ??
                                                                    []) ==
                                                            '0.0'
                                                        ? 'Paid'
                                                        : 'Unpaid')
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    provider.makePhoneCall(
                                                        user.contact ?? '');
                                                  },
                                                  child: const Icon(Icons.call,
                                                      color:
                                                          ColorPalette.white),
                                                ),
                                                context.widthBox(0.01),
                                                if (widget.type == 2)
                                                  GestureDetector(
                                                    onTap: () {
                                                      provider.sendSMS(
                                                          user.contact ?? '',
                                                          'محترم ${user.name}، امید ہے آپ خیریت سے ہونگے۔ آپ کے ذمہ (${provider.customerSupplierRemainingBalance(user.data ?? [])}) کی رقم بقایا جات ہیں۔ برائے مہربانی جلد از جلد ادائیگی کر دیں۔ شکریہ۔منجانب (ApnaKarobar)');
                                                    },
                                                    child: const Icon(
                                                        Icons.message,
                                                        color:
                                                            ColorPalette.white),
                                                  ),
                                              ],
                                            ),
                                            appText(
                                              context: context,
                                              textColor: ColorPalette.white,
                                              title: provider
                                                  .customerSupplierRemainingBalance(
                                                      user.data ?? []),
                                              // 'PKR ${user.remainigBalance ?? '0.0'}'
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        context.heightBox(0.01),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  child: reportPopupMenu(
                                      context: context,
                                      dataList: provider.filterList,
                                      selectedItem: provider.selectedFilter,
                                      onSelect: (val) {
                                        provider.changeFilter(val, _salesList);
                                      })),
                              context.widthBox(0.01),
                              GestureDetector(
                                onTap: () async {
                                  if (provider.selectedFilter ==
                                      'Custom Date') {
                                    DateTime? d = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1990),
                                        lastDate: DateTime.now());
                                    if (d != null) {
                                      provider.filterAndCalculate(
                                          _salesList, provider.selectedFilter,
                                          customEndDate: provider.toDate,
                                          customStartDate:
                                              DateFormat('yyyy-MM-dd')
                                                  .format(d));
                                      provider.pickFromAndToDate(
                                          date: DateFormat('yyyy-MM-dd')
                                              .format(d));
                                    }
                                  }
                                },
                                child: Container(
                                  width: context.getSize.width * 0.28,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: ColorPalette.white,
                                      border: Border.all(
                                          color: ColorPalette.green)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_month,
                                          size: 15, color: ColorPalette.green),
                                      context.widthBox(0.01),
                                      appText(
                                          context: context,
                                          title: provider.fromDate == ''
                                              ? 'From Date'
                                              : provider.fromDate,
                                          fontSize: 12,
                                          textColor: ColorPalette.green)
                                    ],
                                  ),
                                ),
                              ),
                              context.widthBox(0.01),
                              GestureDetector(
                                onTap: () async {
                                  if (provider.selectedFilter ==
                                      'Custom Date') {
                                    DateTime? d = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1990),
                                        lastDate: DateTime.now());
                                    if (d != null) {
                                      provider.filterAndCalculate(
                                          _salesList, provider.selectedFilter,
                                          customStartDate: provider.fromDate,
                                          customEndDate:
                                              DateFormat('yyyy-MM-dd')
                                                  .format(d));
                                      provider.pickFromAndToDate(
                                          isFromDate: false,
                                          date: DateFormat('yyyy-MM-dd')
                                              .format(d));
                                    }
                                  }
                                },
                                child: Container(
                                  width: context.getSize.width * 0.28,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: ColorPalette.white,
                                      border: Border.all(
                                          color: ColorPalette.green)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_month,
                                          size: 15, color: ColorPalette.green),
                                      context.widthBox(0.01),
                                      appText(
                                          context: context,
                                          title: provider.toDate == ''
                                              ? 'To Date'
                                              : provider.toDate,
                                          fontSize: 12,
                                          textColor: ColorPalette.green)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        context.heightBox(0.01),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: ColorPalette.green,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: popupMenu(
                                      context: context,
                                      dataList: provider.scndFilterList,
                                      selectedItem: provider.scndSelectedFilter,
                                      onSelect: (val) {
                                        provider.changeScndSelectedFilter(val);
                                      })),
                              Expanded(
                                child: Center(
                                  child: appText(
                                      context: context,
                                      title: widget.type == 0
                                          ? 'Sale'
                                          : 'Purchase',
                                      fontSize: 14,
                                      textColor: ColorPalette.white),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: appText(
                                      context: context,
                                      title: 'Payment',
                                      fontSize: 14,
                                      textColor: ColorPalette.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: provider.filteredDataList.isEmpty &&
                                        provider.selectedFilter == 'All Time'
                                    ? _salesList.length
                                    : provider.filteredDataList.length,
                                itemBuilder: (context, index) {
                                  final data = provider
                                              .filteredDataList.isEmpty &&
                                          provider.selectedFilter == 'All Time'
                                      ? _salesList[index]
                                      : provider.filteredDataList[index];
                                  List<Datum> cssp = data.data;
                                  // provider.secondFilterData(
                                  // data.data, provider.scndSelectedFilter);
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: ColorPalette.green
                                                .withOpacity(0.3)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                  child: appText(
                                                      fontSize: 14,
                                                      context: context,
                                                      title: DateFormat(
                                                              'MMM yyyy')
                                                          .format(DateTime(
                                                              int.parse(data
                                                                  .soldDate
                                                                  .split(
                                                                      '-')[0]),
                                                              int.parse(data
                                                                      .soldDate
                                                                      .split(
                                                                          '-')[
                                                                  1]))))),
                                            ),
                                            Expanded(
                                              child: Center(
                                                  child: appText(
                                                      fontSize: 14,
                                                      context: context,
                                                      title: provider
                                                          .calculateTotalLastSale(
                                                              data.data))),
                                            ),
                                            Expanded(
                                              child: Center(
                                                  child: appText(
                                                      fontSize: 14,
                                                      context: context,
                                                      title: provider
                                                          .calculateTotalPayment(
                                                              data.data))),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: List.generate(cssp.length,
                                            (index2) {
                                          final data2 = cssp[index2];

                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                      child: appText(
                                                          fontSize: 14,
                                                          context: context,
                                                          title: data2.name ??
                                                              '')),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                      child: appText(
                                                          fontSize: 14,
                                                          context: context,
                                                          title: provider
                                                              .calculateSingleUserSalePurchase(
                                                                  data2))),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                      child: appText(
                                                          fontSize: 14,
                                                          context: context,
                                                          title: data2
                                                                  .paidBalance ??
                                                              '0.0')),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                      )
                                    ],
                                  );
                                })),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: ColorPalette.green))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                    child: widget.type == 1
                                        ? appText(
                                            fontSize: 12,
                                            context: context,
                                            maxLine: 2,
                                            title: 'tppr')
                                        : appText(
                                            fontSize: 12,
                                            context: context,
                                            maxLine: 2,
                                            title: 'tspr')),
                              ),
                              Expanded(
                                child: Center(
                                    child: appText(
                                  fontSize: 14,
                                  context: context,
                                  title: provider.totalSales,
                                )),
                              ),
                              Expanded(
                                child: Center(
                                    child: appText(
                                        fontSize: 14,
                                        context: context,
                                        title: provider.totalPaidBalance)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
        ),
      );
    });
  }
}
