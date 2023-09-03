import 'dart:async';

import 'package:artech_ui_kit/hooks/hooks.dart';
import 'package:artech_ui_kit/pagination_result.dart';
import 'package:artech_ui_kit/provider/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:artech_core/core.dart';

class TokenPaginationValue<TData, TParams> extends ChangeNotifier {
  int _limit = 10;
  String? _nextAfterPageToken;
  String? _nextBeforePageToken;
  Iterable<TData>? _data;
  TParams? _params;

  TokenPaginationValue({int limit = 10}) {
    this._limit = limit;
  }

  int get limit => _limit;
  set limit(int v) {
    _limit = v;
    notifyListeners();
  }

  String? get nextAfterPageToken => _nextAfterPageToken;
  String? get nextBeforePageToken => _nextBeforePageToken;
  TParams? get params => _params;
  Iterable<TData>? get data => _data;

  setParams(TParams? v) {
    _params = v;
    notifyListeners();
  }

  clearState() {
    _nextAfterPageToken = _nextBeforePageToken = null;
    notifyListeners();
  }

  clearData() {
    _data = [];
    notifyListeners();
  }

  updateResult(
      {String? nextAfterPageToken,
      String? nextBeforePageToken,
      Iterable<TData>? data}) {
    _nextAfterPageToken = nextAfterPageToken;
    _nextBeforePageToken = nextBeforePageToken;
    _data = data;
    notifyListeners();
  }
}

typedef TokenPaginationRequestFunc<TData, TParams>
    = FutureOr<PaginationResult<TData>> Function(
        TokenPaginationValue<TData, TParams> params);

typedef TokenPaginationBuilder<TData, TParams> = Widget Function(
    TokenPaginationValue<TData, TParams> value);

class TokenPaginationWidget<TData, TParams> extends StatefulHookConsumerWidget {
  final int limit;

  final TokenPaginationRequestFunc<TData, TParams> request;

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
      _TokenPaginationWidgetState<TData, TParams>();
}

class _TokenPaginationWidgetState<TData, TParams>
    extends ConsumerState<TokenPaginationWidget<TData, TParams>>
    with
        HasNamedLogger,
        TokenPaginationWidgetState<TData, TParams,
            TokenPaginationWidget<TData, TParams>> {
  int get limit => widget.limit;
  TokenPaginationRequestFunc<TData, TParams> get request => widget.request;
  bool get enablePullUp => widget.enablePullUp;
  bool get enablePullDown => widget.enablePullDown;
  bool get preserveStateOnRefresh => widget.preserveStateOnRefresh;
  bool get initialRefresh => widget.initialRefresh;
  TokenPaginationBuilder<TData, TParams> get builder => widget.builder;

  @override
  String get loggerName => "_TokenPaginationWidgetState";

  @override
  void initState() {
    pageController = EasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);
    super.initState();
  }
}

mixin TokenPaginationWidgetState<TData, TParams, T extends StatefulWidget>
    on State<T>, HasNamedLogger {
  late TokenPaginationValue<TData, TParams> tokenPaginationValue =
      TokenPaginationValue<TData, TParams>(limit: limit);

  late EasyRefreshController pageController;

  int get limit => 10;
  TokenPaginationRequestFunc<TData, TParams> get request;
  bool get enablePullUp => true;
  bool get enablePullDown => true;
  bool get preserveStateOnRefresh => true;
  bool get initialRefresh => true;

  TokenPaginationBuilder<TData, TParams>? get builder => null;

  Future onLoad() async {
    try {
      final ret = await request(tokenPaginationValue);
      tokenPaginationValue.updateResult(
          nextAfterPageToken: ret.nextAfterPageToken,
          nextBeforePageToken: ret.nextBeforePageToken,
          //append data
          data: [...tokenPaginationValue.data ?? [], ...ret.items]);

      if (ret.totalSize != null &&
          ((tokenPaginationValue.data?.length ?? 0) >= ret.totalSize!)) {
        pageController.finishLoad(IndicatorResult.noMore);
      } else if (ret.items.length < tokenPaginationValue.limit) {
        pageController.finishLoad(IndicatorResult.noMore);
      } else {
        pageController.finishLoad();
      }
    } catch (e) {
      logger.severe(e);
      pageController.finishLoad(IndicatorResult.fail);
    }
  }

  Future forceRefresh() async {
    if (enablePullDown) {
      await pageController.callRefresh();
    } else {
      await onRefresh();
    }
  }

  Future onRefresh() async {
    //clear data
    try {
      tokenPaginationValue.clearState();
      if (!preserveStateOnRefresh) {
        tokenPaginationValue.clearData();
      }
      final ret = await request(tokenPaginationValue);

      tokenPaginationValue.updateResult(
          nextAfterPageToken: ret.nextAfterPageToken,
          nextBeforePageToken: ret.nextBeforePageToken,
          data: ret.items);
      pageController.finishRefresh();
      if (ret.totalSize != null &&
          ((tokenPaginationValue.data?.length ?? 0) >= ret.totalSize!)) {
        pageController.finishLoad(IndicatorResult.noMore);
      } else if (ret.items.length < tokenPaginationValue.limit) {
        pageController.finishLoad(IndicatorResult.noMore);
      }
    } catch (e) {
      logger.severe(e);
      pageController.finishRefresh(IndicatorResult.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = useListenable(tokenPaginationValue);
    useEffect(() {
      token.limit = limit;
      return null;
    }, [limit]);
    useMemoized(() {
      if (initialRefresh) {
        Future.microtask(onRefresh);
      }
    }, [initialRefresh]);
    useRefreshablePage(forceRefresh);
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final cfg = ref.watch(easyRefreshConfigProvider);
        return EasyRefresh(
          header: cfg.header?.call(context),
          footer: cfg.footer?.call(context),
          controller: pageController,
          onLoad: enablePullUp ? onLoad : null,
          onRefresh: enablePullDown ? onRefresh : null,
          // listBuilder call has not state info, null data will cause problems!!!-Charles
          child: builder?.call(tokenPaginationValue),
        );
      },
    );
  }
}
