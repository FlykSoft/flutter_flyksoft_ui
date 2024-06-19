import 'package:core_feature/core_feature.dart';
import 'package:pagination_service/pagination_service.dart';

abstract class SelectionDataSource<T> {}

class SelectionLocalDataSource<T> extends SelectionDataSource<T> {
  final List<T> items;

  SelectionLocalDataSource(this.items);
}

class SelectionRemoteDataSource<T> extends SelectionDataSource<T> {
  final Future<Either<BaseFailure, List<T>>> Function() fetchItems;

  SelectionRemoteDataSource(this.fetchItems);
}

class SelectionPaginatedRemoteDataSource<T> extends SelectionDataSource<T> {
  final Future<Either<BaseFailure, PaginatedList<T>>> Function({
    required PaginationDto dto,
    String? query,
  }) fetchItems;

  SelectionPaginatedRemoteDataSource(this.fetchItems);
}
