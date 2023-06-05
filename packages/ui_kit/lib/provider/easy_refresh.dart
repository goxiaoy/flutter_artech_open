import 'package:easy_refresh/easy_refresh.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class EasyRefreshConfiguration {
  /// Header indicator.
  final Header Function(BuildContext context)? header;

  /// Footer indicator.
  final Footer Function(BuildContext context)? footer;

  EasyRefreshConfiguration({this.header, this.footer});
}

final easyRefreshConfigProvider = Provider<EasyRefreshConfiguration>(
  (ref) => EasyRefreshConfiguration(
    header: (context) => ClassicHeader(
      dragText: S.of(context).pullToRefresh,
      armedText: S.of(context).releaseToRefresh,
      readyText: S.of(context).refreshing,
      processingText: S.of(context).refreshing,
      processedText: S.of(context).refreshFinish,
      noMoreText: S.of(context).noMore,
      failedText: S.of(context).refreshFailed,
      messageText: S.of(context).updateAt,
      safeArea: false,
    ),
    footer: (context) => ClassicFooter(
      position: IndicatorPosition.locator,
      dragText: S.of(context).pushToLoad,
      armedText: S.of(context).releaseToLoad,
      readyText: S.of(context).loading,
      processingText: S.of(context).loading,
      processedText: S.of(context).loaded,
      noMoreText: S.of(context).noMore,
      failedText: S.of(context).loadFailed,
      messageText: S.of(context).updateAt,
    ),
  ),
);
