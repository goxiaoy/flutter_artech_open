import 'package:artech_core/utils/utils.dart';
import 'package:logging/logging.dart';

mixin HasSelfLogger {
  Logger? _logger;
  Logger get logger {
    return getOr<Logger?>(() => _logger, () => Logger(runtimeType.toString()),
        setter: (Logger? l) => _logger = l)!;
  }
}

mixin HasSelfLoggerTyped<T> {
  final Logger logger = Logger(T.toString());
}
