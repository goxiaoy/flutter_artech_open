// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:equatable/equatable.dart';

const _groupOperators = [
  FilterOperator.and,
  FilterOperator.or,
  FilterOperator.nor,
];

/// Possible operators to use in filters.
enum FilterOperator {
  /// Matches values that are equal to a specified value.
  equal,

  /// Matches all values that are not equal to a specified value.
  notEqual,

  /// Matches values that are greater than a specified value.
  greater,

  /// Matches values that are greater than a specified value.
  greaterOrEqual,

  /// Matches values that are less than a specified value.
  less,

  /// Matches values that are less than or equal to a specified value.
  lessOrEqual,

  /// Matches any of the values specified in an array.
  in_,

  /// Matches none of the values specified in an array.
  notIn,

  /// Matches values by performing text search with the specified value.
  query,

  /// Matches values with the specified prefix.
  autoComplete,

  /// string contains query
  like,

  /// Matches values that exist/don't exist based on the specified boolean value.
  exists,

  /// Matches all the values specified in an array.
  and,

  /// Matches at least one of the values specified in an array.
  or,

  /// Matches none of the values specified in an array.
  nor,
}

/// Helper extension for [FilterOperator]
extension FilterOperatorX on FilterOperator {
  /// Converts [FilterOperator] into rew values
  String get rawValue => {
        FilterOperator.equal: r'$eq',
        FilterOperator.notEqual: r'$ne',
        FilterOperator.greater: r'$gt',
        FilterOperator.greaterOrEqual: r'$gte',
        FilterOperator.less: r'$lt',
        FilterOperator.lessOrEqual: r'$lte',
        FilterOperator.in_: r'$in',
        FilterOperator.notIn: r'$nin',
        FilterOperator.query: r'$q',
        FilterOperator.autoComplete: r'$autocomplete',
        FilterOperator.like: r'$like',
        FilterOperator.exists: r'$exists',
        FilterOperator.and: r'$and',
        FilterOperator.or: r'$or',
        FilterOperator.nor: r'$nor',
      }[this]!;
}

class Filter extends Equatable {
  const Filter.__({
    required this.operator,
    required this.value,
    this.key,
  });

  Filter._({
    required FilterOperator operator,
    required this.value,
    this.key,
  }) : operator = operator.rawValue;

  /// Combines the provided filters and matches the values
  /// matched by all filters.
  factory Filter.and(List<Filter> filters) =>
      Filter._(operator: FilterOperator.and, value: filters);

  /// Combines the provided filters and matches the values
  /// matched by at least one of the filters.
  factory Filter.or(List<Filter> filters) =>
      Filter._(operator: FilterOperator.or, value: filters);

  /// Combines the provided filters and matches the values
  /// not matched by all the filters.
  factory Filter.nor(List<Filter> filters) =>
      Filter._(operator: FilterOperator.nor, value: filters);

  /// Matches values that are equal to a specified value.
  factory Filter.equal(String key, Object value) =>
      Filter._(operator: FilterOperator.equal, key: key, value: value);

  /// Matches all values that are not equal to a specified value.
  factory Filter.notEqual(String key, Object value) =>
      Filter._(operator: FilterOperator.notEqual, key: key, value: value);

  /// Matches values that are greater than a specified value.
  factory Filter.greater(String key, Object value) =>
      Filter._(operator: FilterOperator.greater, key: key, value: value);

  /// Matches values that are greater than a specified value.
  factory Filter.greaterOrEqual(String key, Object value) =>
      Filter._(operator: FilterOperator.greaterOrEqual, key: key, value: value);

  /// Matches values that are less than a specified value.
  factory Filter.less(String key, Object value) =>
      Filter._(operator: FilterOperator.less, key: key, value: value);

  /// Matches values that are less than or equal to a specified value.
  factory Filter.lessOrEqual(String key, Object value) =>
      Filter._(operator: FilterOperator.lessOrEqual, key: key, value: value);

  /// Matches any of the values specified in an array.
  factory Filter.in_(String key, List<Object> values) =>
      Filter._(operator: FilterOperator.in_, key: key, value: values);

  /// Matches none of the values specified in an array.
  factory Filter.notIn(String key, List<Object> values) =>
      Filter._(operator: FilterOperator.notIn, key: key, value: values);

  /// Matches values by performing text search with the specified value.
  factory Filter.query(String key, String text) =>
      Filter._(operator: FilterOperator.query, key: key, value: text);

  /// Matches values with the specified prefix.
  factory Filter.autoComplete(String key, String text) =>
      Filter._(operator: FilterOperator.autoComplete, key: key, value: text);

  /// Matches values with the specified prefix.
  factory Filter.like(String key, String text) =>
      Filter._(operator: FilterOperator.like, key: key, value: text);

  /// Matches values that exist/don't exist based on the specified boolean value.
  factory Filter.exists(String key, {bool exists = true}) =>
      Filter._(operator: FilterOperator.exists, key: key, value: exists);

  /// Creates a custom [Filter] if there isn't one already available.
  const factory Filter.custom({
    required String operator,
    required Object value,
    String? key,
  }) = Filter.__;

  /// An operator used for the filter. The operator string must start with `$`
  final String operator;

  /// The "left-hand" side of the filter.
  /// Specifies the name of the field the filter should match.
  ///
  /// Some operators like `and` or `or`,
  /// don't require the key value to be present.
  /// see-more : [_groupOperators]
  final String? key;

  /// The "right-hand" side of the filter.
  /// Specifies the [value] the filter should match.
  final Object /*List<Object>|List<Filter>|String*/ value;

  @override
  List<Object?> get props => [operator, key, value];

  /// Serializes to json object
  Map<String, Object> toJson() {
    final json = <String, Object>{};
    final groupOperators = _groupOperators.map((it) => it.rawValue);

    assert(
      groupOperators.contains(operator) || key != null,
      'Filter must contain the `key` when the operator is not a '
      'group operator.',
    );

    if (groupOperators.contains(operator)) {
      // Filters with group operators are encoded in the following form:
      // { $<operator>: [ <filter 1>, <filter 2> ] }
      json[operator] = value;
    } else {
      // Normal filters are encoded in the following form:
      // { key: { $<operator>: <value> } }
      json[key!] = {operator: value};
    }

    return json;
  }
}
