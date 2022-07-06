import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

typedef ItemPickerLayoutBuilder<T> = Widget Function(
    BuildContext context, List<ItemBlockValue<T>> items, ItemPicker<T> child);
typedef ItemPicker<T> = Widget Function(ItemBlockValue<T> item);
typedef ItemPickerItemBuilder<T> = Widget Function(BuildContext context,
    ItemBlockValue<T> item, bool isCurrentItem, Function changeItem);

class ItemBlockValue<T> {
  final T value;
  final Widget Function(BuildContext context) label;

  ItemBlockValue({required this.value, required this.label});
}

class ItemBlockPicker<T> extends StatefulWidget {
  ItemBlockPicker(
      {this.pickerItem,
      required this.onItemChanged,
      required this.items,
      ItemPickerLayoutBuilder<T>? layoutBuilder,
      ItemPickerItemBuilder<T>? itemBuilder,
      this.readOnly = false})
      : this.layoutBuilder = layoutBuilder ?? defaultLayoutBuilder,
        this.itemBuilder = itemBuilder ?? defaultItemBuilder;

  final T? pickerItem;
  final ValueChanged<T?> onItemChanged;
  final List<ItemBlockValue<T>> items;
  final ItemPickerLayoutBuilder<T> layoutBuilder;
  final ItemPickerItemBuilder<T> itemBuilder;
  final bool readOnly;

  @override
  State<StatefulWidget> createState() => _BlockPickerState<T>();
}

class _BlockPickerState<T> extends State<ItemBlockPicker<T>> {
  T? _currentItem;

  @override
  void initState() {
    _currentItem = widget.pickerItem;
    super.initState();
  }

  void changeItem(T item) {
    if (!widget.readOnly) {
      setState(() => _currentItem = item);
      widget.onItemChanged(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.layoutBuilder(
      context,
      widget.items,
      (ItemBlockValue<T> item, [bool? _, Function? __]) => widget.itemBuilder(
          context,
          item,
          _currentItem == item.value,
          () => changeItem(item.value)),
    );
  }
}

Widget defaultLayoutBuilder<T>(
    BuildContext context, List<ItemBlockValue<T>> items, ItemPicker<T> child) {

  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    final width = constraints.maxWidth;

    return Container(
// width: orientation == Orientation.portrait ? 50.0 : 50.0,
// height: orientation == Orientation.portrait ? 72.0 : 40.0,
        child: Center(
      child: GridView.count(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        crossAxisCount: width ~/ 80,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 5.0,
        children: items.map((t) => child(t)).toList(),
      ),
    ));
  });
}

Widget defaultItemBuilder<T>(BuildContext context, ItemBlockValue<T> item,
    bool isCurrentItem, Function changeItem) {
  const color = Colors.grey;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.8),
              offset: Offset(1.0, 2.0),
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: changeItem as void Function()?,
            borderRadius: BorderRadius.circular(50.0),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 210),
              opacity: isCurrentItem ? 1.0 : 0.0,
              child: Icon(
                Icons.done,
                color: useWhiteForeground(color) ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
      Flexible(
        child: Container(
            padding: EdgeInsets.only(top: 2), child: item.label(context)),
      ),
    ],
  );
}
