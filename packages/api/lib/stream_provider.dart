import 'dart:async';

///wrap a stream and close function
abstract class StreamProvider<T> {
  ///get the raw stream
  Stream<T> get stream;

  ///close function of this provider
  FutureOr close() {}
}

abstract class RefreshableStreamProvider<T> extends StreamProvider<T> {
  ///refresh
  FutureOr<T> refresh();
}

class DelegateStreamProvider<T> implements StreamProvider<T> {
  DelegateStreamProvider(
    this.streamFunc,
    this.closeFunc,
  );
  final FutureOr Function() closeFunc;
  final Stream<T> Function() streamFunc;

  @override
  FutureOr close() async {
    await closeFunc.call();
  }

  @override
  Stream<T> get stream => streamFunc.call();
}

class FutureStreamProvider<T> extends StreamProvider<T> {
  FutureStreamProvider(this.future);
  final Future<T> future;

  @override
  Stream<T> get stream => Stream.fromFuture(future);
}
