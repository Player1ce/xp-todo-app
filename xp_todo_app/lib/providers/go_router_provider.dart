import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:xp_todo_app/const/page_view_configurations.dart';
import 'package:xp_todo_app/const/route_constants.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/screens/admin_page.dart';
import 'package:xp_todo_app/screens/game_screen/game_detail_page.dart';
import 'package:xp_todo_app/screens/login_screen.dart';
import 'package:xp_todo_app/screens/page_view_home_screen.dart';
import 'package:xp_todo_app/screens/settings_screen.dart';

part 'go_router_provider.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  // Watch auth state so router can redirect on login/logout
  final authAsync = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteConstants.home,
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation == RouteConstants.login;
      final isSplashRoute = state.matchedLocation == RouteConstants.splash;

      return authAsync.when(
        data: (data) {
          if (data == null && !isAuthRoute) {
            return RouteConstants.login;
          }
          return isAuthRoute && data != null ? RouteConstants.home : null;
        },
        error: (error, stackTrace) {
          // Handle auth errors if needed, for now just print and allow access to login
          debugPrint('Auth error in router: $error | $stackTrace');
          return isAuthRoute ? null : RouteConstants.login;
        },
        loading: () {
          // While auth state is loading, we will show a splash screen. If we're already on the splash route, do nothing.
          return isSplashRoute ? null : RouteConstants.splash;
        },
      );
    },
    routes: [
      // a splash page for initial loading state
      GoRoute(
        path: RouteConstants.splash,
        builder: (_, _) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      // Shell route wraps the PageView + persistent nav bar
      ShellRoute(
        builder: (context, state, child) {
          return PageViewHomeScreen(pageLayout: mainPageLayout);
        },
        routes: [
          GoRoute(
            path: RouteConstants.home,
            builder: (context, state) => const Text("Home"),
          ),
          GoRoute(
            path: RouteConstants.gameLibrary,
            builder: (context, state) => const Text("Game Library"),
          ),
          GoRoute(
            path: RouteConstants.profile,
            builder: (context, state) => const Text("Profile"),
          ),
        ],
      ),

      // Sub-pages — pushed over the shell
      GoRoute(
        path: RouteConstants.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.adminPage,
        builder: (context, state) => const AdminPage(),
      ),
      GoRoute(
        path: RouteConstants.gameView,
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          // TODO: this might be a problem check that this is ok
          final userId = ref.watch(requiredActiveUserIdProvider);
          // TODO: shoudl we change this to use active userid instead?
          return GameDetailPage(userId: userId, gameId: gameId);
        },
      ),
      // GoRoute(
      //   path: RouteConstants.editProfile,
      //   builder: (context, state) => const EditProfilePage(),
      // ),
    ],
  );
}
