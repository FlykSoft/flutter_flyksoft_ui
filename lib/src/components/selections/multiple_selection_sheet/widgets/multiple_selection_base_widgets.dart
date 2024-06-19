import 'package:core_feature/core_feature.dart';
import 'package:flutter/material.dart';
import 'package:pagination_service/pagination_service.dart';

import '../../selection/models/selection_item_view_options.dart';
import '../../selection/models/selection_sheet_settings.dart';

abstract class MultipleSelectionBaseWidget<T> extends StatefulWidget {
  final void Function(List<T> item) onChanged;
  final SelectionItemViewOptions<T> itemViewOptions;
  final SelectionSheetSettings selectionSettings;
  final List<T> values;

  const MultipleSelectionBaseWidget({
    required this.onChanged,
    required this.itemViewOptions,
    this.values = const [],
    this.selectionSettings = const SelectionSheetSettings(),
    super.key,
  });
}

abstract class MultipleSelectionLocalWidget<T>
    extends MultipleSelectionBaseWidget<T> {
  const MultipleSelectionLocalWidget({
    required this.items,
    required super.onChanged,
    required super.itemViewOptions,
    super.values = const [],
    super.selectionSettings = const SelectionSheetSettings(),
    super.key,
  });

  final List<T> items;
}

abstract class MultipleSelectionRemoteWidget<T>
    extends MultipleSelectionBaseWidget<T> {
  const MultipleSelectionRemoteWidget({
    required this.onRemoteFetch,
    required this.onFetched,
    required super.onChanged,
    required super.itemViewOptions,
    super.values = const [],
    super.selectionSettings = const SelectionSheetSettings(),
    super.key,
  });

  final Future<Either<BaseFailure, List<T>>> Function() onRemoteFetch;
  final void Function(int count) onFetched;
}

abstract class MultipleSelectionPaginatedRemoteWidget<T>
    extends MultipleSelectionBaseWidget<T> {
  const MultipleSelectionPaginatedRemoteWidget({
    required this.onRemoteFetch,
    required this.onFetched,
    required super.onChanged,
    required super.itemViewOptions,
    super.values = const [],
    super.selectionSettings = const SelectionSheetSettings(),
    super.key,
  });

  final void Function(int count) onFetched;
  final Future<Either<BaseFailure, PaginatedList<T>>> Function({
    required PaginationDto paginationDto,
    String? query,
  }) onRemoteFetch;
}
