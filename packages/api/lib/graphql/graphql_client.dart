import 'dart:async';

import 'package:artech_api/api.dart';
import 'package:artech_core/core.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide JsonSerializable;

Future<String> _getFromTokenManager() async {
  final token = await serviceLocator.get<TokenManager>().get();
  return token?.token;
}

String uuidFromObject(Object object) {
  if (object is Map<String, Object>) {
    final String typeName = object['__typename'] as String;
    final String id = object['id']?.toString();
    if (typeName != null && id != null) {
      return <String>[typeName, id].join('/');
    }
  }
  return null;
}

GraphQLClient clientFor(String url,
    {Future<String> Function() getTokenFromStorage = _getFromTokenManager,
    String subscriptionUri}) {
  final Link httpLink = HttpLink(url);
  final authLink = _MyAuthLink(
    getToken: () async {
      final token = await getTokenFromStorage();
      final ret = token == null ? null : 'Bearer $token';
      return ret;
    },
  );
  var link = authLink.concat(httpLink);
  if (subscriptionUri != null) {
    final WebSocketLink websocketLink = WebSocketLink(
      subscriptionUri,
    );
    link = link.concat(websocketLink);
  }
  return GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: link,
      defaultPolicies: DefaultPolicies(
          query: Policies(fetch: FetchPolicy.cacheAndNetwork),
          watchQuery: Policies(fetch: FetchPolicy.cacheAndNetwork)));
}

typedef _RequestTransformer = FutureOr<Request> Function(Request request);

class _MyAuthLink extends AuthLink {
  _MyAuthLink(
      {@required FutureOr<String> Function() getToken,
      String headerKey = 'Authorization'})
      : super(getToken: getToken, headerKey: headerKey);

  @override
  Stream<Response> request(
    Request request, [
    NextLink forward,
  ]) async* {
    final req = await transform(headerKey, getToken)(request);
    yield* forward(req);
  }

  static _RequestTransformer transform(
    String headerKey,
    FutureOr<String> Function() getToken,
  ) =>
      (Request request) async {
        //check if need auth
        final disableAuth = request.context.entry<DisableAuthEntry>();
        if (disableAuth != null) {
          return request;
        }
        final token = await getToken();
        if (token != null) {
          return request.updateContextEntry<HttpLinkHeaders>(
            (headers) => HttpLinkHeaders(
              headers: <String, String>{
                ...headers?.headers ?? <String, String>{},
                headerKey: token,
              },
            ),
          );
        } else {
          return request.updateContextEntry<HttpLinkHeaders>(
            (headers) => HttpLinkHeaders(
              headers: <String, String>{
                ...headers?.headers ?? <String, String>{},
              },
            ),
          );
        }
      };
}
