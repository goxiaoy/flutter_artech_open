class SortField {
  SortField({this.name, this.desc});
  final String name;
  bool desc = false;
}

class PageOption {
  PageOption({this.start, this.limit});
  final int start;
  final int limit;
}
