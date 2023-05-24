import 'package:artech_core/core.dart';
import 'package:centrifuge/centrifuge.dart';

Future<Client> resolveCentrifugeClient(String url,
    {bool withToken = true, ClientConfig? config}) async {
  final preConfig = config ?? ClientConfig();

  //token
  var getToken = preConfig.getToken;
  if (withToken) {
    getToken = (e) async {
      final token = await serviceLocator.get<TokenManager>().get();
      return token?.token ?? '';
    };
  }
  final client = createClient(
      url,
      ClientConfig(
        token: preConfig.token,
        data: preConfig.data,
        headers: preConfig.headers,
        tlsSkipVerify: preConfig.tlsSkipVerify,
        timeout: preConfig.timeout,
        minReconnectDelay: preConfig.minReconnectDelay,
        maxReconnectDelay: preConfig.maxReconnectDelay,
        maxServerPingDelay: preConfig.maxServerPingDelay,
        getToken: getToken,
        name: preConfig.name,
        version: preConfig.version,
      ));

  return client;
}
