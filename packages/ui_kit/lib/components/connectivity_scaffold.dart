import 'package:flutter/material.dart';
import 'connectivity_widget.dart';

class ConnectivityScaffold extends StatelessWidget {
  final Key? key;
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final List<Widget>? persistentFooterButtons;
  final bool? resizeToAvoidBottomInset;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const ConnectivityScaffold(
      {this.key,
      this.body,
      this.appBar,
      this.bottomNavigationBar,
      this.persistentFooterButtons,
      this.resizeToAvoidBottomInset,
      this.floatingActionButton,
        this.backgroundColor,
      this.floatingActionButtonLocation})
      : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: appBar,
      persistentFooterButtons: persistentFooterButtons,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: backgroundColor,
      body: body != null
          ? ConnectivityContainer(
              child: body!,
            )
          : null,
    );
  }
}
