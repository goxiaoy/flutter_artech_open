import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return scaffoldBuilder(context,
        appBar: appBarBuilder(
          context,
          title: new Text("Test Page"),
          // leading: new IconButton(
          //   icon: new Icon(Icons.ac_unit),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
        ),
        body: SafeArea(
          child: HookBuilder(builder: (BuildContext context) {
            final value = useMenuGroup(testMenuName);
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
