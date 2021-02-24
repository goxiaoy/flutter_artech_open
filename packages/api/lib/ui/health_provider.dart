import 'package:artech_api/health/health.dart';
import 'package:artech_core/core.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HealthProvider extends HookWidget {
  HealthProvider({@required this.child})
      : canCheckEndpoint = serviceLocator.isRegistered<HealthCheckEndpoint>();

  final Widget child;

  final bool canCheckEndpoint;
  @override
  Widget build(BuildContext context) {
    final connectState =
        useMemoizedStream(() => Connectivity().onConnectivityChanged);
    final network = connectState.connectionState != ConnectionState.none;
    return canCheckEndpoint
        ? HookBuilder(
            builder: (context) {
              final endpoint = serviceLocator.get<HealthCheckEndpoint>();
              final AsyncSnapshot<HealthCheckData> healthCheckData =
                  useMemoizedStream(() => endpoint.connect());
              return HealthState(
                isConnected: network && !healthCheckData.hasError,
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
            isConnected: network,
            child: child,
          );
  }
}

Duration _calLatency(DateTime a, DateTime b) {
  if (a == null || b == null) {
    return null;
  }
  return b.difference(a);
}

class HealthState extends InheritedWidget {
  const HealthState({
    Key key,
    @required this.isConnected,
    @required Widget child,
  }) : super(key: key, child: child);
  final bool isConnected;

  static HealthState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HealthState>();
  }

  @override
  bool updateShouldNotify(covariant HealthState oldWidget) {
    return oldWidget.isConnected != isConnected;
  }
}

class LatencyState extends InheritedWidget {
  const LatencyState({
    Key key,
    @required Widget child,
    this.toServerLatency,
    this.fromServerLatency,
    this.serverTime,
  }) : super(key: key, child: child);

  final Duration toServerLatency;
  final Duration fromServerLatency;
  final DateTime serverTime;

  static LatencyState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LatencyState>();
  }

  bool get isClientTimeIncorrect {
    final opt = serviceLocator.get<HealthCheckOption>();
    return fromServerLatency == null
        ? null
        : (fromServerLatency > opt.clientTolerateDuration ||
            fromServerLatency < opt.clientTolerateDuration);
  }

  @override
  bool updateShouldNotify(covariant LatencyState oldWidget) {
    return toServerLatency != oldWidget.toServerLatency &&
        fromServerLatency != oldWidget.toServerLatency;
  }
}
