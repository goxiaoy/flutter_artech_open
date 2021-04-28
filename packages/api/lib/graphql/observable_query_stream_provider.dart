import 'dart:async';

import 'package:artech_api/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

typedef QueryResultTransformer<T> = T Function(QueryResult? queryResult);

class ObservableQueryStreamProvider<T> implements RefreshableStreamProvider<T> {
  ObservableQueryStreamProvider(this.query, this.transformer);
  final ObservableQuery query;
  final QueryResultTransformer<T> transformer;

  @override
  Stream<T> get stream => query.stream
      .where((event) => event.source != QueryResultSource.loading)
      .map<T>((event) => transformer(event));

  @override
  FutureOr close() => query.close();

  @override
  FutureOr<T> refresh() async {
    return transformer(await query.refetch());
  }
}
