import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/provider/localization_provider.dart';

extension LocaleExtension on BuildContext{
  String getLocal(String val) => Provider.of<LocalizationProvider>(this,listen: false).translate(val);

}