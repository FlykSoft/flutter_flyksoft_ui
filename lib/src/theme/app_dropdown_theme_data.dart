import 'package:flutter/material.dart';

class AppDropdownThemeData {
  final Color? fillColor;
  final Color? disabledFillColor;
  final bool showClearIcon;
  final double height;
  final MainAxisSize mainAxisSize;
  final BoxBorder? border;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  /// Border and border radius will have no effect if box decoration is set.
  final BoxDecoration? decoration;
  final double suffixIconSpacing;
  final TextStyle? textStyle;
  final TextStyle? labelTextStyle;
  final TextStyle? errorTextStyle;
  final double clearIconSize;
  final Color clearIconColor;

  const AppDropdownThemeData({
    this.fillColor,
    this.disabledFillColor,
    this.showClearIcon = true,
    this.height = 48,
    this.mainAxisSize = MainAxisSize.max,
    this.border,
    this.decoration,
    this.textStyle,
    this.labelTextStyle,
    this.errorTextStyle,
    this.clearIconSize = 16,
    this.clearIconColor = Colors.grey,
    this.suffixIconSpacing = 8,
    this.padding = const EdgeInsets.symmetric(
      vertical: 11,
      horizontal: 10,
    ),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(
        8,
      ),
    ),
  });

  Color effectiveFillColor(bool enabled, ThemeData themeData) => enabled
      ? (fillColor ?? _defaultFillColor(themeData))
      : (disabledFillColor ?? _defaultDisabledFillColor(themeData));

  Color _defaultFillColor(ThemeData themeData) =>
      themeData.colorScheme.surfaceVariant;

  Color _defaultDisabledFillColor(ThemeData themeData) =>
      themeData.disabledColor;

  BoxBorder effectiveBorder(ThemeData themeData) =>
      border ?? _defaultBorder(themeData);

  BoxBorder _defaultBorder(ThemeData themeData) => Border.fromBorderSide(
        BorderSide(
          color: themeData.colorScheme.outline,
          width: 1,
        ),
      );

  BoxDecoration effectiveDecoration({
    required bool enabled,
    required ThemeData themeData,
  }) =>
      decoration ??
      _defaultDecoration(
        enabled: enabled,
        themeData: themeData,
      );

  BoxDecoration _defaultDecoration({
    required bool enabled,
    required ThemeData themeData,
  }) =>
      BoxDecoration(
        borderRadius: borderRadius,
        border: effectiveBorder(themeData),
        color: effectiveFillColor(enabled, themeData),
      );

  TextStyle? effectiveTextStyle(ThemeData themeData) =>
      textStyle ?? _defaultTextStyle(themeData);

  TextStyle? effectiveLabelTextStyle(ThemeData themeData) =>
      labelTextStyle ?? _defaultLabelTextStyle(themeData);

  TextStyle? effectiveErrorTextStyle(ThemeData themeData) =>
      errorTextStyle ?? _defaultErrorTextStyle(themeData);

  TextStyle? _defaultTextStyle(ThemeData themeData) =>
      themeData.textTheme.bodyLarge;

  TextStyle? _defaultLabelTextStyle(ThemeData themeData) =>
      themeData.textTheme.bodyMedium?.copyWith(
        color: themeData.hintColor,
        fontWeight: FontWeight.normal,
      );

  TextStyle? _defaultErrorTextStyle(ThemeData themeData) =>
      themeData.textTheme.labelMedium?.copyWith(
        color: themeData.colorScheme.error,
      );
}
