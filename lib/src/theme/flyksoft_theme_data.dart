import 'package:flutter/cupertino.dart';

class FlyksoftThemeData {
  final double horizontalPaddingValue;

  FlyksoftThemeData({
    required this.horizontalPaddingValue,
  });

  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(
        horizontal: horizontalPaddingValue,
      );
}
