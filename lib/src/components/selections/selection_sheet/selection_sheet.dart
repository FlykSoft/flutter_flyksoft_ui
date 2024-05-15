import 'package:flutter/material.dart' hide CloseButton;

import '../../../components/selections/selection/models/selection_data_source.dart';
import '../../../components/selections/selection/models/selection_item_view_options.dart';
import '../../../components/selections/selection_sheet/widgets/selection_list_widget.dart';
import '../../../models/auto_size_draggable_scrollable_sheet_options.dart';
import '../../../widgets/auto_size_draggable_scrollable_sheet.dart';
import '../../../widgets/one_line_sheet_header_widget.dart';
import '../selection/models/selection_sheet_settings.dart';
import 'widgets/selection_paginated_remote_list_widget.dart';
import 'widgets/selection_remote_list_widget.dart';

export '../../../components/selections/selection/models/selection_item_view_options.dart';
export '../selection/models/selection_sheet_settings.dart';

class SelectionSheet<T> extends StatefulWidget {
  const SelectionSheet({
    required this.onChanged,
    required this.itemViewOptions,
    required this.dataSource,
    this.selectionSettings = const SelectionSheetSettings(),
    this.value,
    super.key,
  });

  final SelectionDataSource<T> dataSource;
  final void Function(T item) onChanged;
  final SelectionSheetSettings selectionSettings;
  final SelectionItemViewOptions<T> itemViewOptions;
  final T? value;

  @override
  State<SelectionSheet<T>> createState() => _SelectionSheetState<T>();

  void show(
    final BuildContext context, {
    bool useRootNavigator = false,
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        useRootNavigator: useRootNavigator,
        builder: (final context) => this,
      );
}

class _SelectionSheetState<T> extends State<SelectionSheet<T>> {
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
              headerSize: widget.selectionSettings.showSearch ? 0.20 : 0.11,
              minSize: 0.21,
              footerSize: widget.selectionSettings.footerHeightFraction,
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
              child: widget.dataSource is SelectionLocalDataSource
                  ? SelectionListWidget<T>(
                      onChanged: widget.onChanged,
                      items: (widget.dataSource as SelectionLocalDataSource<T>)
                          .items,
                      selectionSettings: _settings(scrollController),
                      itemOptions: widget.itemViewOptions,
                      value: widget.value,
                    )
                  : widget.dataSource is SelectionRemoteDataSource<T>
                      ? SelectionRemoteListWidget<T>(
                          onChanged: widget.onChanged,
                          onRemoteFetch: (widget.dataSource
                                  as SelectionRemoteDataSource<T>)
                              .fetchItems,
                          selectionSettings: _settings(scrollController),
                          itemOptions: widget.itemViewOptions,
                          value: widget.value,
                          onFetched: (count) => setState(
                            () => _remoteItemCount = count > 1 ? count : 1,
                          ),
                        )
                      : SelectionPaginatedRemoteListWidget<T>(
                          selectionSettings: _settings(scrollController),
                          itemOptions: widget.itemViewOptions,
                          onChanged: widget.onChanged,
                          value: widget.value,
                          onRemoteFetch: ({required paginationDto, query}) =>
                              (widget.dataSource
                                      as SelectionPaginatedRemoteDataSource<T>)
                                  .fetchItems(
                            dto: paginationDto,
                            query: query,
                          ),
                          onFetched: (count) => setState(
                            () => _remoteItemCount = count > 1 ? count : 1,
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
