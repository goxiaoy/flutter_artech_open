import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

typedef RefreshFunc<T> = Future<T> Function();

class RefreshablePage extends StatefulWidget {
  //If child is  extends ScrollView,It will help you get the internal slivers and add footer and header in it.
  /// else it will put child into SliverToBoxAdapter and add footer and header
  final Widget? child;

  const RefreshablePage({Key? key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RefreshablePageState();

  static RefreshablePageMixin? of(BuildContext context) {
    return context.findAncestorStateOfType<RefreshablePageMixin>();
  }
}

class RefreshablePageState extends State<RefreshablePage>
    with RefreshablePageMixin<RefreshablePage> {
  @override
  Widget build(BuildContext context) {
    return buildRefreshWidget(context, widget.child!);
  }
}

mixin RefreshablePageMixin<T extends StatefulWidget> on State<T> {
  final RefreshController _controller = RefreshController();

  final List<RefreshFunc> _refreshFuncs = [];

  Widget buildRefreshWidget(BuildContext context, Widget child) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      controller: _controller,
      onRefresh: () async {
        //find handlers
        try {
          for (final f in _refreshFuncs) {
            await f();
          }
          _controller.refreshCompleted();
        } catch (e) {
          _controller.refreshFailed();
        }
      },
      child: child,
    );
  }

  void Function() addListener(RefreshFunc f) {
    _refreshFuncs.add(f);
    return () {
      _refreshFuncs.removeWhere((element) => element == f);
    };
  }

  ///manual call refresh
  Future refreshAll({bool needMove = false}) async {
    return Future.microtask(
        () => _controller.requestRefresh(needMove: needMove));
  }
}
