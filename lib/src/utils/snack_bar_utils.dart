import 'package:flutter/material.dart';
import 'package:flyksoft_ui/flyksoft_ui.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SnackBarUtils {
  static void showSnackBarSuccess({
    required final BuildContext context,
    final String? message,
  }) {
    showSnackBarSuccessWithoutContext(
      overlayState: Overlay.of(context),
      themeData: Theme.of(context),
      flyksoftUILocalizationDelegate: FlyksoftUILocalization.of(context),
      message: message,
    );
  }

  static void showSnackBarSuccessWithoutContext({
    required final OverlayState overlayState,
    required final ThemeData themeData,
    required final FlyksoftUILocalizationDelegate
        flyksoftUILocalizationDelegate,
    final String? message,
    final Duration? duration,
  }) {
    showTopSnackBar(
      overlayState,
      displayDuration: duration ?? _defaultDuration,
      CustomSnackBar.success(
        message: message ?? flyksoftUILocalizationDelegate.successfulOperation,
        textAlign: TextAlign.center,
        backgroundColor: Colors.green,
        maxLines: 3,
        messagePadding: const EdgeInsets.all(8),
        textStyle: _textStyle(themeData),
      ),
    );
  }

  static void showSnackBarFailure({
    required final BuildContext context,
    final String? message,
    final Duration? duration,
  }) {
    showSnackBarFailureWithoutContext(
      overlayState: Overlay.of(context),
      themeData: Theme.of(context),
      flyksoftUILocalizationDelegate: FlyksoftUILocalization.of(context),
      message: message,
      duration: duration,
    );
  }

  static void showSnackBarFailureWithoutContext({
    required final OverlayState overlayState,
    required final ThemeData themeData,
    required final FlyksoftUILocalizationDelegate
        flyksoftUILocalizationDelegate,
    final String? message,
    final Duration? duration,
  }) {
    showTopSnackBar(
      overlayState,
      displayDuration: duration ?? _defaultDuration,
      CustomSnackBar.error(
        message:
            message ?? flyksoftUILocalizationDelegate.unsuccessfulOperation,
        textAlign: TextAlign.start,
        messagePadding: const EdgeInsets.all(8),
        maxLines: 3,
        textStyle: _textStyle(themeData),
      ),
    );
  }

  static void showSnackBarInfo({
    required final BuildContext context,
    required final String message,
    final Duration? duration,
  }) {
    showSnackBarInfoWithoutContext(
      overlayState: Overlay.of(context),
      themeData: Theme.of(context),
      message: message,
      duration: duration,
    );
  }

  static void showSnackBarInfoWithoutContext({
    required final OverlayState overlayState,
    required final ThemeData themeData,
    required final String message,
    final Duration? duration,
  }) {
    showTopSnackBar(
      overlayState,
      displayDuration: duration ?? _defaultDuration,
      CustomSnackBar.info(
        message: message,
        textAlign: TextAlign.start,
        messagePadding: const EdgeInsets.all(8),
        maxLines: 3,
        textStyle: _textStyle(themeData),
        backgroundColor: Colors.orange,
      ),
    );
  }

  static TextStyle _textStyle(ThemeData themeData) =>
      themeData.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static const _defaultDuration = Duration(milliseconds: 3000);
}
