import 'package:artech_core/core.dart';
import 'package:flutter/material.dart';
import 'package:artech_ui_kit/ui_kit.dart';

const String _kIndexKey = 'app.ui_kit.house_page';

abstract class HousePage extends StatefulWidget {
  const HousePage() : super();

  Map<Tab, Widget> tabWidget(BuildContext context);

  @override
  State<StatefulWidget> createState() {
    return _HousePageState();
  }
}

class _HousePageState extends State<HousePage>
    with SingleTickerProviderStateMixin, MixinSettingState {
  TabController? _tabController;
  int? index;

  Map<Tab, Widget> get tabWidget => widget.tabWidget(context);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HousePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (tabWidget.length != oldWidget.tabWidget(context).length) {
      _tabController?.dispose();
      _tabController = TabController(
          vsync: this, length: tabWidget.length, initialIndex: index!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldBuilder(context,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: _tabController != null
              ? Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      indicatorColor: Theme.of(context).primaryColor,
                      labelColor: Colors.black,
                      controller: _tabController,
                      tabs: [...tabWidget.keys],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [...tabWidget.values.toList()],
                      ),
                    ),
                  ],
                )
              : Container(),
        ));
  }

  @override
  Future<void> onSharedPreferenceInitialized() async {
    index = await settingStore.get(_kIndexKey, defaultValue: 0);
    if (index! >= tabWidget.length) index = 0;
    _tabController = TabController(
        vsync: this, length: tabWidget.length, initialIndex: index!);

    _tabController!.addListener(() async {
      settingStore.set(_kIndexKey, _tabController!.index);
    });
  }
}
