import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:artech_core/configuration/app_config.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

export 'int.dart';
export 'json_extension.dart';

typedef GetFactory<T> = T? Function();
typedef SetFactory<T> = void Function(T? value);

typedef GetFactoryAsync<T> = Future<T?> Function();
typedef SetFactoryAsync<T> = Future<void> Function(T? value);

T? getOr<T>(GetFactory<T> cache, GetFactory<T> creator,
    {SetFactory<T>? setter}) {
  final cacheValue = cache();
  if (cacheValue != null) {
    return cacheValue;
  }
  //call create
  final createValue = creator();
  if (setter != null) {
    setter(createValue);
  }
  return createValue;
}

Future<T?> getOrAsync<T>(GetFactoryAsync<T> cache, GetFactoryAsync<T> creator,
    {SetFactoryAsync<T>? setter}) async {
  final cacheValue = await cache();
  if (cacheValue != null) {
    return cacheValue;
  }
  //call create
  final createValue = await creator();
  if (setter != null) {
    await setter(createValue);
  }
  return createValue;
}

final _timeLogger = Logger('ProfileStopwatch');
Future<T> executeWithStopwatch<T>(FutureOr<T> Function() f,
    {bool debugOnly = true,
    String name = '',
    int thresholdMilliseconds = 20,
    Function(int t)? overAction}) async {
  if (!debugOnly || kIsDebug) {
    _timeLogger.fine('Start execution $name');
    final Stopwatch sw = Stopwatch();
    sw.start();
    Timeline.startSync(name);
    final res = await f();
    Timeline.finishSync();
    sw.stop();
    if (sw.elapsedMilliseconds > thresholdMilliseconds) {
      _timeLogger.warning('Execute $name cost: ${sw.elapsedMilliseconds}');
      overAction?.call(sw.elapsedMilliseconds);
    } else {
      _timeLogger.fine('Execute $name cost: ${sw.elapsedMilliseconds}');
    }
    return res;
  } else {
    Timeline.startSync(name);
    final res = await f();
    Timeline.finishSync();
    return res;
  }
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<E> mapIndexed<E>(E Function(int index, T item) f) sync* {
    var index = 0;
    for (final item in this) {
      yield f(index, item);
      index = index + 1;
    }
  }
}

///dfs access node
void dfs<T, TKey>(
  T node,
  TKey Function(T node) keyAccessor,
  Iterable<T> Function(T node) childrenAccessor,
  void Function(T node, List<T> parents) access,
) {
  return _dfsWithParent(
      node, keyAccessor, childrenAccessor, access, HashSet<TKey>(), <T>[]);
}

void _dfsWithParent<T, TKey>(
    T node,
    TKey Function(T node) keyAccessor,
    Iterable<T> Function(T node) childrenAccessor,
    void Function(T node, List<T> parents) access,
    HashSet<TKey> accessed,
    List<T> parents) {
  final children = childrenAccessor(node);
  if (children.isNotEmpty) {
    parents.add(node);
    for (final child in children) {
      if (!accessed.contains(keyAccessor(child))) {
        _dfsWithParent(
            child, keyAccessor, childrenAccessor, access, accessed, parents);
      }
    }
    parents.remove(node);
  }
  access(node, parents);
  accessed.add(keyAccessor(node));
}

extension BoolParsing on String? {
  bool? parseBool() {
    return this == null ? null : this!.toLowerCase() == 'true';
  }
}

Future<String> createFolderInAppDocDir(String folderName) async {
//Get this App Document Directory
  final Directory _appDocDir = await getApplicationDocumentsDirectory();
//App Document Directory + folder name
  final Directory _appDocDirFolder =
      Directory('${_appDocDir.path}/$folderName/');

  if (_appDocDirFolder.existsSync()) {
    //if folder already exists return path
    return _appDocDirFolder.path;
  } else {
    //if folder not exists create folder and then return its path
    final Directory _appDocDirNewFolder =
        await _appDocDirFolder.create(recursive: true);
    return _appDocDirNewFolder.path;
  }
}
