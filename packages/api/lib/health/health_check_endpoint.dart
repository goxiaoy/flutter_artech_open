part of 'health.dart';

/// a remote endpoint which fire health check status periodically
abstract class HealthCheckEndpoint {
  Stream<HealthCheckData> connect();
  void disconnect() {}
}

class ClientSelfHealthCheckEndpoint extends HealthCheckEndpoint {
  ClientSelfHealthCheckEndpoint();

  Duration get duration =>
      serviceLocator.get<HealthCheckOption>().checkDuration;

  Timer? t;
  @override
  Stream<HealthCheckData> connect() {
    return Stream.periodic(duration, (t) {
      return HealthCheckData()
        ..serverTime = DateTime.now()
        ..clientReceiveTime = DateTime.now();
    });
  }
}
