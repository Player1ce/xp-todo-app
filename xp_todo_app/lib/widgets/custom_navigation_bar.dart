import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/util/route_constants.dart';

final navBarList = {
  0: (RouteConstants.home, "house.fill"),
  1: (RouteConstants.settings, "gearshape.fill"),
  2: (RouteConstants.profile, "person.fill"),
};

AdaptiveBottomNavigationBar getCustomNavigationBar(BuildContext context) {
  return AdaptiveBottomNavigationBar(
    useNativeBottomBar: true,
    items: [
      for (int index = 0; index < navBarList.length; index++)
        AdaptiveNavigationDestination(
          icon: navBarList[index]!.$1, // icon string
          label: navBarList[index]!.$2.toString(), // route name as string
        ),
    ],
    selectedIndex: 0,
    onTap: (index) {
      GoRouter.of(context).go(
        index == 0
            ? RouteConstants.home
            : index == 1
            ? RouteConstants.settings
            : RouteConstants.profile,
      );
    },
  );
}
