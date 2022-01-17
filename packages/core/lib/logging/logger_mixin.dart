import 'package:artech_core/core.dart';
import 'package:logging/logging.dart';

// @Deprecated('Use HasNamedLogger instead')
// mixin HasNamedLogger<T> {
//   final Logger logger = Logger(T.toString());
// }

mixin HasNamedLoggerFinal {
  late final Logger logger;
}

mixin HasNamedLogger {
  String get loggerName;

  Logger? _logger;
  Logger get logger {
    return getOr<Logger?>(() => _logger, () => Logger(loggerName),
        setter: (Logger? l) => _logger = l)!;
  }
}

Level? convertLogLevelFromString(String? level, {Level? l}) {
  if (level == null) {
    return null;
  }
  var logLevel = l ?? Level.INFO;

  switch (level.toUpperCase()) {
    case 'ALL':
      logLevel = Level.ALL;
      break;
    case 'FINEST':
      logLevel = Level.FINEST;
      break;
    case 'FINER':
      logLevel = Level.FINER;
      break;
    case 'FINE':
      logLevel = Level.FINE;
      break;
    case 'CONFIG':
      logLevel = Level.CONFIG;
      break;
    case 'INFO':
      logLevel = Level.INFO;
      break;
    case 'WARNING':
      logLevel = Level.WARNING;
      break;
    case 'SEVERE':
      logLevel = Level.SEVERE;
      break;
    case 'SHOUT':
      logLevel = Level.SEVERE;
      break;
    case 'OFF':
      logLevel = Level.OFF;
      break;
    default:
      throw ArgumentError.value(level, 'Level should be one of ');
  }
  return logLevel;
}
