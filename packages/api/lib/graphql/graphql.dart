import 'package:artech_core/core.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide ExceptionHandler;
import 'package:logging/logging.dart';

export 'package:artech_api/graphql/graphql_query_extension.dart';
export 'package:artech_api/graphql/hooks/hooks.dart';
export 'package:artech_api/graphql/remote_repository_base.dart';

export 'disable_auth_entry.dart';
export 'observable_query_stream_provider.dart';

class ServerExceptionHandler implements ExceptionHandlerBase {
  @override
  bool canHandle(Object exception) {
    return exception is ServerException;
  }

  @override
  void handle(ExceptionContext context) {
    final e = context.latestError as ServerException;
    if (e.originalException != null) {
      context.addError(e.originalException);
      context.processor.processContext(context);
      return;
    } else {
      if (e.parsedResponse != null) {
        context.parsedException = UserFriendlyException(
            code: 'ServerException',
            message: e.parsedResponse.errors.tryGetMessage().join('\n'));
        context.hasHandled = true;
      }
    }
  }
}

class OperationExceptionHandler implements ExceptionHandlerBase {
  @override
  bool canHandle(Object exception) {
    return exception is OperationException;
  }

  @override
  void handle(ExceptionContext context) {
    final e = context.latestError as OperationException;
    if (e.linkException != null) {
      context.addError(e.linkException);
      context.processor.processContext(context);
      return;
    }
    context.parsedException = UserFriendlyException(
        code: e.graphqlErrors.tryGetCode().join('\n'),
        message: e.graphqlErrors.tryGetMessage().join('\n'));

    context.hasHandled = true;
  }
}

final _logger = Logger('GraphQLErrorExtension');

extension GraphQLErrorExtension on GraphQLError {
  int tryGetStatusCode() {
    int res;
    try {
      //extensions.exception.data.statusCode
      res = int.parse(extensions['exception']['code'].toString());
    } catch (e, s) {
      _logger.severe(e, e, s);
    }
    return res;
  }

  List<String> tryGetCode() {
    List<String> res = <String>[];

    try {
      if (extensions['exception']['data'] != null) {
        //extensions.exception.data.data.messages[].id
        final List<dynamic> m =
            extensions['exception']['data']['data'] as List<dynamic>;
        final Iterable<String> codes = m.fold<List<dynamic>>(<dynamic>[],
            (List<dynamic> value, dynamic element) {
          value.addAll(element['messages'] as List<dynamic>);
          return value;
        }).map((dynamic p) => p['id'].toString());
        res = List<String>.from(codes);
      }
    } catch (e, s) {
      _logger.severe(e, e, s);
    }

    return res;
  }

  List<String> tryGetMessage() {
    List<String> res = [];
    try {
      if (extensions['exception']['data'] != null) {
        //extensions.exception.data.data.messages.message
        final List<dynamic> m =
            extensions['exception']['data']['data'] as List<dynamic>;
        final Iterable<String> messages = m.fold<List<dynamic>>(<dynamic>[],
            (List<dynamic> value, dynamic element) {
          value.addAll(element['messages'] as List<dynamic>);
          return value;
        }).map((dynamic p) => p['message'].toString());
        res = List<String>.from(messages);
      }
    } catch (e, s) {
      _logger.severe(e, e, s);
    }

    return res;
  }
}

extension GraphQLErrorListExtension on Iterable<GraphQLError> {
  List<String> tryGetCode() {
    if (this == null) {
      return [];
    }
    return map((e) => e.tryGetCode()).fold([], (value, element) {
      value.addAll(element);
      return value;
    });
  }

  List<String> tryGetMessage() {
    if (this == null) {
      return [];
    }
    return map((e) => e.tryGetMessage()).fold([], (value, element) {
      value.addAll(element);
      return value;
    });
  }
}
