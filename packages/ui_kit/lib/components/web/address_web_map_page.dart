import 'dart:ui' as ui;

import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:google_geocoding/google_geocoding.dart' as decode;
import 'package:google_maps/google_maps.dart' as gMap;
import 'package:universal_html/html.dart' as html;

class AddressMapPage extends StatefulWidget {
  final String address;
  final String googleKey;
  const AddressMapPage(
      {Key? key, required this.address, required this.googleKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddressMapPageState();
  }
}

class _AddressMapPageState extends State<AddressMapPage> with HasNamedLogger {
  late decode.GoogleGeocoding googleGeocoding;
  List<decode.GeocodingResult> geocodingResults = [];
  Widget? _map;

  Widget _mapWidget(decode.Location location) {
    final String htmlId = "map";
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final mapOptions = gMap.MapOptions()
        ..zoom = 15.0
        ..center = gMap.LatLng(location.lat, location.lng);

      final elem = html.DivElement()
        ..id = htmlId
        ..style.width = '100%'
        ..style.height = '100%';
      final map = gMap.GMap(elem, mapOptions);

      final _icon = gMap.Icon()
        ..scaledSize = gMap.Size(40, 40)
        //TODO: change icon
        ..url =
            "https://lh3.googleusercontent.com/ogw/ADGmqu_RzXtbUv4nHU9XjdbNtDNQ5XAIlOh_1jJNci48=s64-c-mo";

      gMap.Marker(gMap.MarkerOptions()
        ..anchorPoint = gMap.Point(0.5, 0.5)
        ..icon = _icon
        ..position = gMap.LatLng(location.lat, location.lng)
        ..map = map
        ..title = widget.address);

      return elem;
    });
    return HtmlElementView(viewType: htmlId);
  }

  void geocodingSearch(String value) async {
    var response = await googleGeocoding.geocoding.get(value, []);
    if (response != null && response.results != null) {
      if (mounted) {
        setState(() {
          geocodingResults = response.results ?? [];
          if (geocodingResults.isNotEmpty &&
              geocodingResults.first.geometry?.location != null) {
            _map = _mapWidget(geocodingResults.first.geometry!.location!);
          }
        });
      }
    } else {
      if (mounted) {
        setState(() {
          geocodingResults = [];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    googleGeocoding = decode.GoogleGeocoding(widget.googleKey);
    geocodingSearch(widget.address);
    logger.info('initState:');
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldBuilder(
      context,
      title: Text(widget.address),
      body: _map,
    );
  }

  @override
  String get loggerName => 'AddressWebMapPage';
}
