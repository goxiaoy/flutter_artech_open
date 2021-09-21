import 'dart:convert';

import 'emitter.dart';

void main() async {
  String publicChannel = "connection/";
  String publicKey = "GbD4qrt5TUlWjLHJPCrEKMsoG3Ar3kbe";

  Emitter _emitter = Emitter();
  _emitter.onMessage((EmitterMessage message) {
    print("New message: ${message.channel} -> ${message.asString()}");
  });
  _emitter.onPresence((dynamic obj) {
    print("OnPresence:");
    print(obj);
  });
  _emitter.onError((error) {
    print("OnError:");
    print(error);
  });
  await _emitter.connect(host: "10.0.2.2", port: 8080, secure: false);
  //连接public channel
  _emitter.subscribe(publicKey, publicChannel);

  String projectChannel = "thing/vrca/#/";
  String projectKey = "UCLV9uhmuSa5k40VW6hqe0HWHUKJ965v";

  //生成private channel
  var _key = await _emitter.keygen(projectKey, projectChannel, "rwslp", 0);
  if (_key == null) {
    print("Error!!!!!!!!!!!!!!!");
    return;
  }
  print("Key generated:" + _key.key + " channel:" + _key.channel);

  //private channel
  final privateChannel =
      _key.channel.substring(0, _key.channel.lastIndexOf("#/"));

  _emitter.publish(
      _key.key, privateChannel + "register/", json.encode({"tenantId": "0"}));

  // String currentTenantId = "0";
  // _emitter.subscribePresence(_key.key, "thing/");
  // print("Subscribing to thing/hello");
  // _emitter.subscribe(_key, "thing/hello", handler: (message) {
  //   print("Inline message handler:" +
  //       message.channel +
  //       " => " +
  //       message.asString());
  // });
  // print("Publishing message to mychannel");
  // _emitter.publish(_key, "thing/hello", "Hello from Flutter Emitter");
  // dynamic pr = await _emitter.getPresence(_key, "thing/hello");
  // print(pr);
  // dynamic me = await _emitter.getMe();
  // print(me);
  // dynamic linkResult =
  //     await _emitter.link(_key, "thing/privatelink/", "rq", true, true);
  // print(linkResult);
  // _emitter.publishWithLink("rq", "Hello");
}
