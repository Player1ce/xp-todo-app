import 'package:flutter/cupertino.dart';

class PageData {
  final String iconString;
  final String label;
  final IconData iconData;
  final WidgetBuilder builder;

  const PageData(this.iconString, this.label, this.iconData, this.builder);
}

class PageLayout {
  final String id;
  final List<PageData> _pageList;
  final int initialPage;

  const PageLayout({
    required this.id,
    required List<PageData> pageList,
    required this.initialPage,
  }) : _pageList = pageList;

  List<PageData> get pageList => _pageList;
  int get length => _pageList.length;
  PageData operator [](int index) => _pageList[index];
}
