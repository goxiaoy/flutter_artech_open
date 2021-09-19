import 'emitter.dart';

void main() async {
  String secretKey = "L8fRRzdy8fn_FHYr1uzBCSQqGerHBiUR";
  Emitter _emitter = Emitter();
  _emitter.onMessage((EmitterMessage message) {
    print("New message: ${message.channel} -> ${message.asString()}");
  });
  _emitter.onPresence((dynamic obj) {
    print("OnPresence:");
    print(obj);
  });
  await _emitter.connect(
      host: "localhost", port: 8080, secure: false, logging: true);
  String _key = await _emitter.keygen(secretKey, "mychannel/#/", "rwslp", 0);
  print("Key generated:" + _key);
  print("Subscribing to mychannel/hello presence");
  _emitter.subscribePresence(_key, "mychannel/");
  print("Subscribing to mychannel/hello");
  _emitter.subscribe(_key, "mychannel/hello", handler: (message) {
    print("Inline message handler:" +
        message.channel +
        " => " +
        message.asString());
  });
  print("Publishing message to mychannel");
  _emitter.publish(_key, "mychannel/hello", "Hello from Flutter Emitter");
  dynamic pr = await _emitter.getPresence(_key, "mychannel/hello");
  print(pr);
  dynamic me = await _emitter.getMe();
  print(me);
  dynamic linkResult =
      await _emitter.link(_key, "mychannel/privatelink/", "rq", true, true);
  print(linkResult);
  _emitter.publishWithLink("rq", "Hello");
}
