import 'dart:async';

import 'package:artech_ui_kit/hooks/hooks.dart';
import 'package:artech_ui_kit/pagination_result.dart';
import 'package:artech_ui_kit/provider/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:artech_core/core.dart';

class PaginationValue<TData, TParams> extends ChangeNotifier {
  int _limit = 10;
  int _currentPage = 0;
  Iterable<TData>? _data;
  TParams? _params;

  PaginationValue({int limit = 10}) {
    this._limit = limit;
  }

  int get limit => _limit;
  set limit(int v) {
    _limit = v;
    notifyListeners();
  }

  int? get currentPage => _currentPage;
  TParams? get params => _params;
  Iterable<TData>? get data => _data;

  setParams(TParams? v) {
    _params = v;
    notifyListeners();
  }

  clearState() {
    _currentPage = 0;
    notifyListeners();
  }

  clearData() {
    _data = [];
    notifyListeners();
  }

  updateResult({Iterable<TData>? data}) {
    _currentPage++;
    _data = data;
    notifyListeners();
  }
}

typedef PaginationRequestFunc<TData, TParams>
    = FutureOr<PaginationResult<TData>> Function(
        PaginationValue<TData, TParams> params);

typedef PaginationBuilder<TData, TParams> = Widget Function(
    PaginationValue<TData, TParams> value);

class PaginationWidget<TData, TParams> extends StatefulHookConsumerWidget {
  final int limit;

  final PaginationRequestFunc<TData, TParams> request;

  final bool enablePullDown;
  final bool enablePullUp;
  final bool initialRefresh;
  final bool preserveStateOnRefresh;

  final PaginationBuilder<TData, TParams> builder;

  PaginationWidget(
      {required this.request,
      required this.builder,
      this.limit = 10,
      this.enablePullDown = true,
      this.enablePullUp = true,
      this.initialRefresh = true,
      this.preserveStateOnRefresh = true});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      PaginationWidgetState<TData, TParams>();
}

class PaginationWidgetState<TData, TParams>
    extends ConsumerState<PaginationWidget<TData, TParams>>
    with HasNamedLogger {
  late PaginationValue<TData, TParams> paginationValue =
      PaginationValue<TData, TParams>(limit: widget.limit);

  final EasyRefreshController controller = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);

  Future loadAfterMore() async {
    try {
      final ret = await widget.request(paginationValue);

      paginationValue.updateResult(
          //append data
          data: [...paginationValue.data ?? [], ...ret.items]);

      if (ret.totalSize != null &&
          ((paginationValue.data?.length ?? 0) >= ret.totalSize!)) {
        controller.finishLoad(IndicatorResult.noMore);
      } else if (ret.items.length < paginationValue.limit) {
        controller.finishLoad(IndicatorResult.noMore);
      } else {
        controller.finishLoad();
      }
    } catch (e) {
      logger.severe(e);
      controller.finishLoad(IndicatorResult.fail);
    }
  }

  Future forceRefresh() async {
    if (widget.enablePullDown) {
      await controller.callRefresh();
    } else {
      await refresh();
    }
  }

  Future refresh() async {
    //clear data
    try {
      paginationValue.clearState();
      if (!widget.preserveStateOnRefresh) {
        paginationValue.clearData();
      }
      final ret = await widget.request(paginationValue);

      paginationValue.updateResult(data: ret.items);

      controller.finishRefresh();
      if (ret.totalSize != null &&
          ((paginationValue.data?.length ?? 0) >= ret.totalSize!)) {
        controller.finishLoad(IndicatorResult.noMore);
      } else if (ret.items.length < paginationValue.limit) {
        controller.finishLoad(IndicatorResult.noMore);
      }
    } catch (e) {
      logger.severe(e);
      controller.finishRefresh(IndicatorResult.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = useListenable(paginationValue);
    useEffect(() {
      token.limit = widget.limit;
      return null;
    }, [widget.limit]);
    useMemoized(() {
      if (widget.initialRefresh) {
        Future.microtask(refresh);
      }
    }, [widget.initialRefresh]);
    useRefreshablePage(forceRefresh);
    final cfg = ref.watch(easyRefreshConfigProvider);
    return EasyRefresh(
      header: cfg.header?.call(context),
      footer: cfg.footer?.call(context),
      controller: controller,
      onLoad: widget.enablePullUp ? loadAfterMore : null,
      onRefresh: widget.enablePullDown ? refresh : null,
      // listBuilder call has not state info, null data will cause problems!!!-Charles
      child: widget.builder(paginationValue),
    );
  }

  @override
  String get loggerName => "PaginationWidgetState";
}
