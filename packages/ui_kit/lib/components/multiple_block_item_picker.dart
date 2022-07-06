import 'package:flutter/material.dart';

import 'block_item_picker.dart';

typedef MultipleItemPickerItemBuilder<T> = Widget Function(BuildContext context,
    ItemBlockValue<T> item, bool isCurrentItem, Function changeItem);

class MultipleItemBlockPicker<T> extends StatefulWidget {
  MultipleItemBlockPicker(
      {this.pickerItem = const [],
      required this.onItemChanged,
      required this.items,
      ItemPickerLayoutBuilder<T>? layoutBuilder,
      ItemPickerItemBuilder<T>? itemBuilder,
      this.readOnly = false})
      : this.layoutBuilder = layoutBuilder ?? defaultLayoutBuilder,
        this.itemBuilder = itemBuilder ?? defaultItemBuilder;

  final List<T> pickerItem;
  final ValueChanged<List<T>> onItemChanged;
  final List<ItemBlockValue<T>> items;
  final ItemPickerLayoutBuilder<T> layoutBuilder;
  final ItemPickerItemBuilder<T> itemBuilder;
  final bool readOnly;

  @override
  State<StatefulWidget> createState() => _MultipleBlockPickerState<T>();
}

class _MultipleBlockPickerState<T> extends State<MultipleItemBlockPicker<T>> {
  late List<T> _currentItem;

  @override
  void initState() {
    _currentItem = widget.pickerItem;
    super.initState();
  }

  void changeItem(T item) {
    if (!widget.readOnly) {
      //newItems
      final newItems = List<T>.from(_currentItem);
      if (newItems.contains(item)) {
        newItems.remove(item);
      } else {
        newItems.add(item);
      }
      setState(() => _currentItem = newItems);
      widget.onItemChanged(_currentItem);
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
          _currentItem.contains(item.value),
          () => changeItem(item.value)),
    );
  }
}
