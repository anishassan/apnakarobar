import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
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
  late SalesProvider _salesProvider;
  late PurchaseProvider _purchaseProvider;
  List<SalesModel> _salesList = [];
  @override
  void initState() {
    _salesProvider = Provider.of<SalesProvider>(context, listen: false);
    _purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    // TODO: implement initState
    if (widget.type == 0 || widget.type == 2) {
      Future.delayed(const Duration(seconds: 1), () {
        _salesProvider.getSales();
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            _salesList.addAll(_salesProvider.salesList);
          });
          final pv = Provider.of<ReportProvider>(context, listen: false);
          pv.filterAndCalculate(_salesProvider.salesList, pv.selectedFilter,
              customStartDate: pv.fromDate, customEndDate: pv.toDate);
        });
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        _purchaseProvider.getPurchase();
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            _salesList.addAll(_purchaseProvider.salesList);
          });
          final pv = Provider.of<ReportProvider>(context, listen: false);
          pv.filterAndCalculate(_salesProvider.salesList, pv.selectedFilter,
              customStartDate: pv.fromDate, customEndDate: pv.toDate);
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _salesList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(builder: (context, provider, __) {
      return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
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
            : widget.type == 2
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
                                    title: 'Customers',
                                    fontSize: 14,
                                    textColor: ColorPalette.white,
                                  ),
                                  appText(
                                      fontSize: 14,
                                      textColor: ColorPalette.white,
                                      context: context,
                                      title: _salesProvider.customerList.length
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
                                      title: provider.getRemainingBalance(
                                          _salesProvider.customerList)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: _salesProvider.customerList.length,
                            itemBuilder: (context, index) {
                              final user = _salesProvider.customerList[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: ColorPalette.black.withOpacity(0.35),
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
                                          title: user.name![0].toUpperCase()),
                                    ),
                                    context.widthBox(0.01),
                                    Column(
                                      children: [
                                        appText(
                                          context: context,
                                          title: user.name![0].toUpperCase() +
                                                  user.name!.substring(1) ??
                                              '',
                                          textColor: ColorPalette.white,
                                        ),
                                        appText(
                                            textColor: ColorPalette.white,
                                            fontSize: 10,
                                            context: context,
                                            title: user.remainigBalance == '' ||
                                                    user.remainigBalance!
                                                        .isEmpty
                                                ? 'paid'
                                                : 'unpaid')
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Icon(Icons.call,
                                            color: ColorPalette.white),
                                        appText(
                                            context: context,
                                            textColor: ColorPalette.white,
                                            title:
                                                'PKR ${user.remainigBalance ?? '0.0'}')
                                      ],
                                    )
                                  ],
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
                                if (provider.selectedFilter == 'Custom Date') {
                                  DateTime? d = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1990),
                                      lastDate: DateTime.now());
                                  if (d != null) {
                                    provider.filterAndCalculate(
                                        _salesList, provider.selectedFilter,
                                        customEndDate: provider.toDate,
                                        customStartDate:
                                            DateFormat('dd-MM-yyyy').format(d));
                                    provider.pickFromAndToDate(
                                        date:
                                            DateFormat('dd-MM-yyyy').format(d));
                                  }
                                }
                              },
                              child: Container(
                                width: context.getSize.width * 0.28,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: ColorPalette.white,
                                    border:
                                        Border.all(color: ColorPalette.green)),
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
                                if (provider.selectedFilter == 'Custom Date') {
                                  DateTime? d = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1990),
                                      lastDate: DateTime.now());
                                  if (d != null) {
                                    provider.filterAndCalculate(
                                        _salesList, provider.selectedFilter,
                                        customStartDate: provider.fromDate,
                                        customEndDate:
                                            DateFormat('dd-MM-yyyy').format(d));
                                    provider.pickFromAndToDate(
                                        isFromDate: false,
                                        date:
                                            DateFormat('dd-MM-yyyy').format(d));
                                  }
                                }
                              },
                              child: Container(
                                width: context.getSize.width * 0.28,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: ColorPalette.white,
                                    border:
                                        Border.all(color: ColorPalette.green)),
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
                                    title:
                                        widget.type == 0 ? 'Sale' : 'Purchase',
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
                                      provider.selectedFilter != 'Custom Date'
                                  ? _salesList.length
                                  : provider.filteredDataList.length,
                              itemBuilder: (context, index) {
                                final data = provider
                                            .filteredDataList.isEmpty &&
                                        provider.selectedFilter != 'Custom Date'
                                    ? _salesList[index]
                                    : provider.filteredDataList[index];
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
                                                                .split('-')[0]),
                                                            int.parse(data
                                                                    .soldDate
                                                                    .split('-')[
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
                                      children: List.generate(data.data.length,
                                          (index2) {
                                        final data2 = data.data[index2];
                                        return Container(
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
                                                        title:
                                                            data2.name ?? '')),
                                              ),
                                              Expanded(
                                                child: Center(
                                                    child: appText(
                                                        fontSize: 14,
                                                        context: context,
                                                        title: provider
                                                            .calculateSingleUserSalePurchase(
                                                                data2.soldProducts ??
                                                                    []))),
                                              ),
                                              Expanded(
                                                child: Center(
                                                    child: appText(
                                                        fontSize: 14,
                                                        context: context,
                                                        title:
                                                            data2.paidBalance ??
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
                                  child: appText(
                                      fontSize: 12,
                                      context: context,
                                      title:
                                          'Total Sales &\nPayment Recieved')),
                            ),
                            Expanded(
                              child: Center(
                                  child: appText(
                                      fontSize: 14,
                                      context: context,
                                      title: provider.totalSales)),
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
      );
    });
  }
}
