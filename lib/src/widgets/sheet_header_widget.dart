import 'package:flutter/material.dart' hide CloseButton;

import '../theme/flyksoft_theme.dart';
import 'app_text.dart';

class SheetHeaderWidget extends StatelessWidget {
  const SheetHeaderWidget({
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
              top: 8,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showCloseButton)
              Row(
                children: [
                  const Spacer(),
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
            Row(
              children: [
                const Spacer(),
                if (title != null)
                  AppText(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: titleTextStyle ??
                        Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 16,
                            ),
                  ),
                const Spacer(),
              ],
            ),
          ],
        ),
      );
}
