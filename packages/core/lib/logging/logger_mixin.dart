import 'package:logging/logging.dart';

mixin HasSelfLoggerTyped<T> {
  final Logger logger = Logger(T.toString());
}
