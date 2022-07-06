import 'dart:async';

import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/background_location/background_location.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PositionWidget extends StatefulWidget {
  final Widget child;
  final LocationAccuracy desiredAccuracy;
  final int distanceFilter;
  final Duration? timeLimit;

  final double? left;
  final double? top;
  final double? bottom;
  final double? right;

  const PositionWidget({
    Key? key,
    required this.child,
    this.distanceFilter = 0,
    this.timeLimit,
    this.left,
    this.right,
    this.bottom,
    this.top,
    this.desiredAccuracy = LocationAccuracy.best,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PositionWidgetState();
  }
}

class _PositionWidgetState extends State<PositionWidget> with HasNamedLogger {
  Position? _position;
  LocationPermission? _permission;
  bool? _enabled;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _showPosition = false;
  Timer? _timer;

  void _listener(Position position) {
    _position = position;
    logger.info('Current position $_position');
    serviceLocator.get<BackgroundLocation>().saveLocation(_position!);
  }

  void _startTimer() {
    _stopTimer();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _stopTimer();
      setState(() {
        _showPosition = false;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<Null> _update() async {
    _permission = await Geolocator.checkPermission();
    _position = await Geolocator.getCurrentPosition();
    _enabled = await Geolocator.isLocationServiceEnabled();
    _positionStreamSubscription = Geolocator.getPositionStream(
            locationSettings: LocationSettings(
                accuracy: widget.desiredAccuracy,
                distanceFilter: widget.distanceFilter,
                timeLimit: widget.timeLimit))
        .listen(_listener, onError: (error, stackTrace) {
      showErrorDialog(S.of(context).locationSettings, error, stackTrace: stackTrace);
    });
    if (_position != null)
      serviceLocator.get<BackgroundLocation>().saveLocation(_position!);
    logger.info('update $_permission $_enabled $_position');
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  void dispose() {
    _stopTimer();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
            onTap: () {
              if (_showPosition) {
                _stopTimer();
              } else {
                _startTimer();
              }
              setState(() {
                _showPosition = !_showPosition;
              });
            },
            child: widget.child),
        if (_position != null && _showPosition)
          Positioned(
            right: widget.right ?? 8.0,
            top: widget.top ?? 8.0,
            bottom: widget.bottom,
            left: widget.left,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              decoration: BoxDecoration(color: Colors.black),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Lat:${_position!.latitude.toStringAsFixed(4)}',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'Lon:${_position!.longitude.toStringAsFixed(4)}',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          )
      ],
    );
  }

  @override
  String get loggerName => 'PositionWidget';
}
