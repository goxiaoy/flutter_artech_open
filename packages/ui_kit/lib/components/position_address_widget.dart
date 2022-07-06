import 'dart:async';

import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart' hide Position;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// PositionAddressWidget
/// Get address base upon location
class PositionAddressWidget extends StatefulWidget {
  final LocationAccuracy desiredAccuracy;
  final int distanceFilter;
  final Duration? timeLimit;

  const PositionAddressWidget({
    Key? key,
    this.distanceFilter = 0,
    this.timeLimit,
    this.desiredAccuracy = LocationAccuracy.best,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PositionAddressWidgetState();
  }
}

class _PositionAddressWidgetState extends State<PositionAddressWidget>
    with HasNamedLogger {
  List<AddressData> _address = [];
  AddressData? _selected;
  Position? _position;
  LocationPermission? _permission;
  bool? _enabled;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _showPosition = false;
  Timer? _timer;

  void _listener(Position position) {
    _position = position;
    logger.info('Current position $_position');
    _updateAddress();
    //serviceLocator.get<BackgroundLocation>().saveLocation(_position!);
  }

  void _updateAddress() async {
    if (_position != null) {
      _address = await decoder.fromPosition(
          PositionData(lat: _position!.latitude, lon: _position!.longitude));
      if (_selected == null && _address.length > 0) _selected = _address.first;
    }
    if (mounted) setState(() {});
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
      showErrorDialog(S.of(context).locationSettings, error,
          stackTrace: stackTrace);
    });
    // if (_position != null)
    //   serviceLocator.get<BackgroundLocation>().saveLocation(_position!);
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
    return _selected != null
        ? ListTile(
            onTap: () async {
              showCupertinoModalPopup(
                  context: context,
                  builder: (_) => CupertinoActionSheet(
                        title: Text(S.of(context).selectAddress),
                        actions: [
                          ..._address
                              .map<Widget>((e) => CupertinoButton(
                                    child: Text(e.address1!),
                                    onPressed: () {
                                      setState(() {
                                        _selected = e;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ))
                              .toList()
                        ],
                        cancelButton: CupertinoButton(
                          child: Text(S.of(context).cancel),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ));
            },
            leading: Icon(Icons.location_on_outlined),
            title: Text('${_selected!.address1}'),
            trailing: ForwardIcon(),
          )
        : Container();
  }

  @override
  String get loggerName => 'PositionAddressWidget';
}
