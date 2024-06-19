import 'dart:async';

import 'package:core_feature/core_feature.dart';
import 'package:flutter/material.dart';
import 'package:pagination_service/pagination_service.dart';

import '../../../../utils/debouncer.dart';
import 'single_selection_base_widgets.dart';

mixin SingleSelectionPaginatedRemoteState<T,
    W extends SingleSelectionPaginatedRemoteWidget<T>> on State<W> {
  final PaginationController<T> controller = PaginationController();
  String? query;
  final Debouncer debouncer = Debouncer();
  bool hasNotifiedCount = false;

  @override
  void initState() {
    controller.init(
      (_) => _remoteFetch(),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    debouncer.cancel();
    super.dispose();
  }

  void _remoteFetch() async {
    final result = await widget.onRemoteFetch(
      paginationDto: controller.nextDto,
      query: query,
    );
    result.fold(
      (failure) => controller.failure(failure.toString()),
      (data) {
        if (!hasNotifiedCount) {
          widget.onFetched(data.results.length);
          hasNotifiedCount = true;
        }
        controller.insertData(data);
      },
    );
  }
}

mixin SingleSelectionRemoteState<T, W extends SingleSelectionRemoteWidget<T>>
    on State<W> {
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

mixin SingleSelectionLocalState<T, W extends SingleSelectionLocalWidget<T>>
    on State<W> {
  final ValueNotifier<String> query = ValueNotifier('');
  final List<T> filteredItems = [];
  final List<T> allItems = [];
  final Debouncer debouncer = Debouncer();

  @override
  void initState() {
    allItems
      ..clear()
      ..addAll(widget.items);
    filteredItems
      ..clear()
      ..addAll(widget.items);
    super.initState();
  }

  @override
  void dispose() {
    query.dispose();
    debouncer.cancel();
    super.dispose();
  }

  void onSelect(
    final BuildContext context,
    final T item,
  ) {
    Navigator.of(context).pop();
    unawaited(Future(() => widget.onChanged(item)));
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
        if (widget.itemOptions.itemAsString!(item)
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
