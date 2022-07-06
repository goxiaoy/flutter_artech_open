import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

const double _space = 13.0;

/// AddressEdit
/// * [isRequired] required
class AddressEdit extends HealthFormFieldWidget {
  final AddressData? initialValue;
  final ValueChanged<AddressData> onChanged;
  final String name;
  const AddressEdit({
    Key? key,
    bool isHealthForm = false,
    bool isRequired = true,
    bool enabled = true,
    TextStyle? textStyle,
    this.initialValue,
    required this.name,
    required this.onChanged,
  }) : super(
            key: key,
            isRequired: isRequired,
            enabled: enabled,
            isHealthForm: isHealthForm,
            textStyle: textStyle);
  @override
  State<StatefulWidget> createState() {
    return AddressEditState();
  }
}

class AddressEditState extends State<AddressEdit> with MixinStateRequired {
  late AddressData addressData;

  String? _error;
  void _changed() {
    widget.onChanged(addressData);
  }

  void error(bool error) {
    setState(() {
      _error = error ? 'Address error' : null;
    });
  }

  @override
  void initState() {
    super.initState();
    addressData = widget.initialValue ?? AddressData();
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        // Address1
        Padding(
          padding: widget.isHealthForm
              ? EdgeInsets.zero
              : const EdgeInsets.only(top: _space),
          child: TextFormFieldWrapper(
            key: ValueKey('address1'),
            enabled: widget.enabled,
            isRequired: widget.isRequired,
            labelText: S.of(context).address1,
            hintText: S.of(context).address1,
            isHealthForm: widget.isHealthForm,
            textStyle: widget.textStyle,
            onChanged: (value) {
              setState(() {
                addressData.address1 = value;
                _changed();
              });
            },
            validator: (value) {
              if ((value == null || value.isEmpty) && !isRequired) return null;
              if (value == null || value.isEmpty || value.length < 5)
                return '${S.of(context).address1} ${S.of(context).error}';
              return null;
            },
            name: '${widget.name}_address1',
          ),
        ),

        //Address2
        Padding(
          padding: widget.isHealthForm
              ? EdgeInsets.zero
              : const EdgeInsets.only(top: _space),
          child: TextFormFieldWrapper(
            enabled: widget.enabled,
            labelText: S.of(context).address2,
            hintText: S.of(context).address2,
            isHealthForm: widget.isHealthForm,
            textStyle: widget.textStyle,
            onChanged: (value) {
              setState(() {
                addressData.address2 = value;
                _changed();
              });
            },
            validator: (value) {
              return null;
            },
            name: '${widget.name}_address2',
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: _space),
          child: Container(
            constraints:
                widget.isHealthForm ? BoxConstraints(maxHeight: 100.0) : null,
            child: CSCPicker(
              key: ValueKey<String>('${widget.name}_CSCPicker'),
              currentCountry: addressData.country,
              currentState: addressData.state,
              currentCity: addressData.city,
              defaultCountry:
                  widget.initialValue == null ? CscCountry.United_States : null,

              ///Enable disable state dropdown [OPTIONAL PARAMETER]
              showStates: widget.enabled,

              /// Enable disable city drop down [OPTIONAL PARAMETER]
              showCities: widget.enabled,

              ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
              flagState: CountryFlag.DISABLE,

              ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
              dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26, width: 1)),

              ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
              disabledDropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.black26,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),

              ///placeholders for dropdown search field
              countrySearchPlaceholder: S.of(context).country,
              stateSearchPlaceholder: S.of(context).state,
              citySearchPlaceholder: S.of(context).city,

              ///labels for dropdown
              countryDropdownLabel: "* ${S.of(context).country}",
              stateDropdownLabel: "* ${S.of(context).state}",
              cityDropdownLabel: "* ${S.of(context).city}",

              ///Disable country dropdown (Note: use it with default country)
              disableCountry: !widget.enabled,

              ///selected item style [OPTIONAL PARAMETER]
              selectedItemStyle: widget.textStyle ??
                  TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),

              ///DropdownDialog Heading style [OPTIONAL PARAMETER]
              dropdownHeadingStyle: widget.textStyle ??
                  TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),

              ///DropdownDialog Item style [OPTIONAL PARAMETER]
              dropdownItemStyle: widget.textStyle ??
                  TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),

              ///Dialog box radius [OPTIONAL PARAMETER]
              dropdownDialogRadius: 4.0,

              ///Search bar radius [OPTIONAL PARAMETER]
              searchBarRadius: 4.0,

              ///triggers once country selected in dropdown
              onCountryChanged: (value) {
                setState(() {
                  ///store value in country variable
                  addressData.country = value;
                  _changed();
                });
              },

              ///triggers once state selected in dropdown
              onStateChanged: (value) {
                setState(() {
                  ///store value in state variable
                  addressData.state = value;
                  _changed();
                });
              },

              ///triggers once city selected in dropdown
              onCityChanged: (value) {
                setState(() {
                  ///store value in city variable
                  addressData.city = value;
                  _changed();
                });
              },
            ),
          ),
        ),

        Padding(
          padding: widget.isHealthForm
              ? EdgeInsets.zero
              : const EdgeInsets.only(top: _space),
          child: TextFormFieldWrapper(
            key: ValueKey('postalCode'),
            enabled: widget.enabled,
            isRequired: widget.isRequired,
            labelText: S.of(context).postCode,
            hintText: S.of(context).postCode,
            isHealthForm: widget.isHealthForm,
            textStyle: widget.textStyle,
            onChanged: (value) {
              setState(() {
                addressData.postalCode = value;
                _changed();
              });
            },
            validator: (value) {
              if ((value == null || value.isEmpty) && !isRequired) return null;
              if (value == null || value.isEmpty || value.length < 5)
                return '${S.of(context).postCode} ${S.of(context).error}';
              return null;
            },
            name: '${widget.name}_postalCode',
          ),
        ),

        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  @override
  String get labelText => S.of(context).address;

  @override
  bool get isEmpty => false;

  @override
  Widget buildField(BuildContext context) {
    return _build(context);
  }

  @override
  Widget build(BuildContext context) {
    return buildField(context);
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  String get loggerName => 'AddressEdit';
}

extension FormBuilderStateExtension on FormBuilderState {
  bool addressValidate(AddressEditState addressEdit) {
    bool check = this.validate();
    if (addressEdit.widget.isRequired) {
      if (addressEdit.addressData.country == null ||
          addressEdit.addressData.city == null) {
        addressEdit.error(true);
        check = false;
      } else {
        addressEdit.error(false);
      }
    }
    return check;
  }
}
