import 'package:artemis/artemis.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as j;

//turn artemis client codes into graphql_flutter client codes
extension GraphQLQueryExtension<T, U extends j.JsonSerializable>
    on GraphQLQuery<T, U> {
  QueryOptions toQueryOption(
      {Duration pullInterval = Duration.zero,
      bool fetchResults = true,
      FetchPolicy? fetchPolicy,
      ErrorPolicy? errorPolicy,
      bool? networkOnly,
      CacheRereadPolicy? cacheRereadPolicy,
      Context? context}) {
    return QueryOptions(
      document: document,
      operationName: operationName,
      variables: getVariablesMap(),
      pollInterval: pullInterval,
      context: context,
      fetchPolicy:
          fetchPolicy ?? (networkOnly == true ? FetchPolicy.networkOnly : null),
      errorPolicy: errorPolicy,
      cacheRereadPolicy: cacheRereadPolicy,
    );
  }

  WatchQueryOptions toWatchQuery(
      {Duration pullInterval = Duration.zero,
      bool fetchResults = true,
      FetchPolicy? fetchPolicy,
      ErrorPolicy? errorPolicy,
      bool? networkOnly,
      CacheRereadPolicy? cacheRereadPolicy,
      Context? context}) {
    return WatchQueryOptions(
        document: document,
        operationName: operationName,
        variables: getVariablesMap(),
        pollInterval: pullInterval,
        fetchResults: true,
        fetchPolicy: fetchPolicy ??
            (networkOnly == true ? FetchPolicy.networkOnly : null),
        errorPolicy: errorPolicy,
        cacheRereadPolicy: cacheRereadPolicy,
        eagerlyFetchResults: true,
        context: context);
  }

  WatchQueryOptions toNetworkOnlyWatchQuery(
      {Duration pullInterval = Duration.zero,
      bool fetchResults = true,
      ErrorPolicy? errorPolicy,
      CacheRereadPolicy? cacheRereadPolicy,
      Context? context}) {
    return WatchQueryOptions(
        document: document,
        operationName: operationName,
        variables: getVariablesMap(),
        pollInterval: pullInterval,
        fetchResults: true,
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: errorPolicy,
        cacheRereadPolicy: cacheRereadPolicy,
        eagerlyFetchResults: true,
        context: context);
  }
}

extension GraphQLMutationExtension<T, U extends j.JsonSerializable>
    on GraphQLQuery<T, U> {
  MutationOptions toMutationOption({Context? context}) {
    return MutationOptions(
        document: document,
        operationName: operationName,
        variables: getVariablesMap(),
        context: context);
  }
}
