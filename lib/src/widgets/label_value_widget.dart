import 'package:flutter/material.dart';

import '../../flyksoft_ui.dart';

class LabelValueColumn extends StatelessWidget {
  const LabelValueColumn({
    this.label,
    this.value,
    this.padding,
    this.currencyType,
    this.labelTextStyle,
    this.valueTextStyle,
    this.child,
    this.labelWidget,
    this.labelMaxLines = 1,
    this.labelTextOverflow = TextOverflow.ellipsis,
    this.valueTextOverflow = TextOverflow.ellipsis,
    this.spacing = 8,
    this.isRequired = false,
    this.labelTextAlign,
    this.valueTextAlign,
    this.valueMaxLines,
    this.currency,
    super.key,
  })  : assert(
          label != null || labelWidget != null,
          'Either label or label widget must be provided',
        ),
        assert(
          value != null || child != null,
          'Either value or child must be provided',
        );

  final String? label;
  final String? value;
  final String? currencyType;
  final EdgeInsetsGeometry? padding;
  final bool isRequired;
  final Widget? child;
  final Widget? labelWidget;
  final TextStyle? labelTextStyle;
  final TextStyle? valueTextStyle;
  final double spacing;
  final int labelMaxLines;
  final TextOverflow labelTextOverflow;
  final TextOverflow valueTextOverflow;
  final TextAlign? labelTextAlign;
  final TextAlign? valueTextAlign;
  final int? valueMaxLines;
  final String? currency;

  @override
  Widget build(BuildContext context) => ConditionalWidget(
        conditionBuilder: (child) => Padding(
          padding: padding!,
          child: child,
        ),
        condition: padding != null && padding != EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelWidget ??
                _DefaultLabelWidget(
                  label: label,
                  isRequired: isRequired,
                  textStyle: labelTextStyle,
                  maxLines: labelMaxLines,
                  textOverflow: labelTextOverflow,
                ),
            SizedBox(
              height: spacing,
            ),
            child ??
                _DefaultValueWidget(
                  value: value,
                  isRequired: isRequired,
                  textStyle: valueTextStyle,
                  maxLines: valueMaxLines,
                  textOverflow: valueTextOverflow,
                  textAlign: valueTextAlign,
                  currency: currency,
                ),
          ],
        ),
      );
}

class LabelValueRow extends StatelessWidget {
  const LabelValueRow({
    this.label,
    this.value,
    this.padding,
    this.currency,
    this.labelTextStyle,
    this.valueTextStyle,
    this.child,
    this.labelWidget,
    this.labelFlex = 1,
    this.valueFlex = 2,
    this.labelFit = FlexFit.tight,
    this.valueFit = FlexFit.tight,
    this.labelMaxLines = 1,
    this.valueTextOverflow = TextOverflow.ellipsis,
    this.labelTextOverflow = TextOverflow.ellipsis,
    this.spacing = 8,
    this.isRequired = false,
    this.labelTextAlign,
    this.valueTextAlign,
    this.valueMaxLines,
    super.key,
  })  : assert(
          label != null || labelWidget != null,
          'Either label or label widget must be provided',
        ),
        assert(
          value != null || child != null,
          'Either value or child must be provided',
        );

  final String? label;
  final String? value;
  final String? currency;
  final EdgeInsetsGeometry? padding;
  final bool isRequired;
  final Widget? child;
  final Widget? labelWidget;
  final TextStyle? labelTextStyle;
  final TextStyle? valueTextStyle;
  final double spacing;
  final int labelMaxLines;
  final TextOverflow labelTextOverflow;
  final TextOverflow valueTextOverflow;
  final int labelFlex;
  final int valueFlex;
  final FlexFit labelFit;
  final FlexFit valueFit;
  final TextAlign? labelTextAlign;
  final TextAlign? valueTextAlign;
  final int? valueMaxLines;

  @override
  Widget build(BuildContext context) => ConditionalWidget(
        conditionBuilder: (child) => Padding(
          padding: padding!,
          child: child,
        ),
        condition: padding != null && padding != EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: labelFlex,
              fit: labelFit,
              child: labelWidget ??
                  _DefaultLabelWidget(
                    label: label,
                    isRequired: isRequired,
                    textStyle: labelTextStyle,
                    maxLines: labelMaxLines,
                    textOverflow: labelTextOverflow,
                  ),
            ),
            SizedBox(
              height: spacing,
            ),
            Flexible(
              flex: valueFlex,
              fit: valueFit,
              child: child ??
                  _DefaultValueWidget(
                    value: value,
                    isRequired: isRequired,
                    textStyle: valueTextStyle,
                    maxLines: valueMaxLines,
                    textOverflow: valueTextOverflow,
                    textAlign: valueTextAlign,
                    currency: currency,
                  ),
            ),
          ],
        ),
      );
}

class _DefaultLabelWidget extends StatelessWidget {
  const _DefaultLabelWidget({
    this.label,
    this.textStyle,
    this.isRequired = false,
    this.maxLines = 1,
    this.textAlign,
    this.textOverflow = TextOverflow.ellipsis,
    super.key,
  });

  final String? label;
  final TextStyle? textStyle;
  final bool isRequired;
  final int maxLines;
  final TextOverflow textOverflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => AppText(
        label ?? '',
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: textStyle ??
            Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
        isRequired: isRequired,
        textAlign: textAlign,
      );
}

class _DefaultValueWidget extends StatelessWidget {
  const _DefaultValueWidget({
    this.value,
    this.textStyle,
    this.currency,
    this.textAlign,
    this.isRequired = false,
    this.maxLines,
    this.textOverflow = TextOverflow.ellipsis,
    super.key,
  });

  final String? value;
  final TextStyle? textStyle;
  final bool isRequired;
  final int? maxLines;
  final TextOverflow textOverflow;
  final String? currency;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => currency != null
      ? AppPriceText(
          double.tryParse(value ?? '0') ?? 0,
          currency: currency!,
          maxLines: maxLines,
          overflow: textOverflow,
          textAlign: textAlign,
          style: textStyle ??
              Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
          isRequired: isRequired,
        )
      : AppText(
          value ?? '',
          maxLines: maxLines,
          overflow: textOverflow,
          textAlign: textAlign,
          style: textStyle ??
              Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
          isRequired: isRequired,
        );
}
