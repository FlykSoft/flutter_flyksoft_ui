import 'package:flutter/material.dart';
import 'package:flyksoft_ui/src/theme/flyksoft_theme.dart';

import '../../../../widgets/app_text.dart';

class DefaultSingleSelectionTile<T> extends StatelessWidget {
  const DefaultSingleSelectionTile({
    required this.item,
    required this.itemAsString,
    this.isSelected = false,
    super.key,
  });

  final bool isSelected;
  final T item;
  final String Function(T item) itemAsString;

  @override
  Widget build(final BuildContext context) => ColoredBox(
        color: isSelected
            ? Theme.of(context).primaryColorLight
            : Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 24,
            horizontal: FlyksoftTheme.of(context)?.horizontalPaddingValue ?? 0,
          ),
          child: AppText.bodyMedium(
            itemAsString(item),
          ),
        ),
      );
}
