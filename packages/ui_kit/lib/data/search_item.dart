import 'package:flutter/material.dart';

class SearchItem {
  final String field;
  final String Function(BuildContext context) label;
  String? searchText;

  SearchItem({required this.field, required this.label, this.searchText});

  @override
  int get hashCode => field.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is SearchItem) {
      return other.field == field;
    }
    return false;
  }
}
