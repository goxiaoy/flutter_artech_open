import 'package:artech_api/health/health.dart';
import 'package:artech_core/core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HealthProvider extends HookWidget {
  HealthProvider({required this.child})
      : canCheckEndpoint = serviceLocator.isRegistered<HealthCheckEndpoint>();

  final Widget child;

  final bool canCheckEndpoint;
  @override
  Widget build(BuildContext context) {
    final connectState =
        useMemoizedStream(() => Connectivity().onConnectivityChanged);
    final hasNetwork = connectState.connectionState != ConnectionState.none;
    RemoteConnectionState s = hasNetwork
        ? RemoteConnectionState.Connected
        : RemoteConnectionState.Disconnect;
    return canCheckEndpoint
        ? HookBuilder(
            builder: (context) {
              final endpoint = serviceLocator.get<HealthCheckEndpoint>();
              final AsyncSnapshot<RemoteConnectionState?> remoteState =
                  useMemoizedStream<RemoteConnectionState?>(
                      () => endpoint.state());

              final AsyncSnapshot<HealthCheckData?> healthCheckData =
                  useMemoizedStream(() => endpoint.health());

              if (remoteState.hasData && remoteState.data != null) {
                s = remoteState.data!;
              }

              return HealthState(
                connectionState: s,
                child: LatencyState(
                  child: child,
                  serverTime: healthCheckData.data?.serverTime,
                  toServerLatency: _calLatency(healthCheckData.data?.serverTime,
                      healthCheckData.data?.clientReceiveTime),
                  fromServerLatency: _calLatency(
                      healthCheckData.data?.clientReceiveTime,
                      healthCheckData.data?.serverTime),
                ),
              );
            },
          )
        : HealthState(
            connectionState: s,
            child: child,
          );
  }
}

Duration? _calLatency(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return null;
  }
  return b.difference(a);
}

class HealthState extends InheritedWidget {
  const HealthState({
    Key? key,
    required this.connectionState,
    required Widget child,
  }) : super(key: key, child: child);
  final RemoteConnectionState connectionState;

  static HealthState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HealthState>();
  }

  @override
  bool updateShouldNotify(covariant HealthState oldWidget) {
    return oldWidget.connectionState != connectionState;
  }
}

class LatencyState extends InheritedWidget {
  const LatencyState({
    Key? key,
    required Widget child,
    this.toServerLatency,
    this.fromServerLatency,
    this.serverTime,
  }) : super(key: key, child: child);

  final Duration? toServerLatency;
  final Duration? fromServerLatency;
  final DateTime? serverTime;

  static LatencyState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LatencyState>();
  }

  bool? get isClientTimeIncorrect {
    final opt = serviceLocator.get<HealthCheckOption>();
    return fromServerLatency == null
        ? null
        : (fromServerLatency! > opt.clientTolerateDuration ||
            fromServerLatency! < opt.clientTolerateDuration);
  }

  @override
  bool updateShouldNotify(covariant LatencyState oldWidget) {
    return toServerLatency != oldWidget.toServerLatency &&
        fromServerLatency != oldWidget.toServerLatency;
  }
}
