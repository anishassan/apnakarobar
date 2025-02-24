import 'package:flutter/material.dart';
import 'package:sales_management/constant/color.dart';

import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/locale_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/box_shadow.dart';

Widget expandedTile(
    {required BuildContext context,
    required List<String> dataList,
    required Function(String) onTap}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 12,
    ),
    decoration: BoxDecoration(
        color: ColorPalette.white,
        boxShadow: [
          boxShadow(
            context: context,
            blur: 5,
            y: 5,
            color: ColorPalette.black,
            opacity: 0.3,
          ),
        ],
        borderRadius: BorderRadius.circular(20)),
    child: ListView.builder(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onTap(context.getLocal(dataList[index]));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0 ? SizedBox.shrink() : context.heightBox(0.01),
                SizedBox(
                  width: context.getSize.width,
                  child: appText(
                    context: context,
                    title: dataList[index],
                    textColor: ColorPalette.green,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                dataList.length - 1 == index
                    ? SizedBox.shrink()
                    : context.heightBox(0.01),
                dataList.length - 1 == index
                    ? SizedBox.shrink()
                    : Container(
                        height: 1,
                        color: ColorPalette.green,
                        width: context.getSize.width,
                      )
              ],
            ),
          );
        }),
  );
}
