import 'dart:async';

import 'package:artech_core/core.dart';
import 'package:url_launcher/url_launcher.dart' as URL;

class LaunchService with HasNamedLogger {
  LaunchService();

  Future<bool> call(String? number) async {
    try {
      return await URL.launchUrl(Uri.parse("tel:$number"));
    } catch (error, stackTrace) {
      logger.severe(error, [error, stackTrace]);
      rethrow;
    }
  }

  // TODO:
  Future<bool> sendSms(String? number) async {
    try {
      return await URL.launchUrl(Uri.parse("sms:$number"));
    } catch (error, stackTrace) {
      logger.severe(error, [error, stackTrace]);
      rethrow;
    }
  }

  // TODO:
  Future<bool> sendEmail(String email) async {
    try {
      return await URL.launchUrl(Uri.parse("mailto:$email"));
    } catch (error, stackTrace) {
      logger.severe(error, [error, stackTrace]);
      rethrow;
    }
  }

  Future<bool> webView(String url,
      {bool enableJavaScript = true, bool enableDomStorage = true}) async {
    try {
      return await URL.launchUrl(
        Uri.parse(url),
        webViewConfiguration: URL.WebViewConfiguration(
            enableJavaScript: enableJavaScript,
            enableDomStorage: enableDomStorage),
      );
    } catch (error, stackTrace) {
      logger.severe(error, [error, stackTrace]);
      rethrow;
    }
  }

  Future<bool> launch(String url,
      {bool enableJavaScript = true, bool enableDomStorage = true}) async {
    try {
      return await URL.launchUrl(Uri.parse(url),
          webViewConfiguration: URL.WebViewConfiguration(
              enableJavaScript: enableJavaScript,
              enableDomStorage: enableDomStorage),
          webOnlyWindowName: null);
    } catch (error, stackTrace) {
      logger.severe(error, [error, stackTrace]);
      rethrow;
    }
  }

  @override
  String get loggerName => 'LaunchService';
}
