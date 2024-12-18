import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/box_shadow.dart';

class DetailScreen extends StatelessWidget {
  final Datum model;
  final int type;
  const DetailScreen({super.key, required this.model, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    boxShadow(
                        context: context,
                        color: ColorPalette.black,
                        blur: 5,
                        y: 5)
                  ],
                  color: ColorPalette.white,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        appText(
                            context: context,
                            title:
                                type == 1 ? 'Customer Name' : 'Supplier Name'),
                        appText(context: context, title: model.name ?? ''),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        appText(
                            context: context,
                            title: type == 1 ? 'Contact' : 'Contact'),
                        appText(context: context, title: model.contact ?? ''),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: context.getSize.width * 0.27,
                          child: appText(
                              context: context, title: 'Product', fontSize: 15),
                        ),
                        SizedBox(
                          width: context.getSize.width * 0.25,
                          child: appText(
                              context: context, title: 'Price', fontSize: 15),
                        ),
                        SizedBox(
                          width: context.getSize.width * 0.25,
                          child: appText(
                              context: context,
                              title: 'Quantity',
                              fontSize: 15),
                        ),
                      ],
                    ),
                    if (model.soldProducts != [])
                      Column(
                        children:
                            List.generate(model.soldProducts!.length, (index) {
                          final data = model.soldProducts![index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: context.getSize.width * 0.27,
                                child: appText(
                                    context: context,
                                    title: data.title ?? '',
                                    fontSize: 15),
                              ),
                              SizedBox(
                                width: context.getSize.width * 0.25,
                                child: appText(
                                    context: context,
                                    title: data.productprice ?? '',
                                    fontSize: 15),
                              ),
                              SizedBox(
                                width: context.getSize.width * 0.25,
                                child: appText(
                                    context: context,
                                    title: data.quantity ?? '',
                                    fontSize: 15),
                              ),
                            ],
                          );
                        }),
                      ),
                    context.heightBox(0.01),
                    Row(
                      children: [
                        appText(context: context, title: 'Remaining : '),
                        appText(
                            context: context,
                            title: 'PKR ' + model.remainigBalance.toString() ??
                                '0.0')
                      ],
                    ),
                    Row(
                      children: [
                        appText(context: context, title: 'Paid : '),
                        appText(
                            context: context,
                            title: model.paidBalance == ''
                                ? 'PKR 0.0'
                                : 'PKR ' + model.paidBalance.toString() ?? '')
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
