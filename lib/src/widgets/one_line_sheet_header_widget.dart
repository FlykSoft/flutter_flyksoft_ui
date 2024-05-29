import 'package:flutter/material.dart';
import 'package:flyksoft_ui/src/theme/flyksoft_theme.dart';

import 'app_text.dart';

class OneLineSheetHeaderWidget extends StatelessWidget {
  const OneLineSheetHeaderWidget({
    this.showCloseButton = true,
    this.title,
    this.titleTextStyle,
    this.padding,
    this.onClosePressed,
    super.key,
  });

  final String? title;
  final bool showCloseButton;
  final TextStyle? titleTextStyle;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onClosePressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ??
            EdgeInsetsDirectional.only(
              start: FlyksoftTheme.of(context)?.horizontalPaddingValue ?? 0,
              end: FlyksoftTheme.of(context)?.horizontalPaddingValue ?? 0,
              bottom: 8,
              top: 12,
            ),
        child: Row(
          children: [
            if (title != null)
              Expanded(
                child: AppText(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titleTextStyle ??
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                          ),
                ),
              )
            else
              const Spacer(),
            if (showCloseButton)
              IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 24,
                ),
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(),
                splashRadius: 20,
                padding: EdgeInsets.zero,
                iconSize: 24,
                onPressed: onClosePressed ?? Navigator.of(context).pop,
              ),
          ],
        ),
      );
}
