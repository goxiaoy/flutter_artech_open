import 'package:artemis/artemis.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as j;

//turn artemis client codes into graphql_flutter client codes
extension GraphQLQueryExtension<T, U extends j.JsonSerializable>
    on GraphQLQuery<T, U> {
  QueryOptions toQueryOption() {
    return QueryOptions(
        document: document,
        operationName: operationName,
        variables: getVariablesMap());
  }

  WatchQueryOptions toWatchQuery(
      {Duration pullInterval = Duration.zero, bool fetchResults = true}) {
    return WatchQueryOptions(
        document: document,
        operationName: operationName,
        variables: getVariablesMap(),
        pollInterval: pullInterval,
        fetchResults: true,
        eagerlyFetchResults: true);
  }
}

extension GraphQLMutationExtension<T, U extends j.JsonSerializable>
    on GraphQLQuery<T, U> {
  MutationOptions toMutationOption() {
    return MutationOptions(
        document: document,
        operationName: operationName,
        variables: getVariablesMap());
  }
}
