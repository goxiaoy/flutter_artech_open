import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient getClient(
  String server,
  String clientIdentifier, {
  int maxConnectionAttempts = 3,
}) {
  return MqttServerClient(server, clientIdentifier,
      maxConnectionAttempts: maxConnectionAttempts);
}
