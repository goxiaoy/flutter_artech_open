import 'package:artech_core/core.dart';
import 'package:artech_ui_kit/generated/l10n.dart';
import 'package:artech_ui_kit/ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;

const double _defaultSearchSize = 40.0;
const _defaultBorderColor = Colors.grey;
const _searchSortFontSize = 12.0;
const _searchSortIconSize = 18.0;

mixin MixinListPageState<T extends StatefulWidget, U> on State<T> {
  bool get searchable => getFields().length > 0;

  bool get sortable => getSortTextList().length > 0;

  SearchItem? _searchItem;
  String? _sort;
  late bool _down;

  late PaginationValue<U> paginationValue;

  @protected
  List<SearchItem> getFields();

  // Can be
  @protected
  int get pageLimit => 10;

  get sortString {
    if (_sort != null) {
      final down = _down ? ':DESC' : ':ASC';
      return _sort! + down;
    } else
      return null;
  }

  @protected
  List<SortText> getSortTextList();

  @protected
  AsyncSnapshot<List<U>?> asyncSnapshot(bool cacheFlag,
      {int? start,
      int? limit,
      String? sort,
      String? searchField,
      String? search,
      bool? networkOnly});

  @protected
  Widget listWidget(List<U> list);

  void _doSearch(SearchItem? item) {
    setState(() {
      _searchItem = item;
      paginationValue.forceRefresh();
    });
  }

  void _onCancelSort() {
    setState(() {
      // _currentData = [];
      _sort = null;
      paginationValue.forceRefresh();
    });
  }

  void _onCancelSearch() {
    _doSearch(null);
  }

  Widget _searchWidget() {
    return searchable
        ? InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => TextInputPage(
                            initialValue: _searchItem,
                            fields: getFields(),
                          )))
                  .then((value) {
                if (mounted) {
                  if (value != null) {
                    _doSearch(value);
                  }
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Tooltip(
                message: S.of(context).clickToSearch,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                    4.0) //         <--- border radius here
                                ),
                            border: Border.all(
                                color: _defaultBorderColor, width: 1.0),
                            shape: BoxShape.rectangle),
                        height: _defaultSearchSize,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              color: Theme.of(context).disabledColor,
                              size: _searchSortIconSize,
                            ),
                            Expanded(
                              child: Text(
                                _searchItem?.searchText ?? S.of(context).search,
                                style: TextStyle(fontSize: _searchSortFontSize),
                              ),
                            ),
                            _searchItem != null
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: GestureDetector(
                                        onTap: _onCancelSearch,
                                        child: Icon(
                                          Icons.clear,
                                          size: _searchSortIconSize,
                                        )),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _sortWidget() {
    return sortable
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ArtechPopupButton<String>(
                      initialValue: _sort,
                      padding: EdgeInsets.all(4.0),
                      tooltip: S.of(context).clickToSort,
                      child: Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                    4.0) //         <--- border radius here
                                ),
                            border: Border.all(color: Colors.grey, width: 1.0),
                            shape: BoxShape.rectangle),
                        height: _defaultSearchSize,
                        child: Center(
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    _sort != null
                                        ? getSortTextList()
                                            .firstWhere((element) =>
                                                element.sort == _sort)
                                            .label(context)
                                        : S.of(context).sortingBy,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: _searchSortFontSize),
                                  ),
                                ),
                              ),

                              if (_sort == null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.sort_outlined,
                                    color: Theme.of(context).primaryColor,
                                    size: _searchSortIconSize,
                                  ),
                                ),
                              // Up/Down
                              if (_sort != null)
                                ArtechIconButton(
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    tooltip: S.of(context).clickToChangeUpDown,
                                    icon: _down
                                        ? Icon(
                                            CupertinoIcons.sort_down,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: _searchSortIconSize,
                                          )
                                        : Icon(
                                            CupertinoIcons.sort_up,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: _searchSortIconSize,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        _down = !_down;
                                        if (_sort != null) {
                                          // _currentData = [];
                                          paginationValue.forceRefresh();
                                        }
                                      });
                                    }),

                              if (_sort != null)
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  child: GestureDetector(
                                      onTap: _onCancelSort,
                                      child: Icon(
                                        Icons.clear,
                                        size: 18.0,
                                      )),
                                ),
                            ],
                          ),
                        ),
                      ),
                      onSelected: (value) {
                        if (_sort != value)
                          setState(() {
                            _sort = value;
                            paginationValue.forceRefresh();
                          });
                      },
                      itemBuilder: (context) {
                        return [
                          ...getSortTextList().map<PopupMenuItem<String>>((e) {
                            return PopupMenuItem<String>(
                              padding: EdgeInsets.zero,
                              value: e.sort,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  e.label(context),
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black),
                                ),
                              ),
                            );
                          })
                        ];
                      }),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _paginationWrap({int? limit}) {
    // TODO:
    return PaginationWrap<U>(
        initLimit: limit ?? pageLimit,
        buildFunc: (p) {
          paginationValue = p;
          return asyncSnapshot(p.cacheFlag.value,
              start: p.start.value,
              limit: p.limit.value,
              sort: sortString,
              searchField: _searchItem?.field,
              search: _searchItem?.searchText);
        },
        listBuilder: (data, error, [stackTrace]) {
          if (error != null) {
            showErrorDialog(U.runtimeType.toString(), error,
                stackTrace: stackTrace);
            return Container();
          }

          if (data != null) {
            return SingleChildScrollView(child: listWidget(data));
          } else {
            return Center(
              child: Loading(),
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
    _down = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: ArtechHorizontalPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(flex: 7, fit: FlexFit.loose, child: _searchWidget()),
                  SizedBox(
                    width: 4.0,
                  ),
                  Flexible(flex: 3, fit: FlexFit.tight, child: _sortWidget()),
                ],
              ),
              Divider(),
              Expanded(
                child: ScreenTypeLayout.builder(
                  mobile: (_) => _paginationWrap(),
                  // TODO: fix bug for web, this is very bad just for now
                  watch: (_) => _paginationWrap(limit: 100),
                  desktop: (_) => _paginationWrap(limit: 100),
                  tablet: (_) => _paginationWrap(limit: 100),
                ),
                // child: PaginationWrap<U>(
                //     initLimit: pageLimit,
                //     buildFunc: (p) {
                //       paginationValue = p;
                //       return asyncSnapshot(p.cacheFlag.value,
                //           start: p.start.value,
                //           limit: p.limit.value,
                //           sort: sortString,
                //           searchField: _searchItem?.field,
                //           search: _searchItem?.searchText);
                //     },
                //     listBuilder: (data, error, [stackTrace]) {
                //       if (error != null) {
                //         showErrorDialog(U.runtimeType.toString(), error,
                //             stackTrace: stackTrace);
                //         return Container();
                //       }
                //
                //       if (data != null) {
                //         return SingleChildScrollView(child: listWidget(data));
                //       } else {
                //         return Center(
                //           child: Loading(),
                //         );
                //       }
                //     }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
