import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/locale_extension.dart';
import 'package:sales_management/gen/assets.gen.dart';
import 'package:sales_management/main.dart';
import 'package:sales_management/provider/dashboard_provider.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sales_management/provider/localization_provider.dart';
import 'package:sales_management/screens/inventory/inventory_screen.dart';
import 'package:sales_management/screens/profile/profile_screen.dart';
import 'package:sales_management/screens/purchase/purchase_screen.dart';
import 'package:sales_management/screens/report/report_screen.dart';
import 'package:sales_management/screens/sales/sales_screen.dart';
import 'package:sales_management/utils/app_text.dart';

class DashbaordScreen extends StatelessWidget {
  const DashbaordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context, listen: true);
    final localPv = Provider.of<LocalizationProvider>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 0,
          backgroundColor: ColorPalette.green,
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: ColorPalette.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Assets.images.logo.image(
                    height: context.getSize.height * 0.12,
                    width: context.getSize.width * 0.12),
              )
            ],
          ),
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (val) {
            if (provider.selectedIndex != 0) {
              provider.changeIndex(provider.selectedIndex - 1);
            }
          },
          child: SafeArea(
            child: _buildScreen(provider.selectedIndex),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: ColorPalette.green,
          ),
          width: context.getSize.width,
          height: Platform.isAndroid
              ? context.getSize.height * 0.1
              : context.getSize.height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(provider.navbarList.length, (index) {
              return GestureDetector(
                onTap: () {
                  provider.changeIndex(index);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      color: provider.selectedIndex == index
                          ? ColorPalette.white
                          : ColorPalette.black,
                      provider.navbarList[index],
                      width: context.getSize.height * 0.03,
                    ),
                    context.heightBox(0.01),
                    appText(
                        textAlign: TextAlign.end,
                        textColor: provider.selectedIndex == index
                            ? ColorPalette.white
                            : ColorPalette.black,
                        context: context,
                        title: localPv.translate(provider.navbarName[index]),
                        fontSize: 13)
                  ],
                ),
              );
            }),
          ),
        ));
  }

  _buildScreen(int index) {
    switch (index) {
      case 0:
        return const InventoryScreen();
      case 1:
        return const SalesScreen();
      case 2:
        return const PurchaseScreen();
      case 3:
        return ReportScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}
