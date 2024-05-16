import 'package:flutter/material.dart';

import '../../../flyksoft_ui.dart';
import '../../models/picker_condition_model.dart';
import '../../utils/conditional_picker_mixin.dart';
import 'app_form_state.dart';

class AppDropdown<T> extends AppStatefulFormWidget<T> {
  const AppDropdown({
    required this.onChanged,
    required this.itemAsString,
    required this.dataSource,
    super.value,
    this.border,
    this.textStyle,
    this.validator,
    this.padding,
    this.selectionItemBuilder,
    this.conditionBuilder,
    this.decoration,
    this.borderRadius,
    this.defaultValue,
    this.useRootNavigator = false,
    this.showClearIcon = true,
    this.height = 48,
    this.selectionSettings = const SelectionSheetSettings(),
    this.enabled = true,
    this.flexFit = FlexFit.tight,
    this.hintText,
    this.mainAxisSize = MainAxisSize.max,
    super.key,
  });

  final SelectionDataSource<T> dataSource;
  final void Function(T? item) onChanged;
  final String? Function(T? item) itemAsString;
  final TextStyle? textStyle;
  final String? Function(String? value)? validator;
  final String? hintText;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final FlexFit flexFit;
  final bool enabled;
  final Widget Function(T item)? selectionItemBuilder;
  final List<PickerConditionModel> Function()? conditionBuilder;
  final SelectionSheetSettings selectionSettings;
  final BoxBorder? border;
  final double height;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;
  final T? defaultValue;
  final bool showClearIcon;
  final bool useRootNavigator;

  @override
  AppFormState<AppDropdown<T>, T> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends AppFormState<AppDropdown<T>, T>
    with ConditionalPickerMixin {
  void _showSelectionBottomSheet() => SelectionSheet<T>(
        dataSource: widget.dataSource,
        onChanged: widget.onChanged,
        selectionSettings: widget.selectionSettings,
        value: widget.value,
        itemViewOptions: SelectionItemViewOptions(
          itemAsString: widget.itemAsString,
          itemBuilder: widget.selectionItemBuilder,
        ),
      ).show(
        context,
        useRootNavigator: widget.useRootNavigator,
      );

  @override
  Widget build(final BuildContext context) => DropdownForm<T>(
        onTap: widget.enabled ? maybeShowPicker : null,
        itemAsString: widget.itemAsString,
        validator: widget.validator,
        border: widget.border,
        mainAxisSize: widget.mainAxisSize,
        padding: widget.padding,
        hintText: widget.hintText,
        textStyle: widget.textStyle,
        value: widget.value,
        key: formFieldKey,
        height: widget.height,
        decoration: widget.decoration,
        borderRadius: widget.borderRadius,
        fillColor: widget.enabled
            ? Theme.of(context).colorScheme.surfaceVariant
            : Theme.of(context).disabledColor,
        onClear: () => widget.onChanged(widget.defaultValue),
        defaultValue: widget.defaultValue,
        showClearIcon: widget.showClearIcon,
      );

  @override
  List<PickerConditionModel> Function()? get conditionBuilder =>
      widget.conditionBuilder;

  @override
  void showPicker() => _showSelectionBottomSheet();
}

class DropdownForm<T> extends FormField<T> {
  final T? value;
  final String? Function(T? item) itemAsString;
  final TextStyle? textStyle;
  final String? hintText;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final BoxBorder? border;
  final double height;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;
  final void Function()? onTap;
  final void Function()? onClear;
  final T? defaultValue;
  final bool showClearIcon;

  DropdownForm({
    required this.itemAsString,
    this.border,
    this.value,
    this.onTap,
    this.onClear,
    this.textStyle,
    this.padding,
    this.fillColor,
    this.decoration,
    this.borderRadius,
    this.defaultValue,
    this.showClearIcon = true,
    this.height = 48,
    this.hintText,
    this.mainAxisSize = MainAxisSize.max,
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
              ? _NormalDropdown(
                  itemAsString: itemAsString,
                  value: value,
                  padding: padding,
                  border: border,
                  hintText: hintText,
                  mainAxisSize: mainAxisSize,
                  textStyle: textStyle,
                  fillColor: fillColor,
                  onTap: onTap,
                  height: height,
                  decoration: decoration,
                  borderRadius: borderRadius,
                  onClear: onClear,
                  defaultValue: defaultValue,
                  showClearIcon: showClearIcon,
                )
              : _NormalFormDropdown(
                  itemAsString: itemAsString,
                  value: value,
                  padding: padding,
                  border: border,
                  hintText: hintText,
                  mainAxisSize: mainAxisSize,
                  textStyle: textStyle,
                  errorText: field.errorText,
                  hasError: field.hasError,
                  fillColor: fillColor,
                  onTap: onTap,
                  height: height,
                  decoration: decoration,
                  borderRadius: borderRadius,
                  onClear: onClear,
                  defaultValue: defaultValue,
                  showClearIcon: showClearIcon,
                ),
        );
}

class _NormalFormDropdown<T> extends StatefulWidget {
  const _NormalFormDropdown({
    required this.itemAsString,
    this.value,
    this.onTap,
    this.onClear,
    this.textStyle,
    this.padding,
    this.hasError = false,
    this.errorText,
    this.fillColor,
    this.border,
    this.decoration,
    this.borderRadius,
    this.defaultValue,
    this.showClearIcon = true,
    this.height = 48,
    this.hintText,
    this.mainAxisSize = MainAxisSize.max,
    super.key,
  });

  final T? value;
  final String? Function(T? item) itemAsString;
  final TextStyle? textStyle;
  final String? hintText;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final bool hasError;
  final String? errorText;
  final Color? fillColor;
  final BoxBorder? border;
  final void Function()? onTap;
  final double height;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;
  final void Function()? onClear;
  final T? defaultValue;
  final bool showClearIcon;

  @override
  State<_NormalFormDropdown<T>> createState() => _NormalFormDropdownState<T>();
}

class _NormalFormDropdownState<T> extends State<_NormalFormDropdown<T>>
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
  void didUpdateWidget(_NormalFormDropdown<T> old) {
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
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NormalDropdown(
            border: widget.border,
            itemAsString: widget.itemAsString,
            value: widget.value,
            padding: widget.padding,
            hintText: widget.hintText,
            mainAxisSize: widget.mainAxisSize,
            textStyle: widget.textStyle,
            fillColor: widget.fillColor,
            onTap: widget.onTap,
            height: widget.height,
            decoration: widget.decoration,
            borderRadius: widget.borderRadius,
            onClear: widget.onClear,
            defaultValue: widget.defaultValue,
            showClearIcon: widget.showClearIcon,
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
                      start: widget.padding?.horizontal ?? 10,
                      end: widget.padding?.horizontal ?? 10,
                    ),
                    child: Text(
                      widget.errorText!,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
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

class _NormalDropdown<T> extends StatelessWidget {
  const _NormalDropdown({
    required this.itemAsString,
    this.value,
    this.onTap,
    this.onClear,
    this.textStyle,
    this.padding,
    this.fillColor,
    this.border,
    this.decoration,
    this.borderRadius,
    this.defaultValue,
    this.showClearIcon = true,
    this.height = 48,
    this.hintText,
    this.mainAxisSize = MainAxisSize.max,
    super.key,
  });

  final T? value;
  final String? Function(T? item) itemAsString;
  final TextStyle? textStyle;
  final String? hintText;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final BoxBorder? border;
  final double height;
  final void Function()? onTap;
  final void Function()? onClear;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;
  final T? defaultValue;
  final bool showClearIcon;

  @override
  Widget build(BuildContext context) {
    final String? itemName = itemAsString(value);
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius ??
          const BorderRadius.all(
            Radius.circular(
              8,
            ),
          ),
      child: Container(
        height: height,
        decoration: decoration ??
            BoxDecoration(
              borderRadius: borderRadius ??
                  const BorderRadius.all(
                    Radius.circular(
                      8,
                    ),
                  ),
              border: border ??
                  Border.fromBorderSide(
                    BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),
              color: fillColor,
            ),
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 11,
              horizontal: 10,
            ),
        child: Row(
          mainAxisSize: mainAxisSize,
          children: [
            Expanded(
              child: AppText(
                _canShowValue(itemName)
                    ? itemName!
                    : (hintText ?? FlyksoftUILocalization.of(context).select),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: (_canShowValue(itemName)
                    ? (textStyle ?? Theme.of(context).textTheme.bodyLarge)
                    : _labelStyle(context)),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            if (showClearIcon && value != defaultValue && onClear != null) ...[
              IconButton(
                visualDensity: VisualDensity.compact,
                splashRadius: 8,
                padding: EdgeInsets.zero,
                iconSize: 16,
                constraints: const BoxConstraints(),
                onPressed: onClear,
                icon: const Icon(
                  Icons.clear_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                width: 8,
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

  TextStyle? _labelStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.normal,
          );
}
