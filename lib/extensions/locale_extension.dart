import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/provider/localization_provider.dart';

extension LocaleExtension on BuildContext{
  String getLocal(String val) => Provider.of<LocalizationProvider>(this,listen: false).translate(val);
 String getLocalWithArg(String key, {Map<String, String>? args}) {
    final localizationProvider = Provider.of<LocalizationProvider>(this, listen: false);
    String translated = localizationProvider.translate(key) ?? key;

    // Replace dynamic placeholders (e.g., @value)
    args?.forEach((argKey, argValue) {
      translated = translated.replaceAll('@$argKey', argValue);
    });

    return translated;
  }
}