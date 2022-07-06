import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/hooks/hooks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

//
typedef BuildPaginationHookFunc<T> = AsyncSnapshot<List<T>?> Function(
    PaginationValue<T> p);

class PaginationWrap<T> extends HookWidget {
  PaginationWrap({
    required this.buildFunc,
    required this.listBuilder,
    this.initialFetch = true,
    this.initialUseCache = true,
    this.keyFunc,
    this.initLimit = 10,
  });

  final RefreshController controller = RefreshController();

  final BuildPaginationHookFunc<T> buildFunc;

  final bool initialFetch;

  /// True: the first fetch from cache
  final bool initialUseCache;

  final Widget Function(List<T>? allData, Object? error,
      [StackTrace? stackTrace]) listBuilder;

  final Object Function(T obj)? keyFunc;

  final int initLimit;

  @override
  Widget build(BuildContext context) {
    var p = usePagination<T>(
        initNetworkOnly: initialUseCache == false ? true : false,
        initLimit: initLimit,
        initFetching: initialFetch);
    var preData = useState<List<T>?>(null);
    //new data snapshot
    var dataSnapshot = buildFunc(p);

    // if (fetching.value) {
    //data is fetching
    if (dataSnapshot.data != preData.value || dataSnapshot.hasError) {
      //new data coming or fetch error
      // for paged argument, only the first call need to from cache
      if (!p.networkOnly.value) {
        p.networkOnly.value = true;
      }
      if (dataSnapshot.hasError) {
        //error
        Future.microtask(() {
          if (p.isRefresh.value) {
            controller.refreshFailed();
          } else {
            controller.loadFailed();
          }
        });
      } else {
        if (p.isRefresh.value) {
          Future.microtask(() {
            controller.resetNoData();
            controller.refreshCompleted();
          });
        } else {
          Future.microtask(() {
            controller.loadComplete();
          });
        }
        //append data to the list
        if (dataSnapshot.data != null) {
          if (dataSnapshot.data!.length < p.limit.value) {
            Future.microtask(() {
              controller.loadNoData();
            });
          }
          var newList = p.isRefresh.value == true
              ? <T>[]
              : p.data.value?.toList() ?? <T>[];
          for (var newData in dataSnapshot.data!) {
            if (!newList
                .any((element) => _getKey(element) == _getKey(newData))) {
              newList.add(newData);
            }
          }
          p.data.value = newList;
        }
      }

      p.fetching.value = false; //stop fetching state
      //record preData
      preData.value = dataSnapshot.data;
    }
    // }
    if (p.forceRefreshFlag.value == true) {
      p.forceRefreshFlag.value = false;

      p.refresh();
    }
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: controller,
      onLoading: () {
        p.loadMore();
      },
      onRefresh: () {
        p.refresh();
      },
      // listBuilder call has not state info, null data will cause problems!!!-Charles
      child: listBuilder(p.data.value?.toList(growable: false) ?? [],
          dataSnapshot.error, dataSnapshot.stackTrace),
    );
  }

  Object _getKey(T t) {
    if (keyFunc != null) {
      return keyFunc!.call(t);
    }
    if (t is BaseStringEntity) {
      return t.id;
    } else {
      return Object();
    }
  }
}
