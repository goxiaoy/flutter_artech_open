part of 'health.dart';

enum RemoteConnectionState {
  Disconnect,
  Connecting,
  Connected,
}

/// a remote endpoint which fire health check status periodically
abstract class HealthCheckEndpoint {
  Stream<HealthCheckData> health();
  Stream<RemoteConnectionState?> state();
  void disconnect() {}
}

class ClientSelfHealthCheckEndpoint extends HealthCheckEndpoint {
  ClientSelfHealthCheckEndpoint();

  Duration get duration =>
      serviceLocator.get<HealthCheckOption>().checkDuration;

  Timer? t;
  @override
  Stream<HealthCheckData> health() {
    return Stream.periodic(duration, (t) {
      return HealthCheckData()
        ..serverTime = DateTime.now()
        ..clientReceiveTime = DateTime.now();
    });
  }

  @override
  Stream<RemoteConnectionState?> state() {
    return Stream<RemoteConnectionState?>.value(null);
  }
}
