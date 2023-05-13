import 'package:flutter/material.dart';
import 'package:artech_ui_kit/ui_kit.dart';

class LaunchTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuilder(
        context,
        title: Text('Test Launge'),
      ),
      body: Column(
        children: [
          PhoneWidget(phoneCall: false, phoneNumber: '6266749135'),
          PhoneWidget(phoneNumber: '6262868938'),
          EmailWidget(email: 'shao8843@yahoo.com'),
          WebsiteWidget(website: 'https://www.fastbraiin.com/'),
        ],
      ),
    );
  }
}
