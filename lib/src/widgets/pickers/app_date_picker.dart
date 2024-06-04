import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../flyksoft_ui.dart';
import '../../utils/conditional_picker_mixin.dart';
import '../dropdowns/dropdown_form_widget.dart';

class AppDatePicker extends AppStatefulFormWidget<DateTime> {
  const AppDatePicker({
    required this.onChanged,
    super.value,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.formatter,
    this.selectableDayPredicate,
    this.conditionBuilder,
    this.defaultValue,
    this.style,
    this.enabled = true,
    this.hintText,
    super.key,
  });

  final void Function(DateTime? value) onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(String? value)? validator;
  final String? hintText;
  final String Function(DateTime dateTime)? formatter;
  final bool enabled;
  final bool Function(DateTime day)? selectableDayPredicate;
  final List<PickerConditionModel> Function()? conditionBuilder;
  final DateTime? defaultValue;
  final AppDropdownThemeData? style;

  @override
  AppFormState<AppDatePicker, DateTime> createState() =>
      _AppDatePickerV2State();
}

class _AppDatePickerV2State extends AppFormState<AppDatePicker, DateTime>
    with ConditionalPickerMixin {
  @override
  Widget build(final BuildContext context) => DropdownFormWidget<DateTime>(
        itemAsString: (item) => item != null
            ? widget.formatter?.call(item) ?? DateFormat.yMMMd().format(item)
            : null,
        onTap: widget.enabled ? maybeShowPicker : null,
        validator: widget.validator,
        hintText: widget.hintText,
        value: widget.value,
        key: formFieldKey,
        onClear: () => widget.onChanged(widget.defaultValue),
        defaultValue: widget.defaultValue,
        style: widget.style,
        enabled: widget.enabled,
      );

  Future<void> _showDatePicker() async {
    final date = widget.value ?? DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: widget.firstDate ??
          DateTime.now().subtract(
            const Duration(
              days: 365 * 100,
            ),
          ),
      lastDate: widget.lastDate ??
          DateTime.now().add(
            const Duration(
              days: 365 * 100,
            ),
          ),
      currentDate: date,
      initialDate: date,
      selectableDayPredicate: widget.selectableDayPredicate,
      locale: Localizations.localeOf(context),
    );
    if (selectedDate != null) {
      widget.onChanged(selectedDate);
    }
  }

  @override
  List<PickerConditionModel> Function()? get conditionBuilder =>
      widget.conditionBuilder;

  @override
  void showPicker() => _showDatePicker();
}
