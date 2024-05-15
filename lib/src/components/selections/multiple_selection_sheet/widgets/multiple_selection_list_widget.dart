import 'package:flutter/material.dart';
import 'package:flyksoft_ui/src/theme/flyksoft_theme.dart';

import '../../../../localization/flyksoft_ui_localization.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text_field.dart';
import '../../../../widgets/not_found_widget.dart';
import '../../selection/models/selection_sheet_settings.dart';
import 'default_multiple_selection_tile.dart';
import 'multiple_selection_base_widgets.dart';
import 'multiple_selection_states.dart';

class MultipleSelectionListWidget<T> extends MultipleSelectionLocalWidget<T> {
  const MultipleSelectionListWidget({
    required super.items,
    required super.onChanged,
    required super.itemViewOptions,
    super.values = const [],
    super.selectionSettings = const SelectionSheetSettings(),
    super.key,
  });

  @override
  State<MultipleSelectionListWidget<T>> createState() =>
      _MultipleSelectionListWidgetState<T>();
}

class _MultipleSelectionListWidgetState<T>
    extends State<MultipleSelectionListWidget<T>>
    with MultipleSelectionLocalState<T, MultipleSelectionListWidget<T>> {
  @override
  Widget build(final BuildContext context) {
    final horizontalPaddingValue =
        FlyksoftTheme.of(context)?.horizontalPaddingValue ?? 0;
    return Column(
      children: [
        if (widget.selectionSettings.showSearch)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: FlyksoftTheme.of(context)?.horizontalPaddingValue ?? 0,
              end: FlyksoftTheme.of(context)?.horizontalPaddingValue ?? 0,
              bottom: 8,
            ),
            child: AppTextField(
              hintText: FlyksoftUILocalization.of(context).search,
              onChanged: (final query) => debouncer.debounce(
                () => filter(query ?? ''),
              ),
            ),
          ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: query,
            builder: (context, _, child) => filteredItems.isNotEmpty
                ? Scrollbar(
                    child: ListView.separated(
                      controller: widget.selectionSettings.scrollController,
                      itemCount: filteredItems.length,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      separatorBuilder: (final context, final index) => Divider(
                        indent: horizontalPaddingValue,
                        endIndent: horizontalPaddingValue,
                        height: 1,
                      ),
                      itemBuilder: (final context, final index) {
                        final T item = filteredItems.elementAt(index);
                        return InkWell(
                          onTap: () => onItemSelectionChanged(
                            item,
                            index,
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: valueNotifiers.elementAt(index),
                            builder: (context, value, child) =>
                                widget.itemViewOptions.itemBuilder
                                    ?.call(item) ??
                                DefaultMultipleSelectionTile<T>(
                                  item: item,
                                  itemAsString:
                                      widget.itemViewOptions.itemAsString!,
                                  isSelected: value,
                                  onChanged: (
                                    item, {
                                    required value,
                                  }) =>
                                      onItemSelectionChanged(
                                    item,
                                    index,
                                    value: value,
                                  ),
                                ),
                          ),
                        );
                      },
                    ),
                  )
                : NotFoundWidget(
                    itemName: widget.selectionSettings.itemName,
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPaddingValue,
            vertical: 8,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  onPressed: Navigator.of(context).pop,
                  text: FlyksoftUILocalization.of(context).cancel,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: AppButton.filled(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Future(
                      () => widget.onChanged(selectedItems),
                    );
                  },
                  text: FlyksoftUILocalization.of(context).save,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
