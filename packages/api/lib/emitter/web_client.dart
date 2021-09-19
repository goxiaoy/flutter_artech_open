import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

MqttClient getClient(
  String server,
  String clientIdentifier, {
  int maxConnectionAttempts = 3,
}) {
  return MqttBrowserClient(server, clientIdentifier,
      maxConnectionAttempts: maxConnectionAttempts);
}
