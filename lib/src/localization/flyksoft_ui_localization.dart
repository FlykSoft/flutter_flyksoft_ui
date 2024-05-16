import 'package:flutter/material.dart';
import 'package:flyksoft_ui/src/localization/flyksoft_ui_arabic_localization_delegate.dart';
import 'package:flyksoft_ui/src/localization/flyksoft_ui_english_localization_delegate.dart';

import 'flyksoft_ui_localization_delegate.dart';

class FlyksoftUILocalization {
  static final Map<String, FlyksoftUILocalizationDelegate>
      _registeredLocalizations = {
    'en': const FlyksoftUIEnglishLocalizationDelegate(),
    'ar': const FlyksoftUIArabicLocalizationDelegate(),
  };

  static void register(
      Map<String, FlyksoftUILocalizationDelegate> localization) {
    _registeredLocalizations.addAll(localization);
  }

  static FlyksoftUILocalizationDelegate of(
    BuildContext context,
  ) {
    final String languageCode = _findLocaleByContext(context).languageCode;
    return _registeredLocalizations[languageCode] ??
        const FlyksoftUIEnglishLocalizationDelegate();
  }

  static Locale _findLocaleByContext(BuildContext context) =>
      Localizations.localeOf(context);
}
