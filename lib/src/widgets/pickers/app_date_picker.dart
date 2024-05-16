import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../flyksoft_ui.dart';
import '../../utils/conditional_picker_mixin.dart';

class AppDatePicker extends AppStatefulFormWidget<DateTime> {
  const AppDatePicker({
    required this.onChanged,
    super.value,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.formatter,
    this.padding,
    this.textStyle,
    this.selectableDayPredicate,
    this.conditionBuilder,
    this.defaultValue,
    this.showClearIcon = true,
    this.enabled = true,
    this.flexFit = FlexFit.tight,
    this.hintText,
    this.mainAxisSize = MainAxisSize.max,
    super.key,
  });

  final void Function(DateTime? value) onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(String? value)? validator;
  final String? hintText;
  final String Function(DateTime dateTime)? formatter;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final FlexFit flexFit;
  final TextStyle? textStyle;
  final bool enabled;
  final bool Function(DateTime day)? selectableDayPredicate;
  final List<PickerConditionModel> Function()? conditionBuilder;
  final DateTime? defaultValue;
  final bool showClearIcon;

  @override
  AppFormState<AppDatePicker, DateTime> createState() =>
      _AppDatePickerV2State();
}

class _AppDatePickerV2State extends AppFormState<AppDatePicker, DateTime>
    with ConditionalPickerMixin {
  @override
  Widget build(final BuildContext context) => DropdownForm<DateTime>(
        itemAsString: (item) => item != null
            ? widget.formatter?.call(item) ?? DateFormat.yMMMd().format(item)
            : null,
        onTap: widget.enabled ? maybeShowPicker : null,
        validator: widget.validator,
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
