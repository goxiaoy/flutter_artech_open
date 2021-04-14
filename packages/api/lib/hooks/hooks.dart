import 'package:artech_core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../api.dart';

AsyncSnapshot<T> useMemoizedStreamProvider<T>(
    StreamProvider<T> Function() streamProviderBuilder,
    T Function(QueryResult) deserializeFunc,
    [List<Object> keys = const <Object>[]]) {
  final streamProvider = useMemoized(streamProviderBuilder, keys);
  useEffect(
    () {
      return () {
        streamProvider.close();
      };
    },
    [streamProvider],
  );
  return useMemoizedStream(() => streamProvider.stream, keys: [streamProvider]);
}
