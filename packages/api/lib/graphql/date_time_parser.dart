import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:timezone/timezone.dart' as tz;

final _dateFormatter = DateFormat('yyyy-MM-dd');
final _timeFormatter = DateFormat('HH:mm:ss');

final Logger _logger = Logger('DateTimeParser');

class DateTimeParser {
  static DateTime fromGraphQLDateTime(String formattedString) {
    _logger.fine('fromGraphQLDateTime:' + formattedString);
    final DateTime dateTime = DateTime.tryParse(formattedString);
    if (dateTime != null) _logger.fine('dateTime isUtc ${dateTime.isUtc}');
    return dateTime != null
        ? tz.TZDateTime.from(dateTime, tz.local).toLocal()
        : null;
  }

  static DateTime fromGraphQLDate(String formattedString) {
    _logger.fine('fromGraphQLDate:' + formattedString);
    return DateTime.tryParse(formattedString);
  }

  static DateTime fromGraphQLTime(String formattedString) {
    _logger.fine('fromGraphQLTime:' + formattedString);
    final DateTime dateTime =
        DateTime.tryParse('1970-01-01T${formattedString}Z');
    return tz.TZDateTime.from(dateTime, tz.local).toLocal();
  }

  static String toGraphQlDateTime(DateTime dateTime) {
    // if (!dateTime.isUtc) {
    //   _logger.warning('Server date time is not isUtc ${dateTime.toString()}');
    // }
    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(dateTime, tz.local);
    return tzDateTime.toUtc().toIso8601String();
  }

  static String toGraphQlTime(DateTime dateTime) {
    assert(!dateTime.isUtc);
    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(dateTime, tz.local);
    return tzDateTime == null ? null : _timeFormatter.format(tzDateTime);
  }

  static String toGraphQlDate(DateTime dateTime) {
    // assert(!dateTime.isUtc);
    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(dateTime, tz.local);
    return tzDateTime == null ? null : _dateFormatter.format(tzDateTime);
  }
}
