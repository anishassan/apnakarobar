import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_management/repositories/storage/storage_repo.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default locale
  Map<String, String> _localizedStrings = {};

  Locale get locale => _locale;

  // Load the JSON file for the selected locale
  Future<void> load(Locale locale) async {
    _locale = locale;
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    notifyListeners();
  }

  // Get translated text by key
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Set new locale
  void setLocale(Locale locale) {
    if (_locale == locale) return;
    load(locale);
  }

  List<String> langauge = [
    "English",
    'Urdu',
  ];
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  changeIndex(int index, StorageRepo rep) {
    _selectedIndex = index;
    if (index == 1) {
      rep.setLang('ur');
      setLocale(const Locale('ur'));
    } else {
      rep.setLang('en');
      setLocale(const Locale('en'));
    }
    notifyListeners();
  }
}
