import 'package:flutter/material.dart';

import '../../../../theme/flyksoft_theme.dart';
import '../../../../widgets/app_text.dart';

class DefaultMultipleSelectionTile<T> extends StatelessWidget {
  const DefaultMultipleSelectionTile({
    required this.item,
    required this.onChanged,
    required this.itemAsString,
    this.isSelected = false,
    super.key,
  });

  final T item;
  final void Function(T item, {required bool value}) onChanged;
  final String? Function(T item) itemAsString;
  final bool isSelected;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: FlyksoftTheme.of(context)?.horizontalPaddingValue ?? 0,
        ),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (value) => onChanged(item, value: value ?? false),
            ),
            Expanded(
              child: AppText.bodyMedium(
                itemAsString(item) ?? '',
              ),
            ),
          ],
        ),
      );
}
