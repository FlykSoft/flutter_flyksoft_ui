import 'package:flutter/material.dart';
import 'package:flyksoft_ui/src/theme/flyksoft_theme_data.dart';

class FlyksoftTheme extends InheritedWidget {
  final FlyksoftThemeData themeData;

  const FlyksoftTheme({
    required this.themeData,
    required super.child,
    super.key,
  });

  static FlyksoftThemeData? of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<FlyksoftTheme>();
    return provider?.themeData;
  }

  @override
  bool updateShouldNotify(FlyksoftTheme oldWidget) {
    return themeData != oldWidget.themeData;
  }
}
