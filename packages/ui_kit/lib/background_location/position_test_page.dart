
import 'package:flutter/material.dart';
import 'package:artech_ui_kit/ui_kit.dart';

class PositionTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuilder(context,title: Text('Position test page'),),
      body: PositionWidget(
        child: Center(
          child: Text('Touch page to see position'),
        ),
      ),
    );
  }

}