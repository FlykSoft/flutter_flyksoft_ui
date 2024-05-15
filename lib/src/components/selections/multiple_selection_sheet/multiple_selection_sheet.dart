import 'package:flutter/material.dart' hide CloseButton;

import '../../../models/auto_size_draggable_scrollable_sheet_options.dart';
import '../../../widgets/auto_size_draggable_scrollable_sheet.dart';
import '../../../widgets/one_line_sheet_header_widget.dart';
import '../selection/models/selection_data_source.dart';
import '../selection/models/selection_item_view_options.dart';
import '../selection/models/selection_sheet_settings.dart';
import 'widgets/multiple_selection_list_widget.dart';
import 'widgets/multiple_selection_paginated_remote_list_widget.dart';
import 'widgets/multiple_selection_remote_list_widget.dart';

export '../selection/models/selection_sheet_settings.dart';

class MultipleSelectionSheet<T> extends StatefulWidget {
  const MultipleSelectionSheet({
    required this.onChanged,
    required this.itemViewOptions,
    required this.dataSource,
    this.selectionSettings = const SelectionSheetSettings(),
    this.values = const [],
    super.key,
  });

  final SelectionDataSource<T> dataSource;
  final void Function(List<T> items) onChanged;
  final SelectionSheetSettings selectionSettings;
  final SelectionItemViewOptions<T> itemViewOptions;
  final List<T> values;

  @override
  State<MultipleSelectionSheet<T>> createState() =>
      _MultipleSelectionSheetState<T>();

  void show(final BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (final context) => this,
      );
}

class _MultipleSelectionSheetState<T> extends State<MultipleSelectionSheet<T>> {
  int? _remoteItemCount;

  @override
  Widget build(final BuildContext context) => AutoSizeDraggableScrollableSheet(
        options: widget.selectionSettings.autoSizeOptions ??
            AutoSizeDraggableScrollableSheetOptions(
              expand: false,
              itemLength: widget.dataSource is SelectionLocalDataSource<T>
                  ? (widget.dataSource as SelectionLocalDataSource).items.length
                  : _remoteItemCount ?? 3,
              itemSize: 0.09,
              headerSize: 0.11,
              footerSize: 0.09 + widget.selectionSettings.footerHeightFraction,
              minSize: 0.21,
              maxInitialItemsInMinSize: 5,
              snap: true,
            ),
        builder: (final context, final scrollController) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.selectionSettings.title != null ||
                widget.selectionSettings.showCloseIcon)
              OneLineSheetHeaderWidget(
                title: widget.selectionSettings.title,
                showCloseButton: widget.selectionSettings.showCloseIcon,
              ),
            Flexible(
              child: widget.dataSource is SelectionLocalDataSource<T>
                  ? MultipleSelectionListWidget<T>(
                      onChanged: widget.onChanged,
                      itemViewOptions: widget.itemViewOptions,
                      items: (widget.dataSource as SelectionLocalDataSource<T>)
                          .items,
                      values: widget.values,
                      selectionSettings: _settings(scrollController),
                    )
                  : widget.dataSource is SelectionRemoteDataSource<T>
                      ? MultipleSelectionRemoteListWidget(
                          itemViewOptions: widget.itemViewOptions,
                          onChanged: widget.onChanged,
                          onRemoteFetch: (widget.dataSource
                                  as SelectionRemoteDataSource<T>)
                              .fetchItems,
                          values: widget.values,
                          selectionSettings: _settings(scrollController),
                          onFetched: (count) => setState(
                            () => _remoteItemCount = count,
                          ),
                        )
                      : MultipleSelectionPaginatedRemoteListWidget(
                          onChanged: widget.onChanged,
                          itemViewOptions: widget.itemViewOptions,
                          selectionSettings: _settings(scrollController),
                          onRemoteFetch: ({
                            required paginationDto,
                            query,
                          }) =>
                              (widget.dataSource
                                      as SelectionPaginatedRemoteDataSource<T>)
                                  .fetchItems(
                            dto: paginationDto,
                            query: query,
                          ),
                          values: widget.values,
                          onFetched: (count) => setState(
                            () => _remoteItemCount = count,
                          ),
                        ),
            ),
            if (widget.selectionSettings.footerBuilder != null)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      color: Theme.of(context).colorScheme.shadow,
                      blurStyle: BlurStyle.normal,
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: widget.selectionSettings.footerBuilder?.call(context),
              ),
          ],
        ),
      );

  SelectionSheetSettings _settings(ScrollController scrollController) =>
      widget.selectionSettings.copyWithScrollController(
        scrollController,
      );
}
