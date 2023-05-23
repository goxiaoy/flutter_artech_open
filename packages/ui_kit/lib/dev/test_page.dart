import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return scaffoldBuilder(context,
        appBar: appBarBuilder(
          context,
          title: new Text("Test Page"),
        ), body: SafeArea(
      child: HookConsumer(builder: (context, ref, child) {
        final value = ref.watch(testingMenuProvider).value;
        return ListView(
          children: value
              .map(
                (e) => e.widget2 != null
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => e.widget2!(context)));
                        },
                        child: Center(
                          child: Text(e.label(context)),
                        ))
                    : e.widget!(context),
              )
              .toList(),
        );
      }),
    ));
  }
}
