import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/gen/assets.gen.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/box_shadow.dart';

addNewProductExpandedTile({
  required String title,
  required BuildContext context,
  required bool isExpanded,
  required VoidCallback onTap,
  required String icon
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [boxShadow(context: context, y: 5, blur: 5, opacity: 0.2)],
        color: isExpanded ? ColorPalette.green : ColorPalette.white,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
         icon,
            color: isExpanded ? ColorPalette.white : ColorPalette.green,
            height: context.getSize.height * 0.03,
          ),
          context.widthBox(0.1),
          appText(
            context: context,
            title: title,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            textColor: isExpanded ? ColorPalette.white : ColorPalette.green,
          ),
          const Spacer(),
          if (!isExpanded)
            const Icon(
              Icons.arrow_drop_down_sharp,
              color: ColorPalette.green,
            )
        ],
      ),
    ),
  );
}
