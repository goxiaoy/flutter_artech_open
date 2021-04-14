import 'dart:async';

import 'package:artech_core/core.dart';

import 'token_model.dart';
import 'token_storage.dart';

abstract class RefreshTokenProvider {
  Future<TokenModel> refreshToken(TokenModel token);
}

class TokenManager with HasSelfLoggerTyped<TokenManager> {
  TokenManager();
  TokenStorage get tokenStorage => serviceLocator.get<TokenStorage>();
  RefreshTokenProvider get refreshTokenProvider =>
      serviceLocator.get<RefreshTokenProvider>();
  Timer? _refreshTimer;
  Completer<TokenModel>? _refreshTokenCompleter;
  Future set(TokenModel token) async {
    await tokenStorage.set(token);
    _startTimer(token.expireAt);
  }

  Future init() async {
    //load token
    final token = await tokenStorage.get();
    _startTimer(token?.expireAt);
  }

  Future clear() async {
    _clearTimer();
    if (_refreshTokenCompleter != null) {
      //TODO cancel this future?
      await _refreshTokenCompleter!.future;
    }
    //clear token
    await tokenStorage.clear();
  }

  Future<TokenModel?> get() async {
    final token = await tokenStorage.get(checkExpire: false);
    if (token != null && !token.isValid() && _refreshTokenCompleter != null) {
      return await _refreshTokenCompleter!.future;
    } else {
      return token;
    }
  }

  Future<void> _startTimer(DateTime? expireAt) async {
    _clearTimer();
    if (expireAt == null) {
      return;
    } else {
      final delayTime = expireAt.add(const Duration(hours: -1));
      //提前时间
      const advanceTime = Duration(hours: 1);
      final time = delayTime
          .toUtc()
          .subtract(advanceTime)
          .difference(DateTime.now().toUtc());
      if (time < const Duration()) {
        logger.info('Refresh token start immediately!');
        await _fetchNewToken();
      } else {
        logger.info('Refresh token start in  $time seconds!');
        _refreshTimer = Timer(time, () => _fetchNewToken);
      }
    }
  }

  void _clearTimer() {
    if (_refreshTimer != null) {
      _refreshTimer!.cancel();
      _refreshTimer = null;
      logger.info('Refresh token timer stop');
    }
  }

  Future<TokenModel?> _fetchNewToken() async {
    if (_refreshTokenCompleter != null) {
      return await _refreshTokenCompleter!.future;
    }
    _refreshTokenCompleter = Completer<TokenModel>();
    final tokenModel = await tokenStorage.get();
    if (tokenModel == null) {
      return null;
    }
    TokenModel? newToken;

    try {
      newToken = await refreshTokenProvider
          .refreshToken(tokenModel)
          .then((value) async {
        // store token
        await tokenStorage.set(value);
        return value;
      });
    } catch (e, s) {
      logger.severe('Refresh token fail $e', e, s);
      return newToken;
    } finally {
      _refreshTokenCompleter!.complete(newToken);
      _refreshTokenCompleter = null;
    }
    return newToken;
  }
}