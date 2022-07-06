import 'package:artech_api/api.dart';
import 'package:artech_api/health/health.dart';
import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ConnectivityContainer extends StatefulHookWidget {
  final Widget child;

  const ConnectivityContainer({required this.child}) : super();

  @override
  State<StatefulWidget> createState() {
    return _ConnectivityWidgetState();
  }
}

class _ConnectivityWidgetState extends State<ConnectivityContainer>
    with SingleTickerProviderStateMixin, HasNamedLogger {
  // AnimationController animationController;
  @override
  void initState() {
    super.initState();
  }

  @override
  String get loggerName => '_ConnectivityWidgetState';
  @override
  Widget build(BuildContext context) {
    final connected = HealthState.of(context)!;
    return Stack(
      children: [
        widget.child,
        if (connected.connectionState == RemoteConnectionState.Connected)
          Container()
        else if (connected.connectionState == RemoteConnectionState.Disconnect)
          Align(
              alignment: Alignment.bottomCenter, child: _NoConnectivityBanner())
        else if (connected.connectionState == RemoteConnectionState.Connecting)
          Align(alignment: Alignment.bottomCenter, child: _ConnectingBanner())
        // SlideTransition(
        //     position: animationController.drive(Tween<Offset>(
        //       begin: const Offset(0.0, 1.0),
        //       end: Offset.zero,
        //     ).chain(CurveTween(
        //       curve: Curves.fastOutSlowIn,
        //     ))),
        //     child: _NoConnectivityBanner()))
      ],
    );
  }
}

class _NoConnectivityBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        width: double.infinity,
        color: Colors.red[200],
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.error_outline_rounded, color: Colors.white),
            ),
            Text(
              S.of(context).lostConnectivity,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}

class _ConnectingBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        width: double.infinity,
        color: Colors.yellow[200],
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.circle_outlined, color: Colors.white),
            ),
            Text(
              S.of(context).connecting,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}
