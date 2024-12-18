import 'package:flutter/material.dart';
import 'package:sales_management/constant/color.dart';

import 'package:sales_management/utils/app_text.dart';

toast({required String msg, required BuildContext context, int maxline = 1}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: ColorPalette.green,
      content: appText(
        context: context,
        maxLine: maxline,
        title: msg,
        textColor: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      )));
}
