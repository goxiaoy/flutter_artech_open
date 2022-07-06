import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';

/// scaffoldBuilder Scaffold builder
/// * [connectivityAware] connectivity aware page
/// * [appBar] appBarBuilder will be used if it is null
/// * [decoration] Scaffold decoration
/// * [useDecoration] use or not user background decoration
Widget scaffoldBuilder(BuildContext context,
    {bool connectivityAware = true,
    bool useDecoration = false,
    Widget? body,
    Decoration? decoration,
    PreferredSizeWidget? appBar,
    bool? resizeToAvoidBottomInset,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,

    /// for title, will be ignored if appBar is set
    // TODO: may add assertion
    Widget? title,
    List<Widget>? actions,
    bool? centerTitle,
    Color? backgroundColor,
    Widget? leading,
    bool? closeButton,
    bool Function()? onExit,
    bool? canPop,
    double? elevation,
    Color? shadowColor,
    bool? automaticallyImplyLeading}) {
  final hasTittleBar =
      title != null || actions != null || leading != null || appBar != null;

  final defaultDecoration = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment(0.0, -1.0),
        end: Alignment(0.0, 1.0),
        colors: [Theme.of(context).primaryColor, Colors.purple.shade900]),
  );

  final _body = useDecoration
      ? Container(
          child: body,
        )
      : body;

  final defaultAppBar = hasTittleBar?appBarBuilder(context,
      title: title,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      leading: leading,
      closeButton: closeButton,
      onExit: onExit,
      canPop: canPop,
      elevation: elevation,
      shadowColor: shadowColor,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true):null;

  if (connectivityAware)
    return Container(
        decoration: decoration ?? defaultDecoration,
        child: ConnectivityScaffold(
          bottomNavigationBar: bottomNavigationBar,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          backgroundColor: useDecoration ? Colors.transparent : null,
          appBar: useDecoration ? null : appBar ?? defaultAppBar,
          floatingActionButton: floatingActionButton,
          body: _body,
        ));
  return Container(
    decoration: decoration ?? defaultDecoration,
    child: Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: useDecoration ? Colors.transparent : null,
      appBar: useDecoration ? null : appBar ?? defaultAppBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: _body,
    ),
  );
}
