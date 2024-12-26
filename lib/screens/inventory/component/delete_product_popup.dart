import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/locale_extension.dart';
import 'package:sales_management/utils/app_text.dart';

deleteProductPopup(
    {required BuildContext context,
    required String title,
    required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: () {
      showAdaptiveDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: ColorPalette.green,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  appText(
                      maxLine: 3,
                      fontSize: 14,
                      context: context,
                      textColor: ColorPalette.white,
                      title: context.getLocalWithArg('confirmDelete',
                          args: {"value": title ?? ''})),
                  context.heightBox(0.03),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: appText(
                        context: context,
                        fontSize: 14,
                        textColor: ColorPalette.white,
                        title: 'no')),
                TextButton(
                    onPressed: onPressed,
                    child: appText(
                        context: context,
                        fontSize: 14,
                        textColor: ColorPalette.white,
                        title: 'yes'))
              ],
            );
          });
    },
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: ColorPalette.green),
      child: const Icon(
        Icons.close,
        color: ColorPalette.white,
        size: 20,
      ),
    ),
  );
}
