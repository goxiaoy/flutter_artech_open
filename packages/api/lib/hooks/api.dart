import 'package:artech_core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:artech_api/stream_provider.dart';

AsyncSnapshot<T?> useMemoizedStreamProvider<T>(
    StreamProvider<T>? Function() streamProviderBuilder,
    [List<Object?> keys = const <Object?>[]]) {
  final streamProvider = useMemoized(streamProviderBuilder, keys);
  useEffect(
    () {
      return () {
        streamProvider?.close();
      };
    },
    [streamProvider],
  );
  return useMemoizedStream(() => streamProvider?.stream,
      keys: [streamProvider]);
}
