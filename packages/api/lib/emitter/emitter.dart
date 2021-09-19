import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_data.dart';

import 'client_stub.dart'
    if (dart.library.io) 'server_client.dart'
    if (dart.library.html) 'web_client.dart';

typedef EmitterCallback = void Function(Emitter emitter);
typedef EmitterSubscribeCallback = void Function(String? topic);
typedef EmitterPresenceCallback = void Function(dynamic object);
typedef EmitterMessageCallback = void Function(EmitterMessage message);

class Emitter {
  late MqttClient _mqtt;
  String _rpcChannel = '';
  String _rpcKey = '';
  String _myId = '';
  int _rpcId = 0;
  final ReverseTrie _trie = ReverseTrie(level: -1);
  bool _logging = false;

  final _onConnectHandlers = <EmitterCallback>[];
  void onConnect(EmitterCallback handler) => _onConnectHandlers.add(handler);
  final _onDisconnectHandlers = <EmitterCallback>[];
  void onDisconnect(EmitterCallback handler) =>
      _onDisconnectHandlers.add(handler);
  final _onSubscribedHandlers = <EmitterSubscribeCallback>[];
  void onSubscribed(EmitterSubscribeCallback handler) =>
      _onSubscribedHandlers.add(handler);
  final _onUnsubscribedHandlers = <EmitterSubscribeCallback>[];
  void onUnsubscribed(EmitterSubscribeCallback handler) =>
      _onUnsubscribedHandlers.add(handler);
  final _onSubscribeFailHandlers = <EmitterSubscribeCallback>[];
  void onSubscribeFail(EmitterSubscribeCallback handler) =>
      _onSubscribeFailHandlers.add(handler);
  final _onPresenceHandlers = <EmitterPresenceCallback>[];
  void onPresence(EmitterPresenceCallback handler) =>
      _onPresenceHandlers.add(handler);
  final _onMessageHandlers = <EmitterMessageCallback>[];
  void onMessage(EmitterMessageCallback handler) =>
      _onMessageHandlers.add(handler);

  final Map<int, Completer> _completers = <int, Completer>{};
  final Map<int, Completer> _rpcCompleters = <int, Completer>{};

  Future<bool> connect(
      {bool secure = false,
      String host = 'api.emitter.io',
      String clientIdentifier = '',
      int port = 8080,
      int keepalive = 60,
      bool logging = false,
      bool useWebSocket = false}) async {
    final String brokerUrl =
        (useWebSocket || kIsWeb) ? (secure ? 'wss://' : 'ws://') + host : host;

    _mqtt = getClient(brokerUrl, clientIdentifier);
    if (useWebSocket && !kIsWeb) {
      final serverClient = _mqtt as MqttServerClient;
      serverClient.useWebSocket = true;
      serverClient.useAlternateWebSocketImplementation = false;
    }
    _mqtt.port = port;
    _mqtt.logging(on: logging);
    _mqtt.keepAlivePeriod = keepalive;
    _mqtt.onDisconnected = _onDisconnected;
    _mqtt.onConnected = _onConnected;
    _mqtt.onSubscribed = _onSubscribed;
    _mqtt.onUnsubscribed = _onUnsubscribed;
    _mqtt.onSubscribeFail = _onSubscribeFail;
    _mqtt.pongCallback = _pong;
    _logging = logging;

    final MqttConnectMessage connMess =
        MqttConnectMessage().startClean().withWillQos(MqttQos.atLeastOnce);
    _mqtt.connectionMessage = connMess;

    try {
      await _mqtt.connect();
    } on Exception catch (e) {
      _log('EMITTER::client exception - $e');
      _mqtt.disconnect();
      return false;
    }

    /// Check we are connected
    if (_mqtt.connectionStatus?.state == MqttConnectionState.connected) {
      _log('EMITTER::Mosquitto client connected');
    } else {
      _log(
          'EMITTER::ERROR Mosquitto client connection failed - disconnecting, state is ${_mqtt.connectionStatus?.state}');
      _mqtt.disconnect();
      return false;
    }

    _mqtt.updates!.listen(_onMessage);
    final dynamic me = await getMe();
    _myId = me['id'] as String? ?? '';
    return true;
  }

  /*
  * Publishes a message to the currently opened endpoint.
  */
  int publish(String key, String channel, String message,
      {bool me = true,
      int ttl = 0,
      MqttQos qos = MqttQos.atLeastOnce,
      bool retain = false}) {
    final options = <String, String>{};
    if (!me) options['me'] = '0';
    if (ttl > 0) options['ttl'] = ttl.toString();
    var topic = _formatChannel(key, channel, options);
    return _mqtt.publishMessage(topic, qos, _payload(message), retain: retain);
  }

  /*
  * Publishes a message through a link.
  */
  int publishWithLink(String link, String message) {
    return _mqtt.publishMessage(link, MqttQos.atLeastOnce, _payload(message));
  }

  /*
  * Subscribes to a particular channel.
  */
  Subscription? subscribe(String key, String channel,
      {int last = 0, EmitterMessageCallback? handler}) {
    if (handler != null) _trie.registerHandler(channel, handler);

    final options = <String, String>{};
    if (last > 0) options['last'] = last.toString();
    final topic = _formatChannel(key, channel, options);
    return _mqtt.subscribe(topic, MqttQos.atLeastOnce);
  }

  /*
  * Create a link to a particular channel.
  */
  Future<dynamic> link(
      String key, String channel, String name, bool private, bool subscribe,
      {bool me = true, int ttl = 0, int timeout = 5000}) async {
    final options = <String, String>{};
    if (!me) options['me'] = '0';
    if (ttl > 0) options['ttl'] = ttl.toString();
    String formattedChannel = _formatChannel(null, channel, options);
    var request = {
      'key': key,
      'channel': formattedChannel,
      'name': name,
      'private': private,
      'subscribe': subscribe
    };
    final dynamic response = await _executeAsync(
        'emitter/link/', jsonEncode(request),
        timeout: timeout);
    return response;
  }

  /*
  * Unsubscribes from a particular channel.
  */
  void unsubscribe(String key, String channel) {
    _trie.unRegisterHandler(channel);

    final topic = _formatChannel(key, channel, null);
    _mqtt.unsubscribe(topic);
  }

  /*
  * Sends a key generation request to the server.
  * type is the type of the key to generate.
  * r = Read, w = Write, s = Store, l = Load, p = Presence, e = Extending for private sub-channels
  * You can use any combination like "rw", "rwe" etc.
  * ttl is the time-to-live of the key, in seconds.
  */
  Future<String> keygen(String key, String channel, String type, int ttl,
      {int timeout = 5000}) async {
    final request = {'key': key, 'channel': channel, 'type': type, 'ttl': ttl};
    final dynamic response = await _executeAsync(
        'emitter/keygen/', jsonEncode(request),
        timeout: timeout);
    if (response != null) {
      return response['key'] as String;
    }
    return '';
  }

  /*
  * Subscribes to presence of a channel
  */
  int subscribePresence(String key, String channel) {
    var request = {
      'key': key,
      'channel': channel,
      'status': false,
      'changes': true
    };
    return _mqtt.publishMessage('emitter/presence/', MqttQos.atLeastOnce,
        _payload(jsonEncode(request)));
  }

  /*
  * Gets the presence of a channel
  */
  Future<dynamic> getPresence(String key, String channel,
      {int timeout = 5000}) async {
    final request = {
      'key': key,
      'channel': channel,
      'status': true,
      'changes': false
    };
    final dynamic response = await _executeAsync(
        'emitter/presence/', jsonEncode(request),
        timeout: timeout);
    return response;
  }

  /*
  * Request information about the connection to the server.
  */
  Future<dynamic> getMe({int timeout = 5000}) async {
    final dynamic response =
        await _executeAsync('emitter/me/', '', timeout: timeout);
    return response;
  }

  void initRPC(String channel, String key) {
    if (!channel.endsWith('/')) channel += '/';
    _rpcChannel = channel;
    _rpcKey = key;
    subscribe(_rpcKey, _rpcChannel);
  }

  Future<dynamic> rpc(dynamic payload, {int timeout = 5000}) {
    final id = ++_rpcId;
    final Completer c = Completer<dynamic>();
    _rpcCompleters[id] = c;
    final channel = _rpcChannel + _myId + '/' + id.toString();
    publish(_rpcKey, channel, jsonEncode(payload), me: false);
    Timer(Duration(milliseconds: timeout), () {
      _rpcCompleters.remove(id);
      if (!c.isCompleted) c.completeError('rpc timeout');
    });
    return c.future;
  }

  String _formatChannel(
      String? key, String channel, Map<String, String>? options) {
    var formatted = channel;
    // Prefix with the key if any
    if (key != null && key.isNotEmpty)
      formatted = key.endsWith('/') ? key + channel : key + '/' + channel;
    // Add trailing slash
    if (!formatted.endsWith('/')) formatted += '/';
    // Add options
    if (options != null && options.isNotEmpty) {
      formatted += '?';
      options.forEach((key, value) {
        formatted += key + '=' + value + '&';
      });
    }
    if (formatted.endsWith('&'))
      formatted = formatted.substring(0, formatted.length - 1);
    // We're done compiling the channel name
    return formatted;
  }

  Uint8Buffer _payload(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    return builder.payload!;
  }

  Future<dynamic> _executeAsync(String request, String payload,
      {int timeout = 5000}) {
    Completer c = Completer<dynamic>();
    final int id =
        _mqtt.publishMessage(request, MqttQos.atLeastOnce, _payload(payload));
    _completers[id] = c;
    Timer(Duration(milliseconds: timeout), () {
      _completers.remove(id);
      if (!c.isCompleted) c.completeError('$request timeout');
    });
    return c.future;
  }

  void _onDisconnected() {
    _log('EMITTER::Disconnected');
    _onDisconnectHandlers.forEach((h) => h(this));
    //if (onDisconnect != null) onDisconnect(this);
  }

  void _onConnected() {
    _log('EMITTER::Connected');
    _onConnectHandlers.forEach((h) => h(this));
    //if (onConnect != null) onConnect(this);
  }

  void _onSubscribed(String topic) {
    _log('EMITTER::Subscription confirmed for topic $topic');
    _onSubscribedHandlers.forEach((h) => h(topic));
    //if (onSubscribed != null) onSubscribed(topic);
  }

  void _onUnsubscribed(String? topic) {
    _log('EMITTER::Unsubscription confirmed for topic $topic');
    _onUnsubscribedHandlers.forEach((h) => h(topic));
    //if (onUnsubscribed != null) onUnsubscribed(topic);
  }

  void _onSubscribeFail(String topic) {
    _log('EMITTER::Subscription failed for topic $topic');
    _onSubscribeFailHandlers.forEach((h) => h(topic));
    //if (onSubscribeFail != null) onSubscribeFail(topic);
  }

  void _pong() {
    _log('EMITTER::Pong');
  }

  void _log(Object message) {
    if (_logging) print(message);
  }

  bool _checkRPCResult(EmitterMessage message) {
    var channel = message.channel.substring(0, message.channel.length - 1);
    var id = int.parse(channel.substring(channel.lastIndexOf('/') + 1));
    Completer? c = _rpcCompleters[id];
    if (c != null) {
      _rpcCompleters.remove(id);
      c.complete(message.asObject());
      return true;
    }
    return false;
  }

  bool _checkRequestResult(EmitterMessage message) {
    dynamic obj = message.asObject();
    if (obj['req'] != null) {
      Completer? c = _completers[obj['req']];
      if (c != null) {
        _completers.remove(obj['req']);
        c.complete(obj);
        return true;
      }
    }
    return false;
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage msg = c[0].payload as MqttPublishMessage;
    final String topic = c[0].topic;
    final message = EmitterMessage(topic, msg.payload.message);
    _log('EMITTER::$topic -> ${message.asString()}');
    if (topic.startsWith('emitter/presence')) {
      if (!_checkRequestResult(message))
        _onPresenceHandlers.forEach((h) => h(message.asObject()));
    } else if (topic.startsWith('emitter/keygen') ||
        topic.startsWith('emitter/link') ||
        topic.startsWith('emitter/me')) {
      _checkRequestResult(message);
    } else {
      bool callMessageHandler = true;
      if (_rpcChannel != '' && topic.startsWith(_rpcChannel)) {
        callMessageHandler = !_checkRPCResult(message);
      }
      if (callMessageHandler) {
        _onMessageHandlers.forEach((h) => h(message));
        _trie.match(message.channel).forEach((h) => h(message));
      }
    }
  }
}

class EmitterMessage {
  EmitterMessage(String topic, Uint8Buffer payload)
      : channel = topic,
        binary = payload;

  late String channel;
  late Uint8Buffer binary;
  String? _string;
  dynamic _object;

  String asString() {
    _string ??= MqttPublishPayload.bytesToStringAsString(binary);
    return _string!;
  }

  dynamic asObject() {
    if (_object == null) {
      try {
        _object = jsonDecode(asString());
      } catch (err) {}
    }
    return _object;
  }
}

class ReverseTrie {
  late Map<String, ReverseTrie> children;
  late int level;
  EmitterMessageCallback? value;

  ReverseTrie({int level = 0}) {
    children = <String, ReverseTrie>{};
    level = level;
    value = null;
  }

  void registerHandler(String channel, EmitterMessageCallback value) {
    _setValue(_createKey(channel), 0, value);
  }

  void unRegisterHandler(String channel) {
    _tryRemove(_createKey(channel), 0);
  }

  List<EmitterMessageCallback> match(String channel) {
    final query = _createKey(channel);
    final result = _recurMatch(query, 0, children);
    return result;
  }

  EmitterMessageCallback? _setValue(
      List<String> key, int position, EmitterMessageCallback value) {
    if (position == key.length) {
      this.value = value;
      return this.value;
    }

    ReverseTrie? child;
    if (children[key[position]] != null) {
      child = children[key[position]];
    } else {
      child = ReverseTrie(level: position);
      children[key[position]] = child;
    }
    return child?._setValue(key, position + 1, value);
  }

  List<String> _createKey(String channel) {
    return channel
        .replaceAll(RegExp('^[/]+'), '')
        .replaceAll(RegExp('[/]+\$'), '')
        .split('/');
  }

  bool _tryRemove(List<String> key, int position) {
    if (position == key.length) {
      if (value == null) return false;
      value = null;
      return true;
    }

    // Remove from the child
    final ReverseTrie? child = children[key[position]];
    if (child != null) return child._tryRemove(key, position + 1);

    value = null;
    return false;
  }

  List<EmitterMessageCallback> _recurMatch(
      List<String> query, int posInQuery, Map<String, ReverseTrie> children) {
    List<EmitterMessageCallback> matches = [];
    if (posInQuery == query.length) return matches;
    ReverseTrie? childNode = children['+'];
    if (childNode != null) {
      if (childNode.value != null) matches.add(childNode.value!);
      matches.addAll(_recurMatch(query, posInQuery + 1, childNode.children));
    }
    childNode = children[query[posInQuery]];
    if (childNode != null) {
      if (childNode.value != null) matches.add(childNode.value!);
      matches.addAll(_recurMatch(query, posInQuery + 1, childNode.children));
    }
    return matches;
  }
}
