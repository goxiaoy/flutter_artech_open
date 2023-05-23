import 'dart:async';

import 'package:artech_ui_kit/hooks/hooks.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:artech_core/core.dart';

class PaginationResult<T> {
  int? totalSize;
  int? filteredSize;
  Iterable<T> items = [];
  String? nextAfterPageToken;
  String? nextBeforePageToken;

  PaginationResult(
      {this.totalSize,
      this.filteredSize,
      this.items = const [],
      this.nextAfterPageToken,
      this.nextBeforePageToken});
}

typedef RequestFunc<TData, TParams> = FutureOr<PaginationResult<TData>>
    Function(TokenPaginationValue<TData, TParams> params);

typedef TokenPaginationBuilder<TData, TParams> = Widget Function(
    TokenPaginationValue<TData, TParams> value);

class TokenPaginationWidget<TData, TParams> extends StatefulHookConsumerWidget {
  final int limit;

  final RequestFunc<TData, TParams> request;

  final bool enablePullDown;
  final bool enablePullUp;
  final bool initialRefresh;
  final bool preserveStateOnRefresh;

  final TokenPaginationBuilder<TData, TParams> builder;

  TokenPaginationWidget(
      {required this.request,
      required this.builder,
      this.limit = 10,
      this.enablePullDown = true,
      this.enablePullUp = true,
      this.initialRefresh = true,
      this.preserveStateOnRefresh = true});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      TokenPaginationWidgetState<TData, TParams>();
}

class TokenPaginationWidgetState<TData, TParams>
    extends ConsumerState<TokenPaginationWidget<TData, TParams>>
    with HasNamedLogger {
  late TokenPaginationValue<TData, TParams> tokenPaginationValue =
      TokenPaginationValue<TData, TParams>(limit: widget.limit);

  final RefreshController controller = RefreshController(initialRefresh: false);

  Future loadAfterMore() async {
    try {
      final ret = await widget.request(tokenPaginationValue);

      tokenPaginationValue.updateResult(
          nextAfterPageToken: ret.nextAfterPageToken,
          nextBeforePageToken: ret.nextBeforePageToken,
          //append data
          data: [...tokenPaginationValue.data ?? [], ...ret.items]);
      controller.loadComplete();
      if (ret.totalSize != null &&
          ((tokenPaginationValue.data?.length ?? 0) >= ret.totalSize!)) {
        controller.loadNoData();
      }
      if (ret.items.length < tokenPaginationValue.limit) {
        controller.loadNoData();
      }
    } catch (e) {
      logger.severe(e);
      controller.loadFailed();
    }
  }

  Future forceRefresh() async {
    if (widget.enablePullDown) {
      controller.requestRefresh();
    } else {
      await refresh();
    }
  }

  Future refresh() async {
    //clear data
    try {
      tokenPaginationValue.clearToken();
      if (!widget.preserveStateOnRefresh) {
        tokenPaginationValue.clearData();
      }
      final ret = await widget.request(tokenPaginationValue);

      tokenPaginationValue.updateResult(
          nextAfterPageToken: ret.nextAfterPageToken,
          nextBeforePageToken: ret.nextBeforePageToken,
          data: ret.items);
      controller.refreshCompleted();
      if (ret.items.length < tokenPaginationValue.limit) {
        controller.loadNoData();
      }
    } catch (e) {
      logger.severe(e);
      controller.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = useListenable(tokenPaginationValue);
    useEffect(() {
      token.limit = widget.limit;
      return null;
    }, [widget.limit]);
    useMemoized(() {
      if (widget.initialRefresh) {
        Future.microtask(refresh);
      }
    }, []);
    useRefreshablePage(context, forceRefresh);

    return SmartRefresher(
      enablePullDown: widget.enablePullDown,
      enablePullUp: widget.enablePullUp,
      controller: controller,
      onLoading: loadAfterMore,
      onRefresh: refresh,
      // listBuilder call has not state info, null data will cause problems!!!-Charles
      child: widget.builder(tokenPaginationValue),
    );
  }

  @override
  String get loggerName => "TokenPaginationWidgetState";
}
