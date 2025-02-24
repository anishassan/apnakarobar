import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/provider/detail_provider.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/box_shadow.dart';
import 'package:sales_management/utils/custom_dropdown_date_picker.dart';
import 'package:sales_management/utils/text_button.dart';
import 'package:sales_management/utils/text_field.dart';
import 'package:sales_management/utils/toast.dart';

class DetailScreen extends StatelessWidget {
  final Datum model;
  final String soldDate;

  final bool isSale;
  const DetailScreen(
      {super.key,
      required this.model,
      required this.soldDate,
      required this.isSale});

  @override
  Widget build(BuildContext context) {
    double grandTotal = model.soldProducts!.fold(0.0, (sum, product) {
      // Parse product price and quantity as needed
      double price = double.parse(product.productprice ?? '0.0');
      int quantity = int.parse(product.buySaleQuantity ?? '0');

      // Multiply price and quantity, and add to the accumulator
      return sum + (price * quantity);
    });
    return Scaffold(
        body: Consumer<DetailProvider>(builder: (context, provider, __) {
      return PopScope(
        canPop: true,
        onPopInvoked: (v) {
          provider.remainingBalance.clear();
          provider.changeRemaining('');
        },
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: context.getSize.width * 0.4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: ColorPalette.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.personal_injury,
                            color: ColorPalette.white,
                          ),
                          context.widthBox(0.01),
                          SizedBox(
                            height: context.getSize.height * 0.03,
                            width: context.getSize.width * 0.25,
                            child: FittedBox(
                              child: appText(
                                  context: context,
                                  title: model.name ?? '',
                                  textColor: ColorPalette.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    context.widthBox(0.01),
                    Expanded(
                        child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: ColorPalette.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined,
                                  color: ColorPalette.white),
                              context.widthBox(0.01),
                              appText(
                                  context: context,
                                  fontSize: 10,
                                  title: 'Date:',
                                  textColor: ColorPalette.white),
                            ],
                          ),
                        ),
                        context.widthBox(0.01),
                        CustomDateTimePicker(
                          onPress: (val) {
                            provider.changeDate(val);
                          },
                        )
                      ],
                    ))
                  ],
                ),
                context.heightBox(0.01),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration:
                      BoxDecoration(color: ColorPalette.white, boxShadow: [
                    boxShadow(
                        context: context,
                        y: 5,
                        blur: 5,
                        color: ColorPalette.black,
                        opacity: 0.3)
                  ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      appText(context: context, title: 'Contact No:'),
                      appText(
                          context: context,
                          title: '0' + "${model.contact ?? ''}"),
                    ],
                  ),
                ),
                context.heightBox(0.01),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        return ColorPalette.green; // Default row color
                      },
                    ),
                    dataRowHeight: context.getSize.height * 0.05,
                    columns: [
                      DataColumn(
                          label: appText(
                              textAlign: TextAlign.left,
                              fontSize: 14,
                              textColor: ColorPalette.white,
                              context: context,
                              title: 'Product Title')),
                      DataColumn(
                          label: appText(
                              textColor: ColorPalette.white,
                              textAlign: TextAlign.left,
                              fontSize: 14,
                              context: context,
                              title: 'Quantity')),
                      DataColumn(
                          label: appText(
                              textAlign: TextAlign.center,
                              fontSize: 14,
                              textColor: ColorPalette.white,
                              context: context,
                              title: 'Price')),
                      DataColumn(
                          label: appText(
                              textColor: ColorPalette.white,
                              textAlign: TextAlign.center,
                              fontSize: 14,
                              context: context,
                              title: 'Total')),
                    ],
                    rows: model.soldProducts!.map((item) {
                      return DataRow(cells: [
                        DataCell(Align(
                            alignment: Alignment.centerLeft,
                            child: appText(
                                context: context,
                                title: item.title ?? '',
                                fontSize: 14))),
                        DataCell(
                          Center(
                              child: appText(
                                  textAlign: TextAlign.center,
                                  context: context,
                                  title: item.buySaleQuantity == '0' ||
                                          item.buySaleQuantity == ''
                                      ? ''
                                      : item.buySaleQuantity ?? "",
                                  fontSize: 14)),
                        ),
                        DataCell(
                          Center(
                              child: appText(
                                  textAlign: TextAlign.center,
                                  context: context,
                                  title: item.productprice == ""
                                      ? '0.00'
                                      : double.parse(item.productprice ?? '0.0')
                                          .toStringAsFixed(2),
                                  fontSize: 14)),
                        ),
                        DataCell(
                          Center(
                              child: appText(
                                  textAlign: TextAlign.center,
                                  context: context,
                                  title: (double.parse(
                                              item.productprice ?? '0.0') *
                                          int.parse(
                                              item.buySaleQuantity ?? '0'))
                                      .toStringAsFixed(2),
                                  fontSize: 14)),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
                context.heightBox(0.01),
                if (model.discount != '' || model.discount != '0.0')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      appText(
                          context: context,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          title: 'Discount',
                          textColor: ColorPalette.green),
                      appText(
                          context: context,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          title: double.parse(model.discount ?? '0.0')
                              .toStringAsFixed(2),
                          textColor: ColorPalette.green),
                    ],
                  ),
                if (model.discount != '' || model.discount != '0.0')
                  Container(
                    decoration: const BoxDecoration(
                      color: ColorPalette.green,
                    ),
                    height: 2,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appText(
                        context: context,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        title: 'Grand Total',
                        textColor: ColorPalette.green),
                    appText(
                        context: context,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        title:
                            (grandTotal - double.parse(model.discount ?? '0.0'))
                                .toStringAsFixed(2),
                        textColor: ColorPalette.green),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: ColorPalette.green,
                  ),
                  height: 2,
                ),
                context.heightBox(0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appText(
                        context: context,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        title: 'Paid Balance',
                        textColor: ColorPalette.green),
                    appText(
                        context: context,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        title: double.parse(model.paidBalance ?? '0.0')
                            .toStringAsFixed(2),
                        textColor: ColorPalette.green),
                  ],
                ),
                context.heightBox(0.01),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorPalette.green),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      appText(
                          context: context,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          title: 'Remaining',
                          textColor: ColorPalette.white),
                      appText(
                          context: context,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          title: double.parse(model.remainigBalance ?? '0.0')
                              .toStringAsFixed(2),
                          textColor: ColorPalette.white),
                    ],
                  ),
                ),
                context.heightBox(0.01),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorPalette.green,
                      ),
                      child: appText(
                          context: context,
                          title: 'Recieved Pending Amount',
                          fontSize: 12,
                          textColor: ColorPalette.white),
                    )),
                    Expanded(
                        child: numberTextField(
                            onChange: (val) {
                              if (val != null) {
                                provider.changeRemaining(val);
                              }
                            },
                            textInputType: TextInputType.number,
                            controller: provider.remainingBalance,
                            context: context,
                            hintText: 'Enter Amount')),
                  ],
                ),
                if (provider.remaining != '') context.heightBox(0.06),
                if (provider.remaining != '')
                  appText(
                      context: context,
                      title: 'Are you sure you want to update pending amount?',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      textColor: ColorPalette.green),
                if (provider.remaining != '') context.heightBox(0.04),
                if (provider.remaining != '')
                  SizedBox(
                      width: context.getSize.width * 0.4,
                      child: textButton(
                          context: context,
                          onTap: () {
                            if (double.parse(model.remainigBalance ?? '0.0') <
                                double.parse(provider.remainingBalance.text)) {
                              toast(
                                  msg:
                                      'Paid Price must be less than equal to Remaing Price',
                                  maxline: 2,
                                  context: context);
                            } else {
                              provider.updateRemaining(
                                  model, context, isSale, soldDate);
                            }
                          },
                          title: 'Confirm',
                          radius: 10)),
              ],
            ),
          ),
        )),
      );
    }));
  }
}
