import 'package:flutter/material.dart';
import 'package:flyksoft_ui/src/theme/flyksoft_theme.dart';

import '../../../../localization/flyksoft_ui_localization.dart';
import '../../../../widgets/app_text_field.dart';
import '../../../../widgets/not_found_widget.dart';
import 'default_single_selection_tile.dart';
import 'single_selection_base_widgets.dart';
import 'single_selection_states.dart';

class SelectionListWidget<T> extends SingleSelectionLocalWidget<T> {
  const SelectionListWidget({
    required super.itemOptions,
    required super.onChanged,
    required super.items,
    super.selectionSettings,
    super.value,
    super.key,
  });

  @override
  State<SelectionListWidget<T>> createState() => _ListWidgetState<T>();
}

class _ListWidgetState<T> extends State<SelectionListWidget<T>>
    with SingleSelectionLocalState<T, SelectionListWidget<T>> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final horizontalPadding =
        FlyksoftTheme.of(context)?.horizontalPaddingValue ?? 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.selectionSettings.showSearch)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: horizontalPadding,
              end: horizontalPadding,
              bottom: 8,
            ),
            child: AppTextField(
              hintText: FlyksoftUILocalization.of(context).search,
              controller: _searchController,
              onChanged: (final query) => debouncer.debounce(
                () => filter(query ?? ''),
              ),
            ),
          ),
        Flexible(
          child: ValueListenableBuilder(
            valueListenable: query,
            builder: (
              context,
              _,
              child,
            ) =>
                filteredItems.isNotEmpty
                    ? Scrollbar(
                        child: ListView.separated(
                          controller: widget.selectionSettings.scrollController,
                          itemCount: filteredItems.length,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          separatorBuilder: (final context, final index) =>
                              Divider(
                            indent: horizontalPadding,
                            endIndent: horizontalPadding,
                            height: 1,
                          ),
                          itemBuilder: (final context, final index) {
                            final T item = filteredItems.elementAt(index);
                            return InkWell(
                              onTap: () => onSelect(context, item),
                              child:
                                  widget.itemOptions.itemBuilder?.call(item) ??
                                      DefaultSingleSelectionTile<T>(
                                        item: item,
                                        isSelected: widget.value == item,
                                        itemAsString: (item) =>
                                            widget.itemOptions.itemAsString
                                                ?.call(item) ??
                                            '',
                                      ),
                            );
                          },
                        ),
                      )
                    : NotFoundWidget(
                        itemName: widget.selectionSettings.itemName,
                        padding: const EdgeInsets.only(
                          left: 32,
                          right: 32,
                          top: 16,
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}
