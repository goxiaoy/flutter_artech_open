import 'package:artech_core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('GraphQLHooks');
AsyncSnapshot<T> useMemoizedWatchQuery<T>(
    ObservableQuery Function() queryBuilder,
    T Function(QueryResult) deserializeFunc,
    [List<Object> keys = const <Object>[]]) {
  final ObservableQuery query = useMemoized(queryBuilder, keys);
  useEffect(
    () {
      //query 变化 或者dispose的时候会调用close
      return () {
        _logger.fine('Close watch query');
        query.close();
      };
    },
    [query],
  );
  return useMemoizedStream(() => query.stream.map(deserializeFunc),
      keys: [query]);
}

RefreshableAsyncSnapshot<T> useMemoizedRefreshableWatchQuery<T>(
    ObservableQuery Function() queryBuilder,
    T Function(QueryResult) deserializeFunc,
    [List<Object> keys = const <Object>[]]) {
  final ObservableQuery query = useMemoized(queryBuilder, keys);
  useEffect(
    () {
      //query 变化 或者dispose的时候会调用close
      return () {
        _logger.fine('Close watch query');
        query.close();
      };
    },
    [query],
  );
  return RefreshableAsyncSnapshot<T>(
      useMemoizedStream(() => query.stream.map(deserializeFunc), keys: [query]),
      () => query.refetch());
}

AsyncSnapshot<T> useMemoizedQuery<T>(
    Future<QueryResult> Function() queryBuilder,
    T Function(QueryResult) deserializeFunc,
    [List<Object> keys = const <Object>[]]) {
  return useMemoizedFuture(() => queryBuilder().then(deserializeFunc),
      keys: keys);
}
