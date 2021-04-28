import 'package:artech_core/core.dart';
import 'package:logging/logging.dart';

@Deprecated('Use HasNamedLogger instead')
mixin HasSelfLoggerTyped<T> {
  final Logger logger = Logger(T.toString());
}

mixin HasNamedLogger {
  String get loggerName;

  Logger? _logger;
  Logger get logger {
    return getOr<Logger?>(() => _logger, () => Logger(loggerName),
        setter: (Logger? l) => _logger = l)!;
  }
}
