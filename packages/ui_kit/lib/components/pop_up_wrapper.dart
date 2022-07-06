import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PopUpWrapper<T> extends HookWidget {
  final double? height;

  const PopUpWrapper(
      {Key? key, required this.childBuilder, this.onConfirm, this.height})
      : super(key: key);
  final Widget Function(ValueNotifier value) childBuilder;
  final ValueChanged<T?>? onConfirm;
  @override
  Widget build(BuildContext context) {
    final value = useState<T?>(null);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            border: Border(
              bottom: BorderSide(
                color: Color(0xff999999),
                width: 0.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CupertinoButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(value.value);
                },
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 5.0,
                ),
              ),
              CupertinoButton(
                child: Text('Confirm'),
                onPressed: () {
                  onConfirm?.call(value.value);
                  Navigator.of(context).pop(value.value);
                },
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 5.0,
                ),
              )
            ],
          ),
        ),
        Container(
            constraints:
                BoxConstraints(minHeight: 100, maxHeight: height ?? 200.0),
            color: Color(0xfff7f7f7),
            child: childBuilder(value))
      ],
    );
  }
}
