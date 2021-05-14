import 'package:flutter/cupertino.dart';

@immutable
class SortField {
  const SortField({required this.name, this.desc = false});
  static SortField? fromString(String? str) {
    if (str == null) {
      return null;
    }
    final lastIndex = str.lastIndexOf(':');
    if (lastIndex == -1) {
      return SortField(name: str);
    } else {
      final parts = [
        str.substring(0, lastIndex).trim(),
        str.substring(lastIndex + 1).trim()
      ];
      if (parts[1].toUpperCase() == 'DESC') {
        return SortField(name: parts[0], desc: true);
      }
      if (parts[1].toUpperCase() == 'ASC') {
        return SortField(name: parts[0], desc: false);
      }
      throw UnsupportedError('not end with :DESC/:ASC');
    }
  }

  final String name;
  final bool desc;

  @override
  int get hashCode => name.hashCode ^ desc.hashCode;

  @override
  bool operator ==(Object other) {
    return (other is SortField) && (other.name == name && other.desc == desc);
  }

  @override
  String toString() => '$name:${desc ? "DESC" : "ASC"}';
}

@immutable
class Pagination {
  const Pagination({this.offset = 0, this.limit = 10});
  final int offset;
  final int limit;

  @override
  int get hashCode => offset.hashCode ^ limit.hashCode;

  @override
  bool operator ==(Object other) {
    return (other is Pagination) &&
        (other.offset == offset && other.limit == limit);
  }
}
