import 'dart:async';

import 'package:artech_core/core.dart';

import 'token_storage.dart';

abstract class RefreshTokenProvider {
  Future<TokenModel?> refreshToken(TokenModel token);
}

class TokenManager with HasNamedLogger {
  TokenManager();
  TokenStorage get tokenStorage => serviceLocator.get<TokenStorage>();

  bool get supportRefreshToken =>
      serviceLocator.isRegistered<RefreshTokenProvider>();

  RefreshTokenProvider get refreshTokenProvider =>
      serviceLocator.get<RefreshTokenProvider>();

  Timer? _refreshTimer;
  Completer<TokenModel?>? _refreshTokenCompleter;

  Future<void> set(TokenModel? token) async {
    await tokenStorage.set(token);
    if (token != null) _startTimer(token.expireAt);
  }

  ///call this after app started
  Future<void> start() async {
    //load token
    final token = await tokenStorage.get();
    _startTimer(token?.expireAt);
  }

  Future<void> clear() async {
    _clearTimer();
    if (_refreshTokenCompleter != null) {
      //TODO cancel this future?
      await _refreshTokenCompleter!.future;
    }
    //clear token
    await tokenStorage.clear();
  }

  Future<TokenModel?> get() async {
    final token = await tokenStorage.get();
    if (token != null && !token.isValid() && _refreshTokenCompleter != null) {
      //token refreshing
      return await _refreshTokenCompleter!.future;
    } else {
      return token == null ? null : (token.isValid() ? token : null);
    }
  }

  Future<void> _startTimer(DateTime? expireAt) async {
    if (!supportRefreshToken) {
      return;
    }
    _clearTimer();
    if (expireAt == null) {
      return;
    } else {
      final delayTime = expireAt.add(const Duration(minutes: -1));
      //提前时间
      const advanceTime = Duration(minutes: 1);
      final time = delayTime
          .toUtc()
          .subtract(advanceTime)
          .difference(DateTime.now().toUtc());
      if (time < const Duration()) {
        logger.info('Refresh token start immediately!');
        //这里有一个边际情况，如果刚刚返回的refreshtoken检测expire会不再刷新
        _fetchNewToken();
        // Timer.run(() {
        //    _fetchNewToken();
        // });
      } else {
        //TODO flutter timer in web may overflow
        const maxTimer = Duration(days: 14);
        if (time <= maxTimer) {
          _refreshTimer = Timer(time, () => _fetchNewToken());
          logger.info('Refresh token start in  ${time.inMinutes} minutes!');
        } else {
          logger.info('Refresh token timer ignored due to long period');
        }
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
    _refreshTokenCompleter = Completer<TokenModel?>();
    final tokenModel = await tokenStorage.get();
    if (tokenModel == null) {
      return null;
    }
    TokenModel? newToken;

    try {
      newToken = await refreshTokenProvider.refreshToken(tokenModel);
      logger.info('Refresh token successfully');
      await set(newToken);
    } catch (e, s) {
      logger.severe('Refresh token fail $e', e, s);
      //TODO handle retry
      await set(newToken);
      return newToken;
    } finally {
      _refreshTokenCompleter!.complete(newToken);
      _refreshTokenCompleter = null;
    }
    return newToken;
  }

  @override
  String get loggerName => 'TokenManager';
}
