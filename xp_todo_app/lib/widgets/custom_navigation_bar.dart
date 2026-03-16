import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/const/route_constants.dart';

const homeNavBarList = [
  (
    RouteConstants.settings,
    "gearshape.fill",
    "Settings",
    CupertinoIcons.settings,
  ),
  (RouteConstants.home, "house.fill", "Home", CupertinoIcons.house),
  (RouteConstants.profile, "person.fill", "Profile", CupertinoIcons.person),
];

AdaptiveBottomNavigationBar getCustomNavigationBar(
  BuildContext context, [
  List<(String, String, String, IconData)> navBarList = homeNavBarList,
]) {
  return AdaptiveBottomNavigationBar(
    useNativeBottomBar: true,
    bottomNavigationBar: getCustomAndroidNavigationBar(context, navBarList),
    items: [
      for (int index = 0; index < navBarList.length; index++)
        AdaptiveNavigationDestination(
          icon: navBarList[index].$2, // icon string
          label: navBarList[index].$3, // label string
        ),
    ],
    selectedIndex: 
    navBarList.indexWhere(
      (element) => element.$1 == GoRouter.of(context).state.fullPath,
    ),
    onTap: (index) {
      context.go(
        navBarList[index].$1, // route name as string
      );
    },
  );
}

BottomNavigationBar getCustomAndroidNavigationBar(
  BuildContext context, [
  List<(String, String, String, IconData)> navBarList = homeNavBarList,
]) {
  return BottomNavigationBar(
    backgroundColor:
        Theme.of(context).bottomAppBarTheme.color?.withAlpha(100) ??
        Colors.white.withAlpha(100),
    items: [
      for (int index = 0; index < navBarList.length; index++)
        BottomNavigationBarItem(
          icon: Icon(navBarList[index].$4), // icon data
          label: navBarList[index].$3,
        ),
    ],
    currentIndex: navBarList.indexWhere(
      (element) => element.$1 == GoRouter.of(context).state.fullPath,
    ),
    onTap: (index) {
      context.go(
        navBarList[index].$1, // route name as string
      );
    },
  );
}
