import 'package:flutter/material.dart';
import 'package:flyksoft_ui/src/localization/flyksoft_ui_localization.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../components/selections/multiple_selection_sheet/widgets/multiple_selection_base_widgets.dart';
import '../../../../theme/flyksoft_theme.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text_field.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../../widgets/not_found_widget.dart';
import '../../../../widgets/retry_widget.dart';
import '../../selection/models/selection_sheet_settings.dart';
import 'default_multiple_selection_tile.dart';
import 'multiple_selection_states.dart';

class MultipleSelectionPaginatedRemoteListWidget<T>
    extends MultipleSelectionPaginatedRemoteWidget<T> {
  const MultipleSelectionPaginatedRemoteListWidget({
    required super.onRemoteFetch,
    required super.onChanged,
    required super.onFetched,
    required super.itemViewOptions,
    super.selectionSettings = const SelectionSheetSettings(),
    super.values = const [],
    super.key,
  });

  @override
  State<MultipleSelectionPaginatedRemoteListWidget<T>> createState() =>
      _MultipleSelectionPaginatedRemoteListWidgetState();
}

class _MultipleSelectionPaginatedRemoteListWidgetState<T>
    extends State<MultipleSelectionPaginatedRemoteListWidget<T>>
    with
        MultipleSelectionPaginatedRemoteState<T,
            MultipleSelectionPaginatedRemoteListWidget<T>> {
  @override
  Widget build(BuildContext context) {
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
        Expanded(
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
                    InkWell(
                  onTap: () => onItemSelectionChanged(
                    item,
                    index,
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: valueNotifiers.elementAt(index),
                    builder: (context, value, child) => widget
                                .itemViewOptions.itemBuilder !=
                            null
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPaddingValue,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: value,
                                  onChanged: (value) => onItemSelectionChanged(
                                    item,
                                    index,
                                    value: value,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child:
                                      widget.itemViewOptions.itemBuilder!.call(
                                    item,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : DefaultMultipleSelectionTile<T>(
                            item: item,
                            itemAsString: widget.itemViewOptions.itemAsString!,
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
        ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
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
        ),
      ],
    );
  }
}
