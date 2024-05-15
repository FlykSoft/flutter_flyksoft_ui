import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flyksoft_ui/src/theme/flyksoft_theme.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../localization/flyksoft_ui_localization.dart';
import '../../../../widgets/app_text_field.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../../widgets/not_found_widget.dart';
import '../../../../widgets/retry_widget.dart';
import '../selection_sheet.dart';
import 'default_single_selection_tile.dart';
import 'single_selection_base_widgets.dart';
import 'single_selection_states.dart';

class SelectionPaginatedRemoteListWidget<T>
    extends SingleSelectionPaginatedRemoteWidget<T> {
  const SelectionPaginatedRemoteListWidget({
    required super.onRemoteFetch,
    required super.onFetched,
    required super.onChanged,
    required super.itemOptions,
    super.selectionSettings,
    super.value,
    super.key,
  });

  @override
  State<SelectionPaginatedRemoteListWidget<T>> createState() =>
      _PaginatedListWidgetState<T>();
}

class _PaginatedListWidgetState<T>
    extends State<SelectionPaginatedRemoteListWidget<T>>
    with
        SingleSelectionPaginatedRemoteState<T,
            SelectionPaginatedRemoteListWidget<T>> {
  @override
  Widget build(final BuildContext context) {
    final horizontalPaddingValue =
        FlyksoftTheme.of(context)?.horizontalPaddingValue ?? 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.selectionSettings.showSearch)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: horizontalPaddingValue,
              end: horizontalPaddingValue,
              bottom: 8,
            ),
            child: AppTextField(
              hintText: FlyksoftUILocalization.of(context).search,
              onChanged: (value) {
                query = value;
                debouncer.debounce(controller.refresh);
              },
            ),
          ),
        Flexible(
          child: Scrollbar(
            controller: widget.selectionSettings.scrollController,
            child: PagedListView<int, T>.separated(
              scrollController: widget.selectionSettings.scrollController,
              pagingController: controller,
              padding: const EdgeInsets.only(
                bottom: 32,
                top: 24,
              ),
              separatorBuilder: (final context, final index) => Divider(
                indent: horizontalPaddingValue,
                endIndent: horizontalPaddingValue,
                height: 1,
              ),
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (
                  final context,
                  final item,
                  final index,
                ) =>
                    _TileWrapper(
                  onChanged: widget.onChanged,
                  item: item,
                  itemOptions: widget.itemOptions,
                  isSelected: item == widget.value,
                ),
                firstPageErrorIndicatorBuilder: (final context) => RetryWidget(
                  onRetry: controller.retryLastFailedRequest,
                  message: controller.error,
                ),
                firstPageProgressIndicatorBuilder: (final context) =>
                    const Center(
                  child: LoadingWidget(),
                ),
                noItemsFoundIndicatorBuilder: (final context) => NotFoundWidget(
                  itemName: widget.selectionSettings.itemName,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TileWrapper<T> extends StatelessWidget {
  const _TileWrapper({
    required this.onChanged,
    required this.item,
    required this.itemOptions,
    this.isSelected = false,
    super.key,
  });

  final T item;
  final void Function(T item) onChanged;
  final SelectionItemViewOptions<T> itemOptions;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => _onSelect(
          context,
          item,
        ),
        child: itemOptions.itemBuilder?.call(item) ??
            DefaultSingleSelectionTile<T>(
              item: item,
              isSelected: isSelected,
              itemAsString: (item) =>
                  itemOptions.itemAsString?.call(item) ?? '',
            ),
      );

  void _onSelect(final BuildContext context, final T item) async {
    Navigator.of(context).pop();
    unawaited(Future(() => onChanged(item)));
  }
}
