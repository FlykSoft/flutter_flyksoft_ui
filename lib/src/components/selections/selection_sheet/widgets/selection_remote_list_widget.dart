import 'package:core_feature/core_feature.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/loading_widget.dart';
import '../../../../widgets/retry_widget.dart';
import 'selection_list_widget.dart';
import 'single_selection_base_widgets.dart';
import 'single_selection_states.dart';

class SelectionRemoteListWidget<T> extends SingleSelectionRemoteWidget<T> {
  const SelectionRemoteListWidget({
    required super.onRemoteFetch,
    required super.onFetched,
    required super.onChanged,
    required super.itemOptions,
    super.selectionSettings,
    super.value,
    super.key,
  });

  @override
  State<SelectionRemoteListWidget<T>> createState() =>
      _SelectionRemoteListWidgetState();
}

class _SelectionRemoteListWidgetState<T>
    extends State<SelectionRemoteListWidget<T>>
    with SingleSelectionRemoteState<T, SelectionRemoteListWidget<T>> {
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
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 32 * 2.5,
              ),
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
                      Future(
                        () => widget.onFetched(
                          items.length,
                        ),
                      );
                      doesNotifiedCount = true;
                    }
                    return SelectionListWidget(
                      onChanged: widget.onChanged,
                      items: items,
                      itemOptions: widget.itemOptions,
                      selectionSettings: widget.selectionSettings,
                      value: widget.value,
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
