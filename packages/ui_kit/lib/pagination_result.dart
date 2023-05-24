class PaginationResult<T> {
  int? totalSize;
  int? filteredSize;
  Iterable<T> items = [];
  String? nextAfterPageToken;
  String? nextBeforePageToken;

  PaginationResult(
      {this.totalSize,
      this.filteredSize,
      this.items = const [],
      this.nextAfterPageToken,
      this.nextBeforePageToken});
}
