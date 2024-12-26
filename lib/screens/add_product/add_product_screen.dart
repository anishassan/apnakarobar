import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/models/item_model.dart';
import 'package:sales_management/provider/add_product_provider.dart';
import 'package:sales_management/provider/dashboard_provider.dart';
import 'package:sales_management/provider/inventory_provider.dart';
import 'package:sales_management/screens/add_product/component/add_new_item.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/text_button.dart';
import 'package:sales_management/utils/text_field.dart';

class AddProductScreen extends StatefulWidget {
  int type;
  AddProductScreen({super.key, required this.type});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late AddProductProvider pv;
  @override
  void initState() {
    pv = Provider.of<AddProductProvider>(context, listen: false);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    pv.clearAllData();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductProvider>(builder: (context, provider, __) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorPalette.green,
            onPressed: () {
              provider.addInventoryProduct(
                  d: provider.productItems, context: context);
            },
            child: const Icon(
              Icons.add,
              color: ColorPalette.white,
            ),
          ),
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.dashboard)
                    .then((e) {
                  Provider.of<DashboardProvider>(context, listen: false)
                      .changeIndex(
                    0,
                  );
                });
              },
              child: Icon(
                Icons.keyboard_arrow_left,
                color: ColorPalette.white,
                size: 30,
              ),
            ),
            title: appText(
                context: context,
                title: widget.type == 0
                    ? 'Add Product'
                    : widget.type == 1
                        ? 'Add Sales'
                        : 'Add Purchase',
                textColor: ColorPalette.white),
            backgroundColor: ColorPalette.green,
          ),
          body: PopScope(
            canPop: false,
            onPopInvoked: (val) {
              Navigator.pushReplacementNamed(context, Routes.dashboard)
                  .then((e) {
                Provider.of<DashboardProvider>(context, listen: false)
                    .changeIndex(
                  0,
                );
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  context.heightBox(0.01),
                  textButton(
                      context: context,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.addItem,
                                arguments: widget.type)
                            .then((e) {
                          Provider.of<DashboardProvider>(context, listen: false)
                              .changeIndex(
                            0,
                          );
                        });
                      },
                      title: 'Add New Item',
                      radius: 4),
                  Column(children: [
                    context.heightBox(0.01),
                    textField(
                        context: context,
                        controller: provider.search,
                        hintText: 'Search',
                        suffixIcon: GestureDetector(
                          child: Icon(Icons.search),
                        )),
                  ]),
                  context.heightBox(0.01),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.type == 0
                          ? provider.productItems.length
                          : widget.type == 1
                              ? provider.salesItems.length
                              : provider.purchaseItems.length,
                      itemBuilder: (context, index) {
                        final item = provider.productItems[index];
                        bool isTrue = provider.selecteditemIndexList
                            .any((e) => e == index);
                        return Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox.adaptive(
                                        value: isTrue,
                                        onChanged: (val) {
                                          provider.addSelectedItemIndex(index);
                                        }),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              appText(
                                                  context: context,
                                                  title: item.title ?? ''),
                                              if (isTrue)
                                                appText(
                                                    context: context,
                                                    title:
                                                        'Rs: ${item.totalprice ?? ''}/-' ??
                                                            ''),
                                            ],
                                          ),
                                          appText(
                                              context: context,
                                              title:
                                                  'Stock ${item.stock ?? ''}',
                                              fontSize: 10),
                                          context.heightBox(0.005),
                                          if (isTrue)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: context.getSize.width *
                                                      0.3,
                                                  child: centerTextField(
                                                      onChange: (val) {
                                                        if (val == null) {
                                                        } else {
                                                          String price = (double
                                                                      .parse(val ??
                                                                          '0.0') *
                                                                  double.parse(
                                                                      item.productprice ??
                                                                          '0.0'))
                                                              .toString();

                                                          provider.replaceModel(
                                                              type: widget.type,
                                                              model: ItemModel(
                                                                productprice: item
                                                                    .productprice,
                                                                date: item.date,
                                                                id: item.id,
                                                                quantity: val,
                                                                totalprice:
                                                                    price,
                                                                title:
                                                                    item.title,
                                                                stock:
                                                                    item.stock,
                                                              ),
                                                              index: index);
                                                        }
                                                      },
                                                      textInputType:
                                                          TextInputType.number,
                                                      context: context,
                                                      controller:
                                                          TextEditingController(),
                                                      hintText:
                                                          '|QTY-${item.quantity ?? ''}'),
                                                ),
                                                SizedBox(
                                                    width:
                                                        context.getSize.width *
                                                            0.3,
                                                    child: textButton(
                                                        bgColor: ColorPalette
                                                            .green
                                                            .withOpacity(0.5),
                                                        context: context,
                                                        onTap: () {},
                                                        title:
                                                            'Rate: ${item.productprice}',
                                                        radius: 4)),
                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            context.widthBox(0.01),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: ColorPalette.green,
                                  shape: BoxShape.circle),
                              child: GestureDetector(
                                onTap: () {
                                  provider.removeInventoryItem(index);
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: ColorPalette.white,
                                ),
                              ),
                            )
                          ],
                        );
                      })
                ],
              ),
            ),
          ));
    });
  }
}
