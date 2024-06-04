import 'package:flutter/material.dart';

import '../../../flyksoft_ui.dart';

class DropdownFormWidget<T> extends FormField<T> {
  final T? value;
  final String? Function(T? item) itemAsString;
  final String? hintText;
  final void Function()? onTap;
  final void Function()? onClear;
  final T? defaultValue;
  final AppDropdownThemeData? style;

  DropdownFormWidget({
    required this.itemAsString,
    this.value,
    this.onTap,
    this.onClear,
    this.defaultValue,
    this.hintText,
    this.style,
    super.enabled = true,
    final String? Function(String? value)? validator,
    super.initialValue,
    super.onSaved,
    super.autovalidateMode,
    super.key,
  }) : super(
          validator: validator != null
              ? (item) => validator(item != null ? itemAsString(item) : '')
              : null,
          builder: (field) => validator == null
              ? _DropdownBody(
                  itemAsString: itemAsString,
                  value: value,
                  hintText: hintText,
                  onTap: onTap,
                  onClear: onClear,
                  defaultValue: defaultValue,
                  enabled: enabled,
                  style: style,
                )
              : _DropdownBodyWithForm(
                  itemAsString: itemAsString,
                  value: value,
                  hintText: hintText,
                  errorText: field.errorText,
                  hasError: field.hasError,
                  onTap: onTap,
                  onClear: onClear,
                  defaultValue: defaultValue,
                  enabled: enabled,
                  style: style,
                ),
        );
}

class _DropdownBodyWithForm<T> extends StatefulWidget {
  const _DropdownBodyWithForm({
    required this.itemAsString,
    this.value,
    this.onTap,
    this.onClear,
    this.hasError = false,
    this.errorText,
    this.defaultValue,
    this.hintText,
    this.style,
    this.enabled = true,
    super.key,
  });

  final T? value;
  final String? Function(T? item) itemAsString;
  final String? hintText;
  final bool hasError;
  final String? errorText;
  final void Function()? onTap;
  final void Function()? onClear;
  final T? defaultValue;
  final bool enabled;
  final AppDropdownThemeData? style;

  @override
  State<_DropdownBodyWithForm<T>> createState() =>
      _DropdownBodyWithFormState<T>();
}

class _DropdownBodyWithFormState<T> extends State<_DropdownBodyWithForm<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 167),
      vsync: this,
    );
    if (_hasError) {
      _controller.value = 1.0;
    }
    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_DropdownBodyWithForm<T> old) {
    super.didUpdateWidget(old);

    final String? newErrorText = widget.errorText;
    final String? oldErrorText = old.errorText;

    final bool errorTextStateChanged =
        (newErrorText != null) != (oldErrorText != null);

    if (errorTextStateChanged) {
      if (newErrorText != null) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  bool get _hasError => widget.errorText != null && widget.hasError;

  void _handleChange() {
    setState(() {
      // The _controller's value has changed.
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = widget.style ??
        FlyksoftTheme.of(context)?.appDropdownThemeData ??
        const AppDropdownThemeData();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DropdownBody(
          itemAsString: widget.itemAsString,
          value: widget.value,
          hintText: widget.hintText,
          onTap: widget.onTap,
          onClear: widget.onClear,
          defaultValue: widget.defaultValue,
          enabled: widget.enabled,
          style: widget.style,
        ),
        if (_hasError)
          Semantics(
            container: true,
            child: FadeTransition(
              opacity: _controller,
              child: FractionalTranslation(
                translation: Tween<Offset>(
                  begin: const Offset(0.0, -0.25),
                  end: Offset.zero,
                ).evaluate(_controller.view),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: 8,
                    start: effectiveStyle.padding.horizontal,
                    end: effectiveStyle.padding.horizontal,
                  ),
                  child: Text(
                    widget.errorText!,
                    style: effectiveStyle.effectiveErrorTextStyle(
                      Theme.of(
                        context,
                      ),
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DropdownBody<T> extends StatelessWidget {
  const _DropdownBody({
    required this.itemAsString,
    this.value,
    this.onTap,
    this.onClear,
    this.defaultValue,
    this.hintText,
    this.style,
    this.enabled = true,
    super.key,
  });

  final T? value;
  final String? Function(T? item) itemAsString;
  final String? hintText;
  final void Function()? onTap;
  final void Function()? onClear;
  final T? defaultValue;
  final bool enabled;
  final AppDropdownThemeData? style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ??
        FlyksoftTheme.of(context)?.appDropdownThemeData ??
        const AppDropdownThemeData();
    final themeData = Theme.of(context);
    final String? itemName = itemAsString(value);
    return InkWell(
      onTap: onTap,
      borderRadius: effectiveStyle.borderRadius,
      child: Container(
        height: effectiveStyle.height,
        decoration: effectiveStyle.effectiveDecoration(
          enabled: enabled,
          themeData: themeData,
        ),
        padding: effectiveStyle.padding,
        child: Row(
          mainAxisSize: effectiveStyle.mainAxisSize,
          children: [
            Expanded(
              child: AppText(
                _canShowValue(itemName)
                    ? itemName!
                    : (hintText ?? FlyksoftUILocalization.of(context).select),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: (_canShowValue(itemName)
                    ? (effectiveStyle.effectiveTextStyle(themeData))
                    : effectiveStyle.effectiveLabelTextStyle(themeData)),
              ),
            ),
            SizedBox(
              width: effectiveStyle.suffixIconSpacing,
            ),
            if (effectiveStyle.showClearIcon &&
                value != defaultValue &&
                onClear != null) ...[
              IconButton(
                visualDensity: VisualDensity.compact,
                splashRadius: 8,
                padding: EdgeInsets.zero,
                iconSize: 16,
                constraints: const BoxConstraints(),
                onPressed: onClear,
                icon: Icon(
                  Icons.clear_outlined,
                  size: effectiveStyle.clearIconSize,
                  color: effectiveStyle.clearIconColor,
                ),
              ),
              SizedBox(
                width: effectiveStyle.suffixIconSpacing,
              ),
            ],
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  bool _canShowValue(String? itemName) =>
      itemName != null && itemName != 'null';
}
