import 'package:artech_api/graphql/date_time_parser.dart';
import 'package:http/http.dart';

DateTime fromGraphQLDateTimeToDartDateTime(String date) =>
    fromGraphQLDateTimeToDartDateTimeNullable(date)!;

DateTime? fromGraphQLDateTimeToDartDateTimeNullable(String? date) =>
    date == null ? null : DateTimeParser.fromGraphQLDateTime(date);

DateTime fromGraphQLDateToDartDateTime(String date) =>
    fromGraphQLDateToDartDateTimeNullable(date)!;

DateTime? fromGraphQLDateToDartDateTimeNullable(String? date) =>
    date == null ? null : DateTimeParser.fromGraphQLDate(date);

DateTime fromGraphQLTimeToDartDateTime(String time) =>
    fromGraphQLTimeToDartDateTimeNullable(time)!;

DateTime? fromGraphQLTimeToDartDateTimeNullable(String? time) =>
    time == null ? null : DateTimeParser.fromGraphQLTime(time);

// TODO(Goxiaoy): check date
String fromDartDateTimeToGraphQLDate(DateTime date) =>
    fromDartDateTimeToGraphQLDateNullable(date)!;

String? fromDartDateTimeToGraphQLDateNullable(DateTime? date) =>
    date == null ? null : DateTimeParser.toGraphQlDateTime(date);

String fromDartDateTimeToGraphQLTime(DateTime date) =>
    fromDartDateTimeToGraphQLTimeNullable(date)!;

String? fromDartDateTimeToGraphQLTimeNullable(DateTime? date) =>
    date == null ? null : DateTimeParser.toGraphQlTime(date);

String fromDartDateTimeToGraphQLDateTime(DateTime dateTime) =>
    fromDartDateTimeToGraphQLDateTimeNullable(dateTime)!;

String? fromDartDateTimeToGraphQLDateTimeNullable(DateTime? dateTime) {
  if (dateTime != null) {
    return DateTimeParser.toGraphQlDateTime(dateTime);
  }
  return null;
}

MultipartFile fromGraphQLUploadToDartMultipartFile(MultipartFile file) => file;
MultipartFile fromDartMultipartFileToGraphQLUpload(MultipartFile file) => file;
