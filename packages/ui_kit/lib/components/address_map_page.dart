import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AddressMapPage extends StatefulWidget {
  final String address;

  const AddressMapPage({Key? key, required this.address}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddressMapPageState();
  }
}

class _AddressMapPageState extends State<AddressMapPage> with HasNamedLogger {
  Marker _marker(double lat, double lng) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(lat, lng),
      builder: (ctx) => Container(
          child: Icon(
        Icons.location_on_outlined,
        color: Colors.red,
        size: 50.0,
      )),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldBuilder(context,
        title: Text(widget.address),
        body: FutureBuilder<List<PositionData>>(
            future: decoder.fromAddress(widget.address),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.length > 0) {
                  final lat = snapshot.data!.first.lat;
                  final lng = snapshot.data!.first.lon;
                  final markers = [
                    _marker(lat, lng),
                  ];
                  return FlutterMap(
                      options: MapOptions(
                        center: LatLng(lat, lng),
                        zoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                      ]);
                } else {
                  return Container(
                    child: Center(
                      child: Text('Cannot find location'),
                    ),
                  );
                }
              } else {
                if (snapshot.hasError) {
                  showErrorDialog('Map', snapshot.error!,
                      stackTrace: snapshot.stackTrace);
                }
                return Container();
              }
            }));
  }

  @override
  String get loggerName => '_AddressMapPageState';
}
