import 'dart:async';

import 'package:artech_core/core.dart';

part 'healt_check_data.dart';
part 'health_check_endpoint.dart';

class HealthCheckOption {
  Duration checkDuration = const Duration(seconds: 4);
  Duration clientTolerateDuration = const Duration(minutes: 3);
}
