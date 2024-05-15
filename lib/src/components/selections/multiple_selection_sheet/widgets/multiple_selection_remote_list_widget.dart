import 'package:core_feature/core_feature.dart';
import 'package:flutter/material.dart';

import '../../../../components/selections/multiple_selection_sheet/widgets/multiple_selection_base_widgets.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../../widgets/retry_widget.dart';
import '../../selection/models/selection_sheet_settings.dart';
import 'multiple_selection_list_widget.dart';
import 'multiple_selection_states.dart';

class MultipleSelectionRemoteListWidget<T>
    extends MultipleSelectionRemoteWidget<T> {
  const MultipleSelectionRemoteListWidget({
    required super.onRemoteFetch,
    required super.onChanged,
    required super.onFetched,
    required super.itemViewOptions,
    super.selectionSettings = const SelectionSheetSettings(),
    super.values = const [],
    super.key,
  });

  @override
  State<MultipleSelectionRemoteListWidget<T>> createState() =>
      _MultipleSelectionRemoteListWidgetState();
}

class _MultipleSelectionRemoteListWidgetState<T>
    extends State<MultipleSelectionRemoteListWidget<T>>
    with MultipleSelectionRemoteState<T, MultipleSelectionRemoteListWidget<T>> {
  @override
  Widget build(BuildContext context) =>
      FutureBuilder<Either<ApiFailure, List<T>>>(
        future: onRemoteFetch,
        builder: (context, snapshot) {
          this.snapshot = snapshot;
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: LoadingWidget(),
              ),
            );
          } else if (snapshot.hasError) {
            return RetryWidget(
              onRetry: refresh,
              message: snapshot.error.toString(),
            );
          } else if (snapshot.hasData) {
            final result = snapshot.data;
            return result?.fold(
                  (failure) => RetryWidget(
                    onRetry: refresh,
                    message: failure.toString(),
                  ),
                  (items) {
                    if (!doesNotifiedCount) {
                      Future(() => widget.onFetched(items.length));
                      doesNotifiedCount = true;
                    }
                    return MultipleSelectionListWidget(
                      selectionSettings: widget.selectionSettings,
                      onChanged: widget.onChanged,
                      itemViewOptions: widget.itemViewOptions,
                      items: items,
                      values: widget.values,
                    );
                  },
                ) ??
                const SizedBox.shrink();
          } else {
            return const SizedBox.shrink();
          }
        },
      );
}
