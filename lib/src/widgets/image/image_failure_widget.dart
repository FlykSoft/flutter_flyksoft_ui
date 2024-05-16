import 'dart:math';

import 'package:flutter/material.dart';

import '../conditional_widget.dart';

class ImageFailureWidget extends StatelessWidget {
  const ImageFailureWidget({
    this.width,
    this.height,
    this.onRetry,
    this.failureIcon,
    super.key,
  });

  final double? width;
  final double? height;
  final Widget? failureIcon;
  final void Function()? onRetry;

  @override
  Widget build(final BuildContext context) => ConditionalWidget(
        condition: onRetry != null,
        conditionBuilder: (child) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onRetry,
          child: child,
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: failureIcon ??
                Icon(
                  onRetry != null ? Icons.refresh : Icons.image_not_supported,
                  size: width != null &&
                          height != null &&
                          width != double.infinity &&
                          height != double.infinity
                      ? min(width!, height!) / 2
                      : null,
                ),
          ),
        ),
      );
}
