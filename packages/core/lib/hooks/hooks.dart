import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

AsyncSnapshot<T> useMemoizedFuture<T>(
  Future<T> create(), {
  List<Object> keys = const [],
  T? initialData,
  bool preserveState = true,
}) {
  final future = useMemoized(create, keys);
  return useFuture(future,
      initialData: initialData, preserveState: preserveState);
}

AsyncSnapshot<T> useMemoizedStream<T>(
  Stream<T> create(), {
  List<Object> keys = const [],
  T? initialData,
  bool preserveState = true,
}) {
  final stream = useMemoized(create, keys);
  return useStream(stream,
      initialData: initialData, preserveState: preserveState);
}

/// Stores an [AsyncSnapshot] as well as a reference to a function [refresh]
/// that should re-call the future that was used to generate the [snapshot].
class MemoizedRefreshableAsyncSnapshot<T> {
  const MemoizedRefreshableAsyncSnapshot(this.snapshot, this.refresh);
  final AsyncSnapshot<T> snapshot;
  final Function() refresh;
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
MemoizedRefreshableAsyncSnapshot<T> useMemoizedRefreshableFuture<T>(
  Future<T> Function() future, {
  List<Object> keys = const [],
  T? initialData,
  bool preserveState = true,
}) {
  final refresh = useState(0);
  final result = useMemoizedFuture(
    future,
    keys: [refresh.value, ...keys],
    initialData: initialData,
    preserveState: preserveState,
  );

  void refreshMe() => refresh.value++;
  return MemoizedRefreshableAsyncSnapshot<T>(result, refreshMe);
}
