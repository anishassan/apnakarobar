import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/provider/inventory_provider.dart';
import 'package:sales_management/provider/sales_provider.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/box_shadow.dart';
import 'package:sales_management/utils/text_field.dart';

class InventoryReport extends StatefulWidget {
  InventoryReport({
    super.key,
  });

  @override
  State<InventoryReport> createState() => _InventoryReportState();
}

class _InventoryReportState extends State<InventoryReport> {
  late SalesProvider _salesProvider;
  @override
  void initState() {
    _salesProvider = Provider.of<SalesProvider>(context, listen: false);
    Provider.of<InventoryProvider>(context, listen: false).getInventoryData(context: context);
    // TODO: implement initState
    super.initState();
  }

  bool isSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(builder: (context, provider, __) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            textField(
                context: context,
                controller: TextEditingController(),
                hintText: 'Search',
                prefixIcon: GestureDetector(
                  child: Icon(Icons.search),
                )),
            context.heightBox(0.01),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    InventoryItem item = provider.products[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorPalette.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [boxShadow(context: context)]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  appText(
                                    context: context,
                                    title: item.title ?? '',
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  appText(
                                    fontSize: 12,
                                    context: context,
                                    title: 'rsv',
                                  ),
                                  appText(
                                    fontSize: 13,
                                    context: context,
                                    title: item.quantity == ""
                                        ? ""
                                        : "${item.quantity ?? '0'}${item.stock}",
                                  ),
                                  appText(
                                    fontSize: 13,
                                    context: context,
                                    title: item.quantity == ""
                                        ? ""
                                        : 'PKR ' +
                                            (double.parse(item.quantity ?? '0') *
                                                    double.parse(
                                                        item.productprice ??
                                                            '0.0'))
                                                .toStringAsFixed(2),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  appText(
                                      context: context,
                                      title: 'Opening Stock',
                                      fontSize: 12),
                                  appText(
                                      context: context,
                                      title: '${item.stock}',
                                      fontSize: 12),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  appText(
                                      context: context,
                                      title: 'Sold',
                                      fontSize: 12),
                                  appText(
                                      context: context,
                                      title: provider.getSoldProducts(
                                              _salesProvider.soldProducts,
                                              item.title ?? '') +
                                          '${item.stock ?? '0'}',
                                      fontSize: 12),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  appText(
                                      context: context,
                                      title: 'Purchased',
                                      fontSize: 12),
                                  appText(
                                      context: context,
                                      title: provider.getTotalProducts(
                                              _salesProvider.soldProducts,
                                              item.quantity,
                                              item.title ?? '') +
                                          '${item.stock}',
                                      fontSize: 12),
                                ],
                              ),
                            ],
                          ),
                          context.heightBox(0.01),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: ColorPalette.green,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    appText(
                                        context: context,
                                        textColor: ColorPalette.white,
                                        title: 'Opening Rate',
                                        fontSize: 14),
                                    appText(
                                        context: context,
                                        title: 'PKR 0.0',
                                        textColor: ColorPalette.white,
                                        fontSize: 14),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    appText(
                                        context: context,
                                        textColor: ColorPalette.white,
                                        title: 'Sale Rate',
                                        fontSize: 14),
                                    appText(
                                        context: context,
                                        title: 'PKR  ${item.lastSale ?? '0.0'}',
                                        textColor: ColorPalette.white,
                                        fontSize: 14),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    appText(
                                        context: context,
                                        textColor: ColorPalette.white,
                                        title: 'Purchase Rate',
                                        fontSize: 14),
                                    appText(
                                        context: context,
                                        title:
                                            'PKR ${item.lastPurchase ?? '0.0'} ',
                                        textColor: ColorPalette.white,
                                        fontSize: 14),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      );
    });
  }
}
