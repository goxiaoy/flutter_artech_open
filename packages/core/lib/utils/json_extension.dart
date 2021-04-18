import 'package:artech_core/configuration/app_config.dart';
import 'package:logging/logging.dart';

typedef FromJsonFunc<T> = T Function(Map<String, dynamic> json);

Logger _logger = Logger('JsonExtension');

extension JsonExtension on Map<String, dynamic>? {
  T toData<T>(FromJsonFunc<T> func) {
    if (this == null) {
      _logger.warning(
          'Parse to $T from  null will cause empty object creation from empty map');
    }
    final map = this ?? <String, dynamic>{};
    final T ret = func(map);
    if (kIsDebug) {
      //compare and check missing keys
      final retJsonKeys =
          (ret as dynamic).toJson().keys.toList() as List<String>;
      final missingKeys = map.entries
          .where((element) => element.value != null)
          .map((e) => e.key)
          .where((element) => !retJsonKeys.contains(element))
          .where((element) => element != '__typename')
          .toList();
      if (missingKeys.isNotEmpty) {
        _logger.warning(
            "convert json to [${T.toString()}] missing keys [${missingKeys.join(',')}]");
      }
    }
    return ret;
  }
}
