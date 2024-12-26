import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/provider/report_provider.dart';
import 'package:sales_management/utils/app_text.dart';

class CustomerSupplierDetailScreen extends StatelessWidget {
  final int type;
  final Datum data;
  const CustomerSupplierDetailScreen(
      {super.key, required this.type, required this.data});

  @override
  Widget build(BuildContext context) {
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
            title: data.name ?? '',
            textColor: ColorPalette.white),
        backgroundColor: ColorPalette.green,
      ),
      body: Consumer<ReportProvider>(builder: (context, provider, __) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        title: 'Sales',
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
                  children: List.generate(provider.salesList.length, (index) {
                    final model = provider.salesList[index];

                    return provider.getSingleRemainingBalance(
                                    model.data, data.customerId ?? 0) ==
                                '0.0' &&
                            provider.calculateSingleTotalPayment(
                                    model.data, data.customerId ?? 0) ==
                                '0.0' &&
                            provider.calculatesingleTotalLastSale(
                                    model.data, data.customerId ?? 0) ==
                                '0.0'
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        DateTime(
                                            int.parse(
                                                model.soldDate.split('-')[0]),
                                            int.parse(
                                                model.soldDate.split('-')[1]),
                                            int.parse(
                                                model.soldDate.split('-')[2]))),
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
                                    title: provider
                                                .calculatesingleTotalLastSale(
                                                    model.data,
                                                    data.customerId ?? 0) ==
                                            '0.0'
                                        ? ''
                                        : provider.calculatesingleTotalLastSale(
                                            model.data, data.customerId ?? 0),
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
                                      right: BorderSide(
                                        color:
                                            ColorPalette.black.withOpacity(0.2),
                                      ),
                                      left: BorderSide(
                                        color:
                                            ColorPalette.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                  child: appText(
                                    textAlign: TextAlign.center,
                                    context: context,
                                    title: provider.calculateSingleTotalPayment(
                                                model.data,
                                                data.customerId ?? 0) ==
                                            '0.0'
                                        ? ''
                                        : provider.calculateSingleTotalPayment(
                                            model.data, data.customerId ?? 0),
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
                                    color: ColorPalette.black.withOpacity(0.2),
                                  ),
                                )),
                                child: appText(
                                  textAlign: TextAlign.center,
                                  context: context,
                                  title: provider.getSingleRemainingBalance(
                                              model.data,
                                              data.customerId ?? 0) ==
                                          '0.0'
                                      ? ''
                                      : provider.getSingleRemainingBalance(
                                          model.data, data.customerId ?? 0),
                                  fontSize: 13,
                                ),
                              )),
                            ],
                          );
                  }),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        title: 'Sales',
                      ),
                      appText(
                          fontSize: 16,
                          context: context,
                          title: 'PKR: ' +
                              provider.customerSupplierTotalSales(
                                  provider.salesList, data.customerId ?? 0)),
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
                                  provider.salesList, data.customerId ?? 0)),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          provider.customerSupplierRemainingBalance(
                              provider.salesList, data.customerId ?? 0),
                      fontSize: 16,
                      textColor: ColorPalette.white)
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
