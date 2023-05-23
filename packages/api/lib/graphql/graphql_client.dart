import 'dart:async';

import 'package:artech_api/api.dart';
import 'package:artech_core/core.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide JsonSerializable;
import 'package:timezone/timezone.dart' as tz;

Future<String?> _getFromTokenManager() async {
  final token = await serviceLocator.get<TokenManager>().get();
  return token?.token;
}

String? uuidFromObject(Object object) {
  if (object is Map<String, Object>) {
    final String? typeName = object['__typename'] as String?;
    final String? id = object['id']?.toString();
    if (typeName != null && id != null) {
      return <String>[typeName, id].join('/');
    }
  }
  return null;
}

Future<GraphQLClient> clientFor(String url,
    {Future<String?> Function() getTokenFromStorage = _getFromTokenManager,
    String? subscriptionUri,
    Store? store}) async {
  final Link httpLink = HttpLink(url);
  final authLink = _MyAuthLink(
    getToken: () async {
      final token = await getTokenFromStorage();
      final ret = token == null ? null : 'Bearer $token';
      return ret;
    },
  );
  var link = authLink
      .concat(
          //just use authlink to add header
          AuthLink(getToken: () async => tz.local.name, headerKey: 'X-TZ'))
      .concat(httpLink);
  if (subscriptionUri != null) {
    final WebSocketLink websocketLink = WebSocketLink(
      subscriptionUri,
    );
    link = link.concat(websocketLink);
  }
  final s = store ?? await serviceLocator.safelyGetServiceAsync<Store>();
  return GraphQLClient(
      cache: GraphQLCache(store: s),
      link: link,
      defaultPolicies: DefaultPolicies(
          //query just ignore cache
          query: Policies(
              fetch: FetchPolicy.noCache,
              cacheReread: CacheRereadPolicy.ignoreAll),
          watchQuery: Policies(
              fetch: FetchPolicy.cacheAndNetwork,
              cacheReread: CacheRereadPolicy.ignoreAll)));
}

typedef _RequestTransformer = FutureOr<Request> Function(Request request);

class _MyAuthLink extends Link {
  _MyAuthLink({required this.getToken, this.headerKey = 'Authorization'});
  final FutureOr<String?> Function() getToken;
  final String headerKey;
  @override
  Stream<Response> request(
    Request request, [
    NextLink? forward,
  ]) async* {
    final req = await transform(headerKey, getToken)(request);
    yield* forward!(req);
  }

  static _RequestTransformer transform(
    String headerKey,
    FutureOr<String?> Function() getToken,
  ) =>
      (Request request) async {
        //check if need auth
        final disableAuth = request.context.entry<DisableAuthEntry>();
        if (disableAuth != null) {
          return request;
        }
        final token = await getToken()!;
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
