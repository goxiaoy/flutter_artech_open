import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

const String _kTimeFormat = 'hh:mm aa';
const String _kDateTimeFormat = 'y MMM d E hh:mm:aa';
const String _kWeekTimeFormat = 'E HH:mm';
const String _kWeekDayFormat = 'E';

extension DateTimeExtension on DateTime {
  tz.TZDateTime get toLocalTZDateTime =>
      tz.TZDateTime.from(isUtc ? toLocal() : this, tz.local);

  String toLocalFormatDayText({String? format}) => format == null
      ? DateFormat.yMMMEd().format(toLocalTZDateTime)
      : DateFormat(format).format(toLocalTZDateTime);

  String toLocalFormatYearText({String? format}) => format == null
      ? DateFormat.y().format(toLocalTZDateTime)
      : DateFormat(format).format(toLocalTZDateTime);

  String toLocalFormatDateTimeText({String? format}) =>
      DateFormat(format ?? _kDateTimeFormat).format(toLocalTZDateTime);

  String toLocalFormatWeekTimeText({String? format}) =>
      DateFormat(format ?? _kWeekTimeFormat).format(toLocalTZDateTime);

  String toLocalFormatTimeText({String? format}) =>
      DateFormat(format ?? _kTimeFormat).format(toLocalTZDateTime);

  String toLocalFormatWeekDayText({String? format}) =>
      DateFormat(format ?? _kWeekDayFormat).format(toLocalTZDateTime);
}

extension DateTimeNullableExtension on DateTime? {
  String? toUtcIso8601String() {
    return dateTimeToUtcIso8601String(this);
  }
}

String? dateTimeToUtcIso8601String(DateTime? t) {
  return t?.toUtc().toIso8601String();
}
