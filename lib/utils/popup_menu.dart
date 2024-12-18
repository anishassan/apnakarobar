import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path/path.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/font_size_extension.dart';
import 'package:sales_management/extensions/locale_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/sales_model.dart';

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
    required List<InventoryItem> dataList,
    required String selectedItem,
    required Function(InventoryItem) onSelect}) {
  return PopupMenuButton<InventoryItem>(
    onSelected: (value) {
      onSelect(value);
    },
    itemBuilder: (BuildContext context) {
      return dataList.map((InventoryItem option) {
        return PopupMenuItem<InventoryItem>(
          value: option,
          child: Text(context.getLocal(option.title ?? '')),
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
