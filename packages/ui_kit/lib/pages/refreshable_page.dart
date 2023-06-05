import 'dart:async';

import 'package:artech_ui_kit/provider/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef RefreshFunc<T> = Future<T> Function();

class RefreshablePage extends ConsumerStatefulWidget {
  //If child is  extends ScrollView,It will help you get the internal slivers and add footer and header in it.
  /// else it will put child into SliverToBoxAdapter and add footer and header
  final Widget? child;

  final EasyRefreshController? controller;

  const RefreshablePage({Key? key, this.child, this.controller})
      : super(key: key);

  @override
  ConsumerState<RefreshablePage> createState() => RefreshablePageState();

  static RefreshablePageState? of(BuildContext context) {
    return context.findAncestorStateOfType<RefreshablePageState>();
  }
}

class RefreshablePageState extends ConsumerState<RefreshablePage> {
  late EasyRefreshController _controller;

  @override
  void initState() {
    _controller =
        widget.controller ?? EasyRefreshController(controlFinishRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cfg = ref.watch(easyRefreshConfigProvider);
    return EasyRefresh(
      header: cfg.header?.call(context),
      controller: _controller,
      onRefresh: () async {
        try {
          for (final f in _refreshFuncs) {
            await f();
          }
          _controller.finishRefresh(IndicatorResult.success, true);
        } catch (e) {
          _controller.finishRefresh(IndicatorResult.fail, true);
        }
      },
      child: widget.child,
    );
  }

  final List<RefreshFunc> _refreshFuncs = [];

  void Function() addListener(RefreshFunc f) {
    _refreshFuncs.add(f);
    return () {
      _refreshFuncs.removeWhere((element) => element == f);
    };
  }

  ///manual call refresh
  Future refreshAll(
      {Duration? duration = const Duration(milliseconds: 200)}) async {
    return Future.microtask(() => _controller.callRefresh(duration: duration));
  }
}
