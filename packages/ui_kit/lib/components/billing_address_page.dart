import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_core/core.dart';

abstract class BillingAddressBase extends StatefulHookWidget {
  final AddressData? addressData;
  const BillingAddressBase({Key? key, this.addressData}) : super(key: key);

  Future submit(String name, AddressData address);

  @override
  State<StatefulWidget> createState() {
    return _BillingAddressBaseState();
  }
}

class _BillingAddressBaseState extends State<BillingAddressBase> {
  late AddressData _addressData;
  String? _name;
  bool _clicked = false;
  bool _changed = false;
  final formKey =
      new GlobalKey<FormBuilderState>(debugLabel: 'BillingAddressPage');

  @override
  void initState() {
    super.initState();
    _addressData = widget.addressData ?? AddressData();
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldBuilder(context,title: Text(S.of(context).billingAddress),
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
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: NameFormField(
                        name: 'billing_address_name',
                        isRequired: true,
                        initialValue: _name,
                        onChanged: (String? value) {},
                      ),
                    ),
                    AddressEdit(
                      name:'billing_address',
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
                        formKey.currentState!.save();
                        widget.submit(_name!, _addressData).then((value) {
                          showToast(S.of(context).billingAddress);
                          Navigator.of(context).pop();
                        }).catchError((error) {
                          showErrorDialog(S.of(context).billingAddress, error);
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
