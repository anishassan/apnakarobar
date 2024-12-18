

import 'package:flutter/material.dart';

import 'package:sales_management/constant/color.dart';
import 'package:sales_management/utils/app_text.dart';

textButton({
  required BuildContext context,
  required VoidCallback onTap,
  required String title,
  Color textColor = ColorPalette.white,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.w600,
  required double radius,
  Color bgColor = ColorPalette.green,
  Color borderColor = ColorPalette.transparent,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: appText(
          context: context,
          title: title,
          fontSize: fontSize,
          fontWeight: fontWeight,
          textColor: textColor),
    ),
  );
}
