import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_management/extensions/font_size_extension.dart';
import 'package:sales_management/extensions/locale_extension.dart';

appText(
    {required BuildContext context,
    required String title,
    FontWeight fontWeight = FontWeight.w500,
    Color textColor = Colors.black,
    double fontSize = 20,
    TextAlign? textAlign,
    
    int? maxLine}) {
  return Text(
   context.getLocal(title),
    textAlign: textAlign,
    maxLines: maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontSize: context.fontSize(fontSize),
        color: textColor),
  );
}
