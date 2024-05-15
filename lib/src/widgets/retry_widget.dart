import 'package:flutter/material.dart';

import '../localization/flyksoft_ui_localization.dart';
import 'app_button.dart';
import 'app_text.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({
    required this.onRetry,
    this.message,
    this.padding,
    this.textStyle,
    super.key,
  });

  final void Function() onRetry;
  final String? message;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: 32 * 2.5, vertical: 32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.bodyMedium(
                message ??
                    FlyksoftUILocalization.of(context).unknownFailureMessage,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              AppButton.filled(
                onPressed: onRetry,
                text: FlyksoftUILocalization.of(context).retry,
                style: ElevatedButtonTheme.of(context).style?.copyWith(
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      );
}
