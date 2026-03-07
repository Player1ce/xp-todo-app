import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:xp_todo_app/providers/page_view_providers.dart';

// consts
import 'package:xp_todo_app/util/page_layout.dart';

AdaptiveBottomNavigationBar getCustomPageViewNavigationBar(
  BuildContext context,
  WidgetRef ref,
  void Function(int) switchPageViewPage,
  PageLayout pageLayout,
) {
  return AdaptiveBottomNavigationBar(
    useNativeBottomBar: true,
    bottomNavigationBar: getCustomPageViewAndroidNavigationBar(
      context,
      ref,
      switchPageViewPage,
      pageLayout,
    ),
    items: pageLayout.pageList
        .map(
          (pageData) => AdaptiveNavigationDestination(
            icon: pageData.iconString,
            label: pageData.label,
          ),
        )
        .toList(),

    onTap: (index) {
      switchPageViewPage(index);
    },
    selectedIndex: ref.watch(
      pageIndexProvider(pageLayout.id, pageLayout.initialPage),
    ),
  );
}

BottomNavigationBar getCustomPageViewAndroidNavigationBar(
  BuildContext context,
  WidgetRef ref,
  void Function(int) switchPageViewPage,
  PageLayout pageLayout,
) {
  return BottomNavigationBar(
    backgroundColor:
        Theme.of(context).bottomAppBarTheme.color?.withAlpha(100) ??
        Colors.white.withAlpha(100),
    items: pageLayout.pageList
        .map(
          (pageData) => BottomNavigationBarItem(
            icon: Icon(pageData.iconData),
            label: pageData.label,
          ),
        )
        .toList(),
    currentIndex: ref.watch(
      pageIndexProvider(pageLayout.id, pageLayout.initialPage),
    ),
    onTap: (index) {
      switchPageViewPage(index);
    },
  );
}
