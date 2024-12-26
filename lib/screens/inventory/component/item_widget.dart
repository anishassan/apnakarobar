import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/utils/app_text.dart';

itemWidget({required String title,required BuildContext context}){
  return  Flexible(
                                                    child: Container(
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          right: BorderSide(
                                                              color: ColorPalette
                                                                  .black
                                                                  .withOpacity(
                                                                      0.2)),
                                                          bottom: BorderSide(
                                                              color: ColorPalette
                                                                  .black
                                                                  .withOpacity(
                                                                      0.2)))),
                                                  width: context.getSize.width *
                                                      0.2,
                                                  child: appText(
                                                      context: context,
                                                      fontSize: 13,
                                                      title: title),
                                                ));
}