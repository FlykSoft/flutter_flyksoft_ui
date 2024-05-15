import 'package:flutter/material.dart';

import '../localization/flyksoft_ui_localization.dart';
import 'app_text.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({
    this.message,
    this.itemName,
    this.padding,
    this.textAlign,
    this.isScrollable = false,
    super.key,
  });

  final String? message;
  final String? itemName;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;

  @override
  Widget build(final BuildContext context) => isScrollable
      ? SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: _NotFoundBodyWidget(
            itemName: itemName,
            message: message,
            padding: padding,
            textAlign: textAlign,
          ),
        )
      : _NotFoundBodyWidget(
          itemName: itemName,
          message: message,
          padding: padding,
          textAlign: textAlign,
        );
}

class _NotFoundBodyWidget extends StatelessWidget {
  const _NotFoundBodyWidget({
    this.message,
    this.itemName,
    this.padding,
    this.textAlign,
    super.key,
  });

  final String? message;
  final String? itemName;
  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;

  @override
  Widget build(final BuildContext context) => Center(
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
          child: AppText.bodyMedium(
            message ??
                (itemName != null
                    ? FlyksoftUILocalization.of(context)
                        .noItemFoundWithItemName(itemName!)
                    : FlyksoftUILocalization.of(context).noItemFound),
            textAlign: textAlign ?? TextAlign.center,
          ),
        ),
      );
}
