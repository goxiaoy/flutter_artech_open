import 'package:flutter/material.dart';

class SortText {
  final String sort;
  final String Function(BuildContext context) label;
  const SortText({required this.sort, required this.label});

}
