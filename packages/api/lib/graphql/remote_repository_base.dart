import 'dart:async';

import 'package:artech_core/core.dart';
import 'package:artemis/client.dart' show ArtemisClient;
import 'package:artemis/schema/graphql_query.dart';
import 'package:artemis/schema/graphql_response.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide JsonSerializable;
import 'package:json_annotation/json_annotation.dart';

abstract class GraphQLRemoteRepositoryBase with ServiceGetter, HasSelfLogger {
  ArtemisClient get artemisClient => services.get<ArtemisClient>();
  GraphQLClient get client => services.get<GraphQLClient>();

  //strong typed client
  Future<GraphQLResponse<T>> execute<T, U extends JsonSerializable>(
      GraphQLQuery<T, U> query) async {
    try {
      final response = await artemisClient.execute(query);
      checkGraphQLResponseExceptionAndThrow(response);
      return response;
    } catch (error, stackTrace) {
      logger.severe(error, error, stackTrace);
      rethrow;
    }
  }

  Future<QueryResult> mutate(MutationOptions options) async {
    try {
      final QueryResult result = await client.mutate(options);
      checkQueryResultExceptionAndThrow(result);
      return result;
    } catch (error, stackTrace) {
      logger.severe(error, error, stackTrace);
      rethrow;
    }
  }

  ObservableQuery watchQuery(WatchQueryOptions options) {
    final ObservableQuery result = client.watchQuery(options);
    return result;
  }

  Future<QueryResult> query(QueryOptions options) async {
    try {
      final QueryResult result = await client.query(options);
      checkQueryResultExceptionAndThrow(result);
      return result;
    } catch (error, stackTrace) {
      logger.severe(error, error, stackTrace);
      rethrow;
    }
  }

  void checkQueryResultExceptionAndThrow(QueryResult result) {
    if (result.hasException) {
      logger.severe(result.exception.toString());
      throw result.exception;
    }
  }

  void checkGraphQLResponseExceptionAndThrow<T>(GraphQLResponse<T> response) {
    if (response.hasErrors) {
      logger.severe(response.errors.map((e) => e.toString()).join(''));
      throw coalesceErrors(graphqlErrors: response.errors);
    }
  }
}

typedef QueryResultToTypedData<T> = T Function(
    Map<String, dynamic> json, QueryResult queryResult);

T toSingleData<T>(
    QueryResult queryResult, QueryResultToTypedData<T> fromJson, String key) {
  if (queryResult.data != null) {
    return fromJson(
        (key != null ? queryResult.data[key] : queryResult.data)
            as Map<String, dynamic>,
        queryResult);
  }
  return null;
}

Stream<T> toSingleDataStream<T>(Stream<QueryResult> queryResult,
    QueryResultToTypedData<T> fromJson, String key) {
  return queryResult.map((result) => toSingleData(result, fromJson, key));
}

List<T> toListData<T>(
    QueryResult queryResult, QueryResultToTypedData<T> fromJson, String key) {
  if (queryResult?.data != null && queryResult.data[key] != null) {
    return List<T>.from((queryResult.data[key] as Iterable<dynamic>).map<T>(
        (dynamic e) => fromJson(e as Map<String, dynamic>, queryResult)));
  }
  return <T>[];
}

Stream<List<T>> toListDataStream<T>(Stream<QueryResult> queryResult,
    QueryResultToTypedData<T> fromJson, String key) {
  return queryResult.map((result) => toListData(result, fromJson, key));
}
