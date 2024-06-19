import 'dart:async';

import 'package:core_feature/core_feature.dart';
import 'package:flutter/material.dart';
import 'package:pagination_service/pagination_service.dart';

import '../../../../utils/debouncer.dart';
import 'multiple_selection_base_widgets.dart';

mixin MultipleSelectionLocalState<T, W extends MultipleSelectionLocalWidget<T>>
    on State<W> {
  final ValueNotifier<String> query = ValueNotifier('');
  final List<T> filteredItems = [];
  final List<T> allItems = [];
  final Debouncer debouncer = Debouncer();

  final List<T> selectedItems = [];
  final List<ValueNotifier<bool>> valueNotifiers = [];

  @override
  void initState() {
    allItems
      ..clear()
      ..addAll(widget.items);
    filteredItems
      ..clear()
      ..addAll(widget.items);
    selectedItems
      ..clear()
      ..addAll(
        widget.values,
      );
    valueNotifiers
      ..clear()
      ..addAll(
        List.generate(
          allItems.length,
          (index) => ValueNotifier(
            widget.values.contains(
              allItems.elementAt(index),
            ),
          ),
        ),
      );
    super.initState();
  }

  @override
  void dispose() {
    for (final ValueNotifier<bool> notifier in valueNotifiers) {
      notifier.dispose();
    }
    query.dispose();
    debouncer.cancel();
    super.dispose();
  }

  void onItemSelectionChanged(T item, int index, {bool? value}) {
    final bool hasAlreadyThisItem = selectedItems.any(
      (element) => element == item,
    );
    if ((value ?? true) && !hasAlreadyThisItem) {
      selectedItems.add(item);
      valueNotifiers.elementAt(index).value = true;
    } else if (!(value ?? false) && hasAlreadyThisItem) {
      selectedItems.remove(item);
      valueNotifiers.elementAt(index).value = false;
    }
  }

  void filter(String searchText) {
    if (searchText.isEmpty) {
      filteredItems
        ..clear()
        ..addAll(allItems);
    } else {
      final String queryLowerCased = searchText;
      final List<T> filtered = [];
      for (final T item in allItems) {
        if (widget.itemViewOptions.itemAsString!(item)
                ?.toLowerCase()
                .contains(queryLowerCased) ??
            false) {
          filtered.add(item);
        }
      }
      filteredItems
        ..clear()
        ..addAll(filtered);
    }
    query.value = searchText;
  }
}

mixin MultipleSelectionRemoteState<T,
    W extends MultipleSelectionRemoteWidget<T>> on State<W> {
  late Future<Either<BaseFailure, List<T>>> onRemoteFetch;
  bool doesNotifiedCount = false;
  AsyncSnapshot<Either<BaseFailure, List<T>>>? snapshot;

  @override
  void initState() {
    onRemoteFetch = widget.onRemoteFetch();
    super.initState();
  }

  void refresh() => setState(
        () {
          snapshot = null;
          onRemoteFetch = widget.onRemoteFetch();
        },
      );
}

mixin MultipleSelectionPaginatedRemoteState<T,
    W extends MultipleSelectionPaginatedRemoteWidget<T>> on State<W> {
  final PaginationController<T> controller = PaginationController();
  String? query;
  final Debouncer debouncer = Debouncer();
  bool hasNotifiedCount = false;
  final List<T> selectedItems = [];
  final List<ValueNotifier<bool>> valueNotifiers = [];

  @override
  void initState() {
    selectedItems
      ..clear()
      ..addAll(
        widget.values,
      );

    controller.init(
      (_) => _remoteFetch(),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    debouncer.cancel();
    for (final ValueNotifier<bool> notifier in valueNotifiers) {
      notifier.dispose();
    }
    super.dispose();
  }

  void onItemSelectionChanged(T item, int index, {bool? value}) {
    final bool hasAlreadyThisItem = selectedItems.any(
      (element) => element == item,
    );
    if ((value ?? true) && !hasAlreadyThisItem) {
      selectedItems.add(item);
      valueNotifiers.elementAt(index).value = true;
    } else if (!(value ?? false) && hasAlreadyThisItem) {
      selectedItems.remove(item);
      valueNotifiers.elementAt(index).value = false;
    }
  }

  void _remoteFetch() async {
    final result = await widget.onRemoteFetch(
      paginationDto: controller.nextDto,
      query: query,
    );
    result.fold(
      (failure) => controller.failure(failure.toString()),
      (data) {
        valueNotifiers.addAll(
          List.generate(
            data.results.length,
            (index) => ValueNotifier(
              selectedItems.contains(
                data.results.elementAt(index),
              ),
            ),
          ),
        );
        controller.insertData(data);
        if (!hasNotifiedCount) {
          widget.onFetched(data.results.length);
          hasNotifiedCount = true;
        }
      },
    );
  }
}
