import 'package:flutter/material.dart';

class LocaleHelper {
  static bool isRTL(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final rtlLanguages = ['ar', 'ku', 'fa', 'ur'];
    return rtlLanguages.contains(locale.languageCode);
  }
}
