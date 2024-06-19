import 'package:core_feature/core_feature.dart';
import 'package:flutter/material.dart';
import 'package:pagination_service/pagination_service.dart';

import '../selection_sheet.dart';

abstract class SingleSelectionBaseWidget<T> extends StatefulWidget {
  final void Function(T item) onChanged;
  final SelectionItemViewOptions<T> itemOptions;
  final SelectionSheetSettings selectionSettings;
  final T? value;

  const SingleSelectionBaseWidget({
    required this.onChanged,
    required this.itemOptions,
    this.value,
    this.selectionSettings = const SelectionSheetSettings(),
    super.key,
  });
}

abstract class SingleSelectionLocalWidget<T>
    extends SingleSelectionBaseWidget<T> {
  const SingleSelectionLocalWidget({
    required this.items,
    required super.onChanged,
    required super.itemOptions,
    required super.value,
    super.selectionSettings = const SelectionSheetSettings(),
    super.key,
  });

  final List<T> items;
}

abstract class SingleSelectionRemoteWidget<T>
    extends SingleSelectionBaseWidget<T> {
  const SingleSelectionRemoteWidget({
    required this.onFetched,
    required this.onRemoteFetch,
    required super.onChanged,
    required super.itemOptions,
    required super.value,
    super.selectionSettings = const SelectionSheetSettings(),
    super.key,
  });

  final void Function(int count) onFetched;
  final Future<Either<BaseFailure, List<T>>> Function() onRemoteFetch;
}

abstract class SingleSelectionPaginatedRemoteWidget<T>
    extends SingleSelectionBaseWidget<T> {
  const SingleSelectionPaginatedRemoteWidget({
    required this.onRemoteFetch,
    required this.onFetched,
    required super.onChanged,
    required super.itemOptions,
    super.selectionSettings = const SelectionSheetSettings(),
    super.value,
    super.key,
  });

  final void Function(int count) onFetched;
  final Future<Either<BaseFailure, PaginatedList<T>>> Function({
    required PaginationDto paginationDto,
    String? query,
  }) onRemoteFetch;
}
