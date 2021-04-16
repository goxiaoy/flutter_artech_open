import 'dart:async';
import 'dart:convert';

import 'package:artech_core/core.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

import 'token_model.dart';

///[TokenStorage] stores tokens and check expire time. Please use [TokenManager] to safely get token
class TokenStorage with ServiceGetter, HasSelfLoggerTyped<TokenStorage> {
  TokenStorage({this.key = 'jwt'});

  final BehaviorSubject<TokenModel?> subject = BehaviorSubject<TokenModel>();

  PersistentSecurityStorageBase get _storage =>
      services.get<PersistentSecurityStorageBase>();
  final String key;

  //Must be called when app stated
  Future<void> init() async {
    //get initial value from storage
    final s = await _storage.get(key);
    final token = _getFormStringOrNull(s);
    subject.add(token);
  }

  Future<TokenModel?> get() async {
    final res = subject.value;
    return res;
  }

  Future<void> set(TokenModel? token) async {
    if (token == null) {
      await _storage.delete(key);
    } else {
      await _storage.set(key, json.encode(token.toJson()));
    }
    logger.info('Update token successfully!');
    subject.add(token);
  }

  Future<void> clear() async {
    return await set(null);
  }

  TokenModel? _getFormStringOrNull(String? s) {
    if (s == null || s.isEmpty) {
      return null;
    } else {
      try {
        final res = TokenModel.fromJson(json.decode(s) as Map<String, dynamic>);
        return res;
      } catch (e) {
        logger.log(Level.SEVERE,
            'Deserialize token failed exception : ${e.toString()}');
        return null;
      }
    }
  }

  //Listen to token update
  Stream<TokenModel?> get stream => subject.stream;
}
