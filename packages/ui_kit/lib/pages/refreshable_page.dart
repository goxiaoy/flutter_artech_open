import 'dart:async';

import 'package:artech_ui_kit/provider/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef RefreshFunc<T> = Future<T> Function();

class RefreshablePage extends StatefulWidget {
  //If child is  extends ScrollView,It will help you get the internal slivers and add footer and header in it.
  /// else it will put child into SliverToBoxAdapter and add footer and header
  final Widget child;

  final EasyRefreshController? controller;

  const RefreshablePage({Key? key, required this.child, this.controller})
      : super(key: key);

  @override
  State<RefreshablePage> createState() => _RefreshablePageState();

  static RefreshablePageStateMixin? of(BuildContext context) {
    return context.findAncestorStateOfType<RefreshablePageStateMixin>();
  }
}

class _RefreshablePageState extends State<RefreshablePage>
    with RefreshablePageStateMixin {
  @override
  void initState() {
    refreshController =
        widget.controller ?? EasyRefreshController(controlFinishRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildRefreshable(context, widget.child);
  }
}

mixin RefreshablePageStateMixin<T extends StatefulWidget> on State<T> {
  late EasyRefreshController refreshController;

  Widget buildRefreshable(BuildContext context, Widget? child) {
    return Consumer(
      child: child,
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final cfg = ref.watch(easyRefreshConfigProvider);
        return EasyRefresh(
          header: cfg.header?.call(context),
          controller: refreshController,
          onRefresh: () async {
            try {
              callRefresh();
              refreshController.finishRefresh(IndicatorResult.success, true);
            } catch (e) {
              refreshController.finishRefresh(IndicatorResult.fail, true);
            }
          },
          child: child,
        );
      },
    );
  }

  final List<RefreshFunc> _refreshFuncs = [];

  void Function() addListener(RefreshFunc f) {
    _refreshFuncs.add(f);
    return () {
      _refreshFuncs.removeWhere((element) => element == f);
    };
  }

  Future callRefresh() async {
    for (final f in _refreshFuncs) {
      await f();
    }
  }

  ///manual call refresh
  Future refreshAll(
      {Duration? duration = const Duration(milliseconds: 200)}) async {
    return Future.microtask(
        () => refreshController.callRefresh(duration: duration));
  }
}
