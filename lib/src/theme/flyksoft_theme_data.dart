import 'package:flutter/cupertino.dart';

import 'app_dropdown_theme_data.dart';

class FlyksoftThemeData {
  final double horizontalPaddingValue;
  final AppDropdownThemeData appDropdownThemeData;

  FlyksoftThemeData({
    this.horizontalPaddingValue = 20,
    this.appDropdownThemeData = const AppDropdownThemeData(),
  });

  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(
        horizontal: horizontalPaddingValue,
      );
}
