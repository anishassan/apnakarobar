import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/font_size_extension.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/locale_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/provider/add_product_provider.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/box_shadow.dart';
import 'package:sales_management/utils/text_field.dart';

popupMenu(
    {required BuildContext context,
    required List<String> dataList,
    required String selectedItem,
    required Function(String) onSelect}) {
  return PopupMenuButton<String>(
    onSelected: (value) {
      onSelect(value);
    },
    itemBuilder: (BuildContext context) {
      return dataList.map((String option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(context.getLocal(option)),
        );
      }).toList();
    },
    // Use a custom button as the trigger
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      decoration: BoxDecoration(
        color: ColorPalette.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.getLocal(selectedItem),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    ),
  );
}

popupMenuProduct(
    {required BuildContext context,
    required String selectedItem,
    required Function(InventoryItem) onSelect}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (
        ct,
      ) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Consumer<AddProductProvider>(builder: (context, provider, __) {
            return PopScope(
              onPopInvoked: (val) {
                provider.clearInventorySearch();
              },
              child: Container(
                height: context.getSize.height * 0.5,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: ColorPalette.white,
                    boxShadow: [
                      boxShadow(
                          context: context,
                          blur: 5,
                          y: 5,
                          color: ColorPalette.black,
                          opacity: 0.3)
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          provider.clearInventorySearch();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorPalette.green,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Icon(Icons.close, color: ColorPalette.white),
                        ),
                      ),
                    ),
                    context.heightBox(0.01),
                    centerTextField(
                        controller: provider.searchProduct,
                        onChange2: (val) {
                          if (val != null) {
                            provider.filterInventory(val);
                          }
                        },
                        context: context,
                        hintText: 'Search'),
                    context.heightBox(0.01),
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: provider.filterinventoryList.isEmpty
                              ? provider.inventoryList.length
                              : provider.filterinventoryList.length,
                          itemBuilder: (context, index) {
                            final InventoryItem inv =
                                provider.filterinventoryList.isEmpty
                                    ? provider.inventoryList[index]
                                    : provider.filterinventoryList[index];
                            return GestureDetector(
                              onTap: () {
                                onSelect(inv);
                                Navigator.of(context).pop();
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  context.heightBox(0.01),
                                  SizedBox(
                                    width: context.getSize.width,
                                    child: appText(
                                        context: context,
                                        fontSize: 14,
                                        title: inv.title ?? '',
                                        textColor: ColorPalette.green),
                                  ),
                                  Container(
                                    height: 2,
                                    width: context.getSize.width,
                                    color: ColorPalette.green,
                                  )
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            );
          }),
        );
      });
  // PopupMenuButton<InventoryItem>(
  //   onSelected: (value) {
  //     onSelect(value);
  //   },
  //   itemBuilder: (BuildContext context) {
  //     return dataList.map((InventoryItem option) {
  //       return PopupMenuItem<InventoryItem>(
  //         value: option,
  //         child: Text(context.getLocal(option.title ?? '')),
  //       );
  //     }).toList();
  //   },
  //   // Use a custom button as the trigger
  //   child: Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
  //     decoration: BoxDecoration(
  //       color: ColorPalette.green,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           context.getLocal(selectedItem),
  //           overflow: TextOverflow.ellipsis,
  //           style: const TextStyle(
  //             color: Colors.white,
  //           ),
  //         ),
  //         const SizedBox(width: 5),
  //         const Icon(Icons.arrow_drop_down, color: Colors.white),
  //       ],
  //     ),
  //   ),
  // );
}

popupMenuSupplierAndCustomer(
    {required BuildContext context,
    required List<Datum> dataList,
    required String selectedItem,
    required Function(Datum) onSelect}) {
  print(dataList.length);
  return PopupMenuButton<Datum>(
    onSelected: (value) {
      onSelect(value);
    },
    itemBuilder: (BuildContext context) {
      return dataList.map((Datum option) {
        return PopupMenuItem<Datum>(
          value: option,
          child: Text(context.getLocal(option.name ?? '')),
        );
      }).toList();
    },
    // Use a custom button as the trigger
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      decoration: BoxDecoration(
        color: ColorPalette.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.getLocal(selectedItem),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    ),
  );
}

reportPopupMenu(
    {required BuildContext context,
    required List<String> dataList,
    required String selectedItem,
    required Function(String) onSelect}) {
  return PopupMenuButton<String>(
    onSelected: (value) {
      onSelect(value);
    },
    itemBuilder: (BuildContext context) {
      return dataList.map((String option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(context.getLocal(option)),
        );
      }).toList();
    },
    // Use a custom button as the trigger
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 11),
      decoration: BoxDecoration(
        color: ColorPalette.green,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.getLocal(selectedItem),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: context.fontSize(12),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.filter_alt,
            color: Colors.white,
            size: 15,
          ),
        ],
      ),
    ),
  );
}
