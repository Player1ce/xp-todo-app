import 'package:flutter/cupertino.dart';

class PageData {
  final String route;
  final String iconString;
  final String label;
  final IconData iconData;
  final WidgetBuilder builder;

  const PageData({
    required this.route,
    required this.iconString,
    required this.label,
    required this.iconData,
    required this.builder,
  });
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

  List<String> get routes => _pageList.map((page) => page.route).toList();

  List<PageData> get pageList => _pageList;
  int get length => _pageList.length;
  PageData operator [](int index) => _pageList[index];
}
