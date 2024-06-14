import 'package:arah_app/language/english.dart';
import 'package:arah_app/language/indonesian.dart';
import 'package:arah_app/language/languages.dart';
import 'package:flutter/material.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ["id", "en"].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    switch (locale.languageCode) {
      case "id":
        return LanguageId();
      case "en":
        return LanguageEn();
      default:
        return LanguageId();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
