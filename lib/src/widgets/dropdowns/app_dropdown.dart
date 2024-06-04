import 'package:flutter/material.dart';

import '../../../flyksoft_ui.dart';
import '../../utils/conditional_picker_mixin.dart';
import 'dropdown_form_widget.dart';

class AppDropdown<T> extends AppStatefulFormWidget<T> {
  const AppDropdown({
    required this.onChanged,
    required this.itemAsString,
    required this.dataSource,
    super.value,
    this.validator,
    this.selectionItemBuilder,
    this.conditionBuilder,
    this.defaultValue,
    this.useRootNavigator = false,
    this.selectionSettings = const SelectionSheetSettings(),
    this.enabled = true,
    this.hintText,
    this.style,
    super.key,
  });

  final SelectionDataSource<T> dataSource;
  final void Function(T? item) onChanged;
  final String? Function(T? item) itemAsString;
  final String? Function(String? value)? validator;
  final String? hintText;
  final bool enabled;
  final Widget Function(T item)? selectionItemBuilder;
  final List<PickerConditionModel> Function()? conditionBuilder;
  final SelectionSheetSettings selectionSettings;
  final T? defaultValue;
  final bool useRootNavigator;
  final AppDropdownThemeData? style;

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
  Widget build(final BuildContext context) => DropdownFormWidget<T>(
        onTap: widget.enabled ? maybeShowPicker : null,
        itemAsString: widget.itemAsString,
        validator: widget.validator,
        hintText: widget.hintText,
        value: widget.value,
        key: formFieldKey,
        onClear: () => widget.onChanged(widget.defaultValue),
        defaultValue: widget.defaultValue,
        enabled: widget.enabled,
        style: widget.style,
      );

  @override
  List<PickerConditionModel> Function()? get conditionBuilder =>
      widget.conditionBuilder;

  @override
  void showPicker() => _showSelectionBottomSheet();
}
