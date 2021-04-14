import 'package:graphql_flutter/graphql_flutter.dart';

class DisableAuthEntry extends ContextEntry {
  @override
  List<Object> get fieldsForEquality => [];
}

extension DisableAuthContextExtension on Context {
  Context disableAuth() {
    return withEntry(DisableAuthEntry());
  }
}
