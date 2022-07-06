import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class TextInputPage extends StatefulWidget {
  final SearchItem? initialValue;
  final List<SearchItem> fields;

  const TextInputPage({Key? key, required this.fields, this.initialValue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextInputPageState();
  }
}

class _TextInputPageState extends State<TextInputPage> with HasNamedLogger {
  TextEditingController? _controller;

  SearchItem? selectedValue;

  bool get isValid => selectedValue != null && _controller!.text.length > 0;

  void _onSubmit(String value) {
    if (selectedValue != null) {
      selectedValue!.searchText=value;
      logger.info('Search $value on $selectedValue');
      Navigator.of(context).pop<SearchItem>(
          selectedValue);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue?.searchText??null);
    selectedValue = widget.initialValue ?? widget.fields.first;
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldBuilder(context,
      resizeToAvoidBottomInset: true,
      body: WidthConstrainContainer(
          child: SingleChildScrollView(
        child: InkWell(
          onTap: () {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: TextFormField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: (value) {
                        _controller!.text = value;
                        _controller!.selection = TextSelection(
                            baseOffset: _controller!.text.length,
                            extentOffset: _controller!.text.length);
                        setState(() {});
                      },
                      decoration: CustomInputDecoration(context,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _controller!.text = '';
                            },
                          ),
                          // TODO: translation
                          hintText: 'Please input search'),
                      onFieldSubmitted: _onSubmit,
                    )),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).cancel),
                      ),
                    ),
                    isValid
                        ? InkWell(
                            onTap: () {
                              _onSubmit(_controller!.text);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(S.of(context).ok),
                            ),
                          )
                        : Container()
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  //child: Text(S.of(context).search + ' ' + selectedValue.search),
                ),
                Container(
                  child: Wrap(
                    children: [
                      ...widget.fields
                          .map<Widget>((e) => InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedValue = e;
                                  });
                                },
                                child: Card(
                                  child: Row(
                                    children: [
                                      Radio<SearchItem>(
                                        value: e,
                                        groupValue: selectedValue,
                                        onChanged: (value) {
                                          if (value != selectedValue) {
                                            setState(() {
                                              selectedValue = value;
                                            });
                                          }
                                        },
                                      ),
                                      Text(e.label(context))
                                    ],
                                  ),
                                ),
                              ))
                          .toList()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  @override
  String get loggerName => '_TextInputPageState';
}
