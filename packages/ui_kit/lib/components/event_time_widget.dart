import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'address_map_page.dart'
if (dart.library.html) 'web/address_web_map_page.dart';

const double _kHorizontal = 16.0;
const double _kMinVerticalPadding = 1.0;

class AddressWidget extends StatelessWidget {
  final String address;

  const AddressWidget({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        dense: true,
        trailing: ForwardIcon(),
        onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AddressMapPage(
                      address: address,
                    )));
        },
        minVerticalPadding: _kMinVerticalPadding,
        contentPadding:
            EdgeInsets.symmetric(vertical: 0.0, horizontal: _kHorizontal),
        title: Text(address),
        leading: Icon(Icons.location_on_outlined));
  }
}

class LocationWidget extends StatelessWidget {
  final String? location;
  final VoidCallback? onClicked;
  const LocationWidget({required this.location, this.onClicked}) : super();

  @override
  Widget build(BuildContext context) {
    return location != null
        ? ListTile(
            dense: true,
            onTap: () {
              if (onClicked != null) onClicked!();
            },
            leading: Icon(CupertinoIcons.building_2_fill),
            trailing: ForwardIcon(),
            minVerticalPadding: _kMinVerticalPadding,
            contentPadding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: _kHorizontal),
            title: Text(location!),
          )
        : Container();
  }
}
