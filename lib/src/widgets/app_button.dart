import 'package:flutter/material.dart';

import 'app_text.dart';
import 'loading_widget.dart';

class AppButton extends StatefulWidget {
  /// Specifies the text of button.
  final String? text;

  final bool showLoading;
  final Widget? startIcon;
  final Widget? endIcon;
  final Widget? progressIndicator;
  final Color? progressIndicatorColor;
  final ButtonStyle? style;
  final ButtonType type;
  final TextStyle? textStyle;
  final void Function()? onPressed;
  final void Function()? onLongPressed;
  final Widget? child;
  final double iconSpacing;

  const AppButton({
    required this.onPressed,
    this.progressIndicator,
    this.progressIndicatorColor,
    this.onLongPressed,
    this.text,
    this.style,
    this.textStyle,
    this.type = ButtonType.filled,
    this.showLoading = false,
    this.endIcon,
    this.startIcon,
    this.child,
    this.iconSpacing = 8,
    super.key,
  });

  factory AppButton.flat({
    required final void Function()? onPressed,
    final String? text,
    final bool showLoading = false,
    final Widget? progressIndicator,
    final Color? progressIndicatorColor,
    final Widget? startIcon,
    final Widget? endIcon,
    final ButtonStyle? style,
    final TextStyle? textStyle,
    final Widget? child,
    final void Function()? onLongPressed,
    final double iconSpacing = _defaultIconSpacing,
    final Key? key,
  }) =>
      AppButton(
        text: text,
        onPressed: onPressed,
        progressIndicator: progressIndicator,
        progressIndicatorColor: progressIndicatorColor,
        onLongPressed: onLongPressed,
        style: style,
        type: ButtonType.flat,
        showLoading: showLoading,
        key: key,
        textStyle: textStyle,
        endIcon: endIcon,
        startIcon: startIcon,
        iconSpacing: iconSpacing,
        child: child,
      );

  factory AppButton.outlined({
    required final void Function()? onPressed,
    final String? text,
    final bool showLoading = false,
    final Widget? startIcon,
    final Color? progressIndicatorColor,
    final Widget? progressIndicator,
    final Widget? endIcon,
    final ButtonStyle? style,
    final TextStyle? textStyle,
    final Widget? child,
    final void Function()? onLongPressed,
    final double iconSpacing = _defaultIconSpacing,
    final Key? key,
  }) =>
      AppButton(
        text: text,
        onPressed: onPressed,
        progressIndicatorColor: progressIndicatorColor,
        progressIndicator: progressIndicator,
        onLongPressed: onLongPressed,
        style: style,
        textStyle: textStyle,
        type: ButtonType.outlined,
        showLoading: showLoading,
        key: key,
        endIcon: endIcon,
        startIcon: startIcon,
        iconSpacing: iconSpacing,
        child: child,
      );

  factory AppButton.filled({
    required final void Function()? onPressed,
    final String? text,
    final bool showLoading = false,
    final Widget? startIcon,
    final Widget? endIcon,
    final Color? progressIndicatorColor,
    final Widget? progressIndicator,
    final ButtonStyle? style,
    final TextStyle? textStyle,
    final Widget? child,
    final double iconSpacing = _defaultIconSpacing,
    final Key? key,
    final void Function()? onLongPressed,
  }) =>
      AppButton(
        text: text,
        textStyle: textStyle,
        progressIndicatorColor: progressIndicatorColor,
        onPressed: onPressed,
        progressIndicator: progressIndicator,
        onLongPressed: onLongPressed,
        style: style,
        type: ButtonType.filled,
        showLoading: showLoading,
        key: key,
        endIcon: endIcon,
        startIcon: startIcon,
        iconSpacing: iconSpacing,
        child: child,
      );
  static const double _defaultIconSpacing = 8;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(final BuildContext context) {
    switch (widget.type) {
      case ButtonType.filled:
        return ElevatedButton(
          onPressed: !widget.showLoading ? widget.onPressed : () {},
          onLongPress: !widget.showLoading ? widget.onLongPressed : () {},
          style: _getFilledStyle(context),
          child: widget.child ?? _child(),
        );
      case ButtonType.flat:
        return TextButton(
          onPressed: !widget.showLoading ? widget.onPressed : () {},
          onLongPress: !widget.showLoading ? widget.onLongPressed : () {},
          style: _getFlatStyle(context),
          child: widget.child ?? _child(),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: !widget.showLoading ? widget.onPressed : null,
          onLongPress: !widget.showLoading ? widget.onLongPressed : null,
          style: _getOutlinedStyle(context),
          child: widget.child ?? _child(),
        );
    }
  }

  Widget _child() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.startIcon != null) ...[
            widget.startIcon!,
            SizedBox(
              width: widget.iconSpacing,
            ),
          ],
          if (!widget.showLoading)
            _ButtonChild(
              type: widget.type,
              textStyle: widget.textStyle,
              text: widget.text,
              isEnabled: widget.onPressed != null,
              child: widget.child,
            )
          else
            _progressIndicator(),
          if (widget.endIcon != null) ...[
            SizedBox(
              width: widget.iconSpacing,
            ),
            widget.endIcon!
          ],
        ],
      );

  ButtonStyle? _getFilledStyle(final BuildContext context) =>
      widget.style ?? Theme.of(context).elevatedButtonTheme.style;

  ButtonStyle? _getOutlinedStyle(final BuildContext context) {
    if (widget.style != null) {
      return widget.style;
    }
    final style = Theme.of(context).outlinedButtonTheme.style;
    return style?.copyWith(
      side: MaterialStateProperty.resolveWith(
        (states) => style.side
            ?.resolve(states.isEmpty ? {MaterialState.selected} : states)
            ?.copyWith(
              color: states.contains(MaterialState.disabled)
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).colorScheme.primary,
            ),
      ),
      textStyle: MaterialStateProperty.resolveWith(
        (states) {
          final textStyle = widget.textStyle ??
              style.textStyle
                  ?.resolve(states.isEmpty ? {MaterialState.selected} : states);
          return textStyle?.copyWith(
            color: states.contains(MaterialState.disabled)
                ? Theme.of(context).disabledColor
                : Theme.of(context).colorScheme.primary,
          );
        },
      ),
    );
  }

  ButtonStyle? _getFlatStyle(final BuildContext context) =>
      widget.style ?? TextButtonTheme.of(context).style;

  Widget _progressIndicator() => Row(
        children: [
          AnimatedContainer(
            key: UniqueKey(),
            width: 16,
            duration: const Duration(milliseconds: 1000),
          ),
          if (widget.progressIndicator == null)
            LoadingWidget(
              size: 30,
              color: widget.type == ButtonType.filled
                  ? Theme.of(context).colorScheme.onPrimary
                  : widget.type == ButtonType.outlined
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary,
            )
          else
            widget.progressIndicator!,
        ],
      );
}

enum ButtonType { filled, outlined, flat }

class _ButtonChild extends StatelessWidget {
  const _ButtonChild({
    required this.type,
    this.text,
    this.child,
    this.textStyle,
    this.isEnabled = true,
    super.key,
  });

  final String? text;
  final Widget? child;
  final TextStyle? textStyle;
  final ButtonType type;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) => child != null
      ? child!
      : AppText(
          text ?? '',
          style: textStyle ?? _textStyle(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );

  TextStyle? _textStyle(BuildContext context) {
    switch (type) {
      case ButtonType.filled:
        return Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve(
          {if (isEnabled) MaterialState.selected else MaterialState.disabled},
        );
      case ButtonType.outlined:
        return Theme.of(context).outlinedButtonTheme.style?.textStyle?.resolve(
          {if (isEnabled) MaterialState.selected else MaterialState.disabled},
        );
      case ButtonType.flat:
        return Theme.of(context).textButtonTheme.style?.textStyle?.resolve(
          {if (isEnabled) MaterialState.selected else MaterialState.disabled},
        );
    }
  }
}
