import 'package:flutter/material.dart';
import 'package:flyksoft_ui/src/utils/snack_bar_utils.dart';

import '../models/picker_condition_model.dart';

mixin ConditionalPickerMixin<T extends StatefulWidget> on State<T> {
  void showPicker();

  List<PickerConditionModel> Function()? get conditionBuilder;

  void maybeShowPicker() {
    if (conditionBuilder != null) {
      final List<PickerConditionModel> pickerConditions = conditionBuilder!();
      for (final PickerConditionModel condition in pickerConditions) {
        if (!condition.condition) {
          if (condition.failureMessage != null &&
              condition.failureMessage!.isNotEmpty) {
            SnackBarUtils.showSnackBarFailure(
              context: context,
              message: condition.failureMessage!,
            );
          }
          return;
        }
      }
    }
    showPicker();
  }
}
