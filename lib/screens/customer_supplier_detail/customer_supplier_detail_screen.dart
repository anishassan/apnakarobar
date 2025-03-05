import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/models/report_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/provider/report_provider.dart';
import 'package:sales_management/utils/app_text.dart';

class CustomerSupplierDetailScreen extends StatefulWidget {
  final int type;
  final int ind;
  const CustomerSupplierDetailScreen(
      {super.key, required this.type, required this.ind});

  @override
  State<CustomerSupplierDetailScreen> createState() =>
      _CustomerSupplierDetailScreenState();
}

class _CustomerSupplierDetailScreenState
    extends State<CustomerSupplierDetailScreen> {
  @override
  void initState() {
    if (widget.type == 2) {
      Provider.of<ReportProvider>(context, listen: false).getSales();
    } else {
      Provider.of<ReportProvider>(context, listen: false).getPurchase();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(builder: (context, provider, __) {
      return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.keyboard_arrow_left,
                color: ColorPalette.white,
                size: 30,
              ),
            ),
            title: appText(
                context: context,
                title: widget.type == 2
                    ? (provider.customerReport[widget.ind].name ?? '')
                    : (provider.supplierReport[widget.ind].name ?? ''),
                textColor: ColorPalette.white),
            backgroundColor: ColorPalette.green,
          ),
          body: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: ColorPalette.green.withOpacity(0.3),
                    border:
                        Border(bottom: BorderSide(color: ColorPalette.black))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appText(
                      context: context,
                      title: 'Opening',
                      fontSize: 15,
                    ),
                    appText(
                      context: context,
                      title: 'PKR: 0.0',
                      fontSize: 15,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: ColorPalette.green.withOpacity(0.3),
                    border:
                        Border(bottom: BorderSide(color: ColorPalette.black))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: context.getSize.width * 0.2,
                        child: appText(
                          textAlign: TextAlign.center,
                          context: context,
                          title: 'Particular',
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: context.getSize.width * 0.2,
                        child: appText(
                          textAlign: TextAlign.center,
                          context: context,
                          title: widget.type == 2 ? 'Sales' : 'Purchase',
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: context.getSize.width * 0.2,
                        child: appText(
                          textAlign: TextAlign.center,
                          context: context,
                          title: 'Payment',
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: context.getSize.width * 0.2,
                        child: appText(
                          textAlign: TextAlign.center,
                          context: context,
                          title: 'Balance',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                        widget.type == 2
                            ? provider.customerReport[widget.ind].data!.length
                            : provider.supplierReport[widget.ind].data!.length,
                        (index) {
                      final model = widget.type == 2
                          ? provider.customerReport[widget.ind].data![index]
                          : provider.supplierReport[widget.ind].data![index];

                      return model.paidBalance == '0.0' &&
                              model.remainingBalance == '0.0' &&
                              model.sales == '0.0'
                          //  provider.getSingleRemainingBalance(
                          //                 model.data, data.customerId ?? 0) ==
                          //             '0.0' &&
                          //         provider.calculateSingleTotalPayment(
                          //                 model.data, data.customerId ?? 0) ==
                          //             '0.0' &&
                          //         provider.calculatesingleTotalLastSale(
                          //                 model.data, data.customerId ?? 0) ==
                          //             '0.0'
                          ? const SizedBox.shrink()
                          : GestureDetector(
                              onTap: () {
                                Datum m = Datum.fromJson({});

                                String soldDate = '';
                                if (widget.type == 2) {
                                  for (var v in provider.salesList) {
                                    if (v.soldDate == model.soldDate) {
                                      for (var x in v.data) {
                                        if (x.name ==
                                                provider
                                                    .customerReport[widget.ind]
                                                    .name &&
                                            x.customerId ==
                                                provider
                                                    .customerReport[widget.ind]
                                                    .id &&
                                            x.contact ==
                                                provider
                                                    .customerReport[widget.ind]
                                                    .contact) {
                                          m = x;
                                          soldDate = model.soldDate ?? '';
                                          break;
                                        }
                                      }
                                    }
                                  }
                                } else {
                                  for (var v in provider.salesList) {
                                    if (v.soldDate == model.soldDate) {
                                      for (var x in v.data) {
                                        if (x.name ==
                                                provider
                                                    .supplierReport[widget.ind]
                                                    .name &&
                                            x.customerId ==
                                                provider
                                                    .supplierReport[widget.ind]
                                                    .id &&
                                            x.contact ==
                                                provider
                                                    .supplierReport[widget.ind]
                                                    .contact) {
                                          m = x;
                                          soldDate = model.soldDate ?? '';
                                          break;
                                        }
                                      }
                                    }
                                  }
                                }

                                print(soldDate);
                                // // print(
                                // //     "Product Data Length ${model.data.soldProducts!.length}");
                                Navigator.pushNamed(context, Routes.detail,
                                    arguments: [
                                      m,
                                      widget.type == 2 ? true : false,
                                      widget.type == 2
                                          ? (provider.customerReport[widget.ind]
                                                  .name ??
                                              '')
                                          : (provider.supplierReport[widget.ind]
                                                  .name ??
                                              ''),
                                      soldDate,
                                    ]);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: ColorPalette.black
                                                      .withOpacity(0.2)))),
                                      width: context.getSize.width * 0.2,
                                      height: context.getSize.height * 0.05,
                                      child: appText(
                                        textAlign: TextAlign.center,
                                        context: context,
                                        title: DateFormat('dd MMM yyyy').format(
                                            DateTime.parse(model.date!)),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: context.getSize.width * 0.2,
                                      height: context.getSize.height * 0.05,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                color: ColorPalette.black
                                                    .withOpacity(0.2),
                                              ),
                                              left: BorderSide(
                                                color: ColorPalette.black
                                                    .withOpacity(0.2),
                                              ))),
                                      child: appText(
                                        textAlign: TextAlign.center,
                                        context: context,
                                        title: model.sales == '0.0'
                                            ? ''
                                            : double.parse(model.sales ?? '0.0')
                                                    .toStringAsFixed(2) ??
                                                '',
                                        // provider.calculatesingleTotalLastSale(
                                        //             model.data,
                                        //             data.customerId ?? 0) ==
                                        //         '0.0'
                                        //     ? ''
                                        //     : provider
                                        //         .calculatesingleTotalLastSale(
                                        //             model.data,
                                        //             data.customerId ?? 0),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: context.getSize.width * 0.2,
                                      height: context.getSize.height * 0.05,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: ColorPalette.black
                                                .withOpacity(0.2),
                                          ),
                                          right: BorderSide(
                                            color: ColorPalette.black
                                                .withOpacity(0.2),
                                          ),
                                          left: BorderSide(
                                            color: ColorPalette.black
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      child: appText(
                                        textAlign: TextAlign.center,
                                        context: context,
                                        title: model.paidBalance == '0.0'
                                            ? ''
                                            : model.paidBalance ?? '',
                                        // provider.calculateSingleTotalPayment(
                                        //             model.data,
                                        //             data.customerId ?? 0) ==
                                        //         '0.0'
                                        //     ? ''
                                        //     : provider
                                        //         .calculateSingleTotalPayment(
                                        //             model.data,
                                        //             data.customerId ?? 0),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    width: context.getSize.width * 0.2,
                                    height: context.getSize.height * 0.05,
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(
                                        color:
                                            ColorPalette.black.withOpacity(0.2),
                                      ),
                                    )),
                                    child: appText(
                                      textAlign: TextAlign.center,
                                      context: context,
                                      title: model.remainingBalance == '0.0'
                                          ? ''
                                          : model.remainingBalance ?? '',
                                      //  provider.getSingleRemainingBalance(
                                      //             model.data,
                                      //             data.customerId ?? 0) ==
                                      //         '0.0'
                                      //     ? ''
                                      //     : provider.getSingleRemainingBalance(
                                      //         model.data, data.customerId ?? 0),
                                      fontSize: 13,
                                    ),
                                  )),
                                ],
                              ),
                            );
                    }),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ColorPalette.black)),
                  color: ColorPalette.green.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appText(
                          fontSize: 16,
                          context: context,
                          title: widget.type == 2 ? 'Sales' : 'Purchase',
                        ),
                        appText(
                            fontSize: 16,
                            context: context,
                            title: 'PKR: ' +
                                provider.customerSupplierTotalSales(
                                    widget.type == 2
                                        ? (provider.customerReport[widget.ind]
                                                .data ??
                                            [])
                                        : (provider.supplierReport[widget.ind]
                                                .data ??
                                            []))),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        appText(
                          fontSize: 16,
                          context: context,
                          title: 'Payment',
                        ),
                        appText(
                            fontSize: 16,
                            context: context,
                            title: 'PKR: ' +
                                provider.customerSupplierTotalPayment(
                                  widget.type == 2
                                      ? (provider.customerReport[widget.ind]
                                              .data ??
                                          [])
                                      : (provider.supplierReport[widget.ind]
                                              .data ??
                                          []),
                                ))
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: const BoxDecoration(color: ColorPalette.green),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appText(
                        context: context,
                        title: 'Total Balance',
                        fontSize: 16,
                        textColor: ColorPalette.white),
                    appText(
                        context: context,
                        title: 'PKR: ' +
                            provider.customerSupplierRemainingBalance(widget
                                        .type ==
                                    2
                                ? (provider.customerReport[widget.ind].data ??
                                    [])
                                : (provider.supplierReport[widget.ind].data ??
                                    [])),
                        fontSize: 16,
                        textColor: ColorPalette.white)
                  ],
                ),
              )
            ],
          ));
    });
  }
}
