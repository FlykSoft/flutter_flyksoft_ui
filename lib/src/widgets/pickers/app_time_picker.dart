import 'package:flutter/material.dart';

import '../../../flyksoft_ui.dart';
import '../../utils/conditional_picker_mixin.dart';
import '../dropdowns/dropdown_form_widget.dart';

class AppTimePicker extends AppStatefulFormWidget<TimeOfDay> {
  const AppTimePicker({
    required this.onChanged,
    super.value,
    this.validator,
    this.formatter,
    this.conditionBuilder,
    this.defaultValue,
    this.enabled = true,
    this.hintText,
    this.style,
    super.key,
  });

  final void Function(TimeOfDay? value) onChanged;
  final String? Function(String? value)? validator;
  final String? hintText;
  final String Function(TimeOfDay time)? formatter;
  final bool enabled;
  final List<PickerConditionModel> Function()? conditionBuilder;
  final TimeOfDay? defaultValue;
  final AppDropdownThemeData? style;

  @override
  AppFormState<AppTimePicker, TimeOfDay> createState() => _AppTimePickerState();
}

class _AppTimePickerState extends AppFormState<AppTimePicker, TimeOfDay>
    with ConditionalPickerMixin {
  @override
  Widget build(final BuildContext context) => DropdownFormWidget<TimeOfDay>(
        itemAsString: (item) => item != null
            ? widget.formatter?.call(item) ?? item.format(context)
            : null,
        validator: widget.validator,
        onTap: widget.enabled ? maybeShowPicker : null,
        hintText: widget.hintText,
        value: widget.value,
        key: formFieldKey,
        onClear: () => widget.onChanged(widget.defaultValue),
        defaultValue: widget.defaultValue,
        style: widget.style,
        enabled: widget.enabled,
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
