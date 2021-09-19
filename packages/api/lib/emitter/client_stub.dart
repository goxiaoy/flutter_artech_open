import 'package:mqtt_client/mqtt_client.dart';

MqttClient getClient(
  String server,
  String clientIdentifier, {
  int maxConnectionAttempts = 3,
}) =>
    throw UnsupportedError('Cannot create client');
