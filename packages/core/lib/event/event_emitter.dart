import 'dart:async';

typedef EventEmitterHandlerFunction<T> = FutureOr Function(T? data);

abstract class EventEmitterHandlerBase {
  FutureOr<bool> canHandle(dynamic data);

  Future handle(dynamic data);
}

class TypedEventEmitterHandler<T> extends EventEmitterHandlerBase {
  TypedEventEmitterHandler(this.handleFunction);
  final EventEmitterHandlerFunction<T> handleFunction;
  @override
  Future handle(dynamic data) async {
    final d = data as T;
    await handleFunction.call(d);
  }

  @override
  FutureOr<bool> canHandle(dynamic data) => data is T;
}

class EventEmitter {
  EventEmitter() {
    _handlers = <EventEmitterHandlerBase>[];
  }

  late List<EventEmitterHandlerBase> _handlers;

  Future emitAsync(dynamic data) async {
    for (final handler in _handlers) {
      final canHandle = await handler.canHandle(data);
      if (canHandle) {
        await handler.handle(data);
      }
    }
  }

  void emit(dynamic data) {
    unawaited(emitAsync(data));
  }

  void addHandler(EventEmitterHandlerBase handler) {
    _handlers.add(handler);
  }

  void removeHandler(EventEmitterHandlerBase handler) {
    _handlers.removeWhere((element) => element == handler);
  }
}

extension EventEmitterExtension on EventEmitter {
  void on<T>(EventEmitterHandlerFunction<T> callback) {
    _handlers.add(TypedEventEmitterHandler<T>(callback));
  }

  void remove<T>(EventEmitterHandlerFunction<T> callback) {
    _handlers.removeWhere((element) {
      return element is TypedEventEmitterHandler<T> &&
          element.handleFunction == callback;
    });
  }
}
