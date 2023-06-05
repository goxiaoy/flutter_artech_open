import 'dart:async';

import 'package:artech_core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final Logger _logger = Logger('Hooks');

AsyncSnapshot<T?> useMemoizedFuture<T>(
  Future<T?>? create(), {
  List<Object?> keys = const [],
  T? initialData,
  bool preserveState = true,
}) {
  final future = useMemoized(create, keys);
  return useFuture<T?>(future,
      initialData: initialData, preserveState: preserveState);
}

AsyncSnapshot<T?> useMemoizedStream<T>(
  Stream<T>? create(), {
  List<Object?> keys = const [],
  T? initialData,
  bool preserveState = true,
}) {
  final stream = useMemoized(create, keys);
  return useStream(stream,
      initialData: initialData, preserveState: preserveState);
}

void useInterval(FutureOr<void> callback(), Duration delay,
    {bool initial = false}) {
  final savedCallback = useRef(callback);
  savedCallback.value = callback;

  useEffect(() {
    if (initial) {
      savedCallback.value();
    }
    final timer = Timer.periodic(delay, (_) => savedCallback.value());
    return timer.cancel;
  }, [delay, initial]);
}

/// Stores an [AsyncSnapshot] as well as a reference to a function [refresh]
/// that should re-call the future that was used to generate the [snapshot].
class RefreshableAsyncSnapshot<T> {
  const RefreshableAsyncSnapshot(this.snapshot, this.refresh,
      {this.isRefreshing});
  final AsyncSnapshot<T> snapshot;
  final Future<dynamic> Function() refresh;
  final bool? isRefreshing;
}

/// Subscribes to a [Future] and returns its current state in a
/// [MemoizedAsyncSnapshot].
/// The [future] is memoized and will only be re-called if any of the [keys]
/// change or if [MemoizedAsyncSnapshot.refresh] is called.
///
/// * [initialData] specifies what initial value the [AsyncSnapshot] should
///   have.
/// * [preserveState] defines if the current value should be preserved when
///   changing the [Future] instance.
///
/// See also:
///   * [useFuture], the hook responsible for getting the future.
///   * [useMemoized], the hook responsible for the memoization.
RefreshableAsyncSnapshot<T?> useMemoizedRefreshableFuture<T>(
  Future<T?>? future(), {
  List<Object?> keys = const [],
  T? initialData,
  bool preserveState = true,
}) {
  final isRefreshing = useState(false);

  final initialSnapshot = () => initialData == null
      ? AsyncSnapshot<T?>.nothing()
      : AsyncSnapshot.withData(ConnectionState.none, initialData);

  final snapshot = useState(initialSnapshot());
  final context = useContext();
  final futureWrapper = () async {
    isRefreshing.value = true;
    try {
      snapshot.value = snapshot.value.inState(ConnectionState.waiting);
      final ret = await future();
      if (context.mounted) {
        snapshot.value = AsyncSnapshot<T?>.withData(
          ConnectionState.done,
          ret,
        );
      }
    } catch (error, stackTrace) {
      if (context.mounted) {
        snapshot.value = AsyncSnapshot<T?>.withError(
          ConnectionState.done,
          error,
          stackTrace,
        );
      }
    } finally {
      if (context.mounted) {
        isRefreshing.value = false;
      }
    }
  };

  useMemoized(() {
    if (preserveState) {
      snapshot.value = snapshot.value.inState(ConnectionState.none);
    } else {
      snapshot.value = initialSnapshot();
    }
    //trigger refresh
    futureWrapper();
  }, keys);

  return RefreshableAsyncSnapshot<T?>(snapshot.value, futureWrapper,
      isRefreshing: isRefreshing.value);
}

T? useSettingKey<T>(SettingStore ss, String key, [T? defaultValue]) {
  final s = useMemoizedFuture(
      () => ss
              .get<T?>(key, defaultValue: defaultValue)
              .catchError((Object e, StackTrace stackTrace) {
            _logger.severe(e, e, stackTrace);
            throw e;
          }),
      keys: [ss, key, defaultValue]);
  return s.data;
}

T? useWatchSettingKey<T>(SettingStore ss, String key, [T? defaultValue]) {
  final res = useState<T?>(defaultValue);
  late StreamSubscription<KeyChangeEvent> subs;
  final mounted = useIsMounted();
  useEffect(() {
    //clear previous state
    res.value = defaultValue;
    subs = ss.watch(key: key).listen((event) {
      if (event.isDelete) {
        res.value = null;
      } else {
        res.value = event.value as T;
      }
    });
    return () {
      subs.cancel();
    };
  }, [ss, key, defaultValue]);
  useMemoizedFuture(() async {
    try {
      await ss.get<T?>(key, defaultValue: defaultValue).then((value) {
        if (mounted()) {
          res.value = value;
        }
      });
    } catch (e, s) {
      _logger.severe('Fail to get setting key $key from store $ss', e, s);
    }
  }, keys: [ss, key, defaultValue]);
  return res.value;
}
