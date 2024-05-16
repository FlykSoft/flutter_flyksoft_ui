import 'package:flutter/material.dart';

import '../../../flyksoft_ui.dart';
import '../../models/picker_condition_model.dart';
import '../../utils/conditional_picker_mixin.dart';

class AppTimePicker extends AppStatefulFormWidget<TimeOfDay> {
  const AppTimePicker({
    required this.onChanged,
    super.value,
    this.validator,
    this.mainAxisSize = MainAxisSize.max,
    this.flexFit = FlexFit.tight,
    this.textStyle,
    this.formatter,
    this.padding,
    this.conditionBuilder,
    this.defaultValue,
    this.showClearIcon = true,
    this.enabled = true,
    this.hintText,
    super.key,
  });

  final void Function(TimeOfDay? value) onChanged;
  final String? Function(String? value)? validator;
  final String? hintText;
  final String Function(TimeOfDay time)? formatter;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final FlexFit flexFit;
  final TextStyle? textStyle;
  final bool enabled;
  final List<PickerConditionModel> Function()? conditionBuilder;
  final TimeOfDay? defaultValue;
  final bool showClearIcon;

  @override
  AppFormState<AppTimePicker, TimeOfDay> createState() => _AppTimePickerState();
}

class _AppTimePickerState extends AppFormState<AppTimePicker, TimeOfDay>
    with ConditionalPickerMixin {
  @override
  Widget build(final BuildContext context) => DropdownForm<TimeOfDay>(
        itemAsString: (item) => item != null
            ? widget.formatter?.call(item) ?? item.format(context)
            : null,
        validator: widget.validator,
        onTap: widget.enabled ? maybeShowPicker : null,
        mainAxisSize: widget.mainAxisSize,
        padding: widget.padding,
        hintText: widget.hintText,
        textStyle: widget.textStyle,
        value: widget.value,
        key: formFieldKey,
        fillColor: widget.enabled
            ? Theme.of(context).colorScheme.surfaceVariant
            : Theme.of(context).disabledColor,
        onClear: () => widget.onChanged(widget.defaultValue),
        defaultValue: widget.defaultValue,
        showClearIcon: widget.showClearIcon,
      );

  Future<void> _showTimePicker() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: widget.value ?? TimeOfDay.now(),
    );
    if (time != null) {
      widget.onChanged(time);
    }
  }

  @override
  List<PickerConditionModel> Function()? get conditionBuilder =>
      widget.conditionBuilder;

  @override
  void showPicker() => _showTimePicker();
}
