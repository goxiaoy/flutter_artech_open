import 'package:artech_core/store/kv_store.dart';

import 'persistent_security_storage_stub.dart'
    if (dart.library.io) 'app_persistent_security_storage.dart'
    if (dart.library.html) 'web_persistent_security_storage.dart';

abstract class PersistentSecurityStorage implements KVStoreTyped<String?> {
  factory PersistentSecurityStorage() {
    return _singleton;
  }

  static final PersistentSecurityStorage _singleton = getSecurityStorage();
}
