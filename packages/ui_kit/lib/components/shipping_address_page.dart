import 'package:flutter/material.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_core/core.dart';

abstract class ShippingAddressPageBase extends StatefulHookWidget {
  final AddressData? addressData;
  final String? name;
  final String? phoneNumber;
  const ShippingAddressPageBase(
      {Key? key, this.addressData, this.name, this.phoneNumber})
      : super(key: key);

  Future submit(AddressData addressData, String name, String phoneNumber);
  @override
  State<StatefulWidget> createState() {
    return _ShippingAddressPageBaseState();
  }
}

class _ShippingAddressPageBaseState extends State<ShippingAddressPageBase> {
  late AddressData _addressData;
  String? _name;
  String? _phone;
  bool _clicked = false;
  final formKey =
      new GlobalKey<FormBuilderState>(debugLabel: 'ShippingAddressPage');

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _phone = widget.phoneNumber;
    _addressData = widget.addressData ?? AddressData();
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldBuilder(
      context,
      title: Text(S.of(context).shippingAddress),
      body: WidthConstrainContainer(
        child: FormBuilder(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11.0),
                      child: NameFormField(
                        name: 'shipping_address_name',
                        isRequired: true,
                        onChanged: (String? value) {
                          setState(() {
                            _name = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11.0),
                      child: PhoneFormField(
                        name: 'shipping_address_phone',
                        isRequired: true,
                        onChanged: (String? value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                      ),
                    ),
                    AddressEdit(
                      name: 'shipping_address',
                      initialValue: _addressData,
                      onChanged: (value) {
                        setState(() {
                          _addressData = value;
                        });
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment(0.0, 0.9),
                  child: ArtechRaisedButton(
                    clicked: _clicked,
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        formKey.currentState?.save();
                        widget
                            .submit(_addressData, _name!, _phone!)
                            .then((value) {
                          showToast(S.of(context).shippingAddress);
                          Navigator.of(context).pop();
                        }).catchError((error) {
                          showErrorDialog(S.of(context).shippingAddress, error);
                          if (mounted) {
                            setState(() {
                              _clicked = false;
                            });
                          }
                        });
                      }
                    },
                    child: Text(S.of(context).submit),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
