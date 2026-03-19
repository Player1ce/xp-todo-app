import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:xp_todo_app/providers/go_router_provider.dart';

// consts
import 'package:xp_todo_app/util/page_layout.dart';

AdaptiveBottomNavigationBar getCustomPageViewNavigationBar(
  BuildContext context,
  WidgetRef ref,
  void Function(int) onTap,
  PageLayout pageLayout,
  int currentIndex,
) {
  return AdaptiveBottomNavigationBar(
    useNativeBottomBar: true,
    bottomNavigationBar: getCustomPageViewAndroidNavigationBar(
      context,
      ref,
      onTap,
      pageLayout,
      currentIndex,
    ),
    items: pageLayout.pageList
        .map(
          (pageData) => AdaptiveNavigationDestination(
            icon: pageData.iconString,
            label: pageData.label,
          ),
        )
        .toList(),

    onTap: onTap,
    selectedIndex: currentIndex,
    // ref.watch(
    //   goRouterProvider.select(
    //     (router) => pageLayout.pageList.indexWhere(
    //       (pageData) => pageData.route == router.state.matchedLocation,
    //     ),
    //   ),
    // ),
  );
}

BottomNavigationBar getCustomPageViewAndroidNavigationBar(
  BuildContext context,
  WidgetRef ref,
  void Function(int) onTap,
  PageLayout pageLayout,
  int currentIndex,
) {
  final theme = Theme.of(context);
  return BottomNavigationBar(
    backgroundColor:
        theme.bottomNavigationBarTheme.backgroundColor ??
        theme.bottomAppBarTheme.color ??
        theme.colorScheme.surface,
    items: pageLayout.pageList
        .map(
          (pageData) => BottomNavigationBarItem(
            icon: Icon(pageData.iconData),
            label: pageData.label,
          ),
        )
        .toList(),
    currentIndex: currentIndex,
    //  ref.watch(
    //   goRouterProvider.select(
    //     (router) => pageLayout.pageList.indexWhere(
    //       (pageData) => pageData.route == router.state.matchedLocation,
    //     ),
    //   ),
    // ),
    onTap: onTap,
  );
}
