import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/provider/report_provider.dart';
import 'package:sales_management/utils/app_text.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});
  List<String> reportType = [
    'Sale Report',
    'Purchase Report',
    'Customer Report',
    'Supplier Report',
    'Inventory Report',
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      itemCount: reportType.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.reports,
                arguments: [index, reportType[index]]);
          },
          child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorPalette.white,
                boxShadow: [
                  BoxShadow(
                      color: ColorPalette.black.withOpacity(0.2),
                      offset: Offset(0, 4),
                      blurRadius: 4)
                ],
                borderRadius: BorderRadius.circular(30),
              ),
              child: appText(
                  maxLine: 2,
                  context: context,
                  title: reportType[index],
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  textColor: ColorPalette.green)),
        );
      },
    );
  }
}
