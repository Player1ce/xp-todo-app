import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xp_todo_app/const/page_view_configurations.dart';
import 'package:xp_todo_app/const/route_constants.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/screens/games_screen.dart';
import 'package:xp_todo_app/screens/main_todo_screen.dart';
import 'package:xp_todo_app/screens/page_view_home_screen.dart';
import 'package:xp_todo_app/screens/profile_screen.dart';
import 'package:xp_todo_app/screens/settings_screen.dart';

part 'go_router_provider.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  // Watch auth state so router can redirect on login/logout
  final authAsync = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteConstants.home,
    redirect: (context, state) {
      final isLoggedIn = authAsync.value != null;
      final isAuthRoute = state.matchedLocation == RouteConstants.login;

      if (!isLoggedIn && !isAuthRoute) return RouteConstants.login;
      if (isLoggedIn && isAuthRoute) return RouteConstants.home;
      return null; // no redirect needed
    },
    routes: [
      // Shell route wraps the PageView + persistent nav bar
      ShellRoute(
        builder: (context, state, child) {
          return PageViewHomeScreen(pageLayout: mainPageLayout);
        },
        routes: [
          GoRoute(
            path: RouteConstants.home,
            builder: (context, state) => const MainTodoScreen(),
          ),
          GoRoute(
            path: RouteConstants.gameLibrary,
            builder: (context, state) => const GamesScreen(),
          ),
          GoRoute(
            path: RouteConstants.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Sub-pages — pushed over the shell
      GoRoute(
        path: RouteConstants.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      // GoRoute(
      //   path: RouteConstants.gameView,
      //   builder: (context, state) {
      //     final gameId = state.pathParameters['gameId']!;
      //     return GameViewPage(gameId: gameId);
      //   },
      // ),
      // GoRoute(
      //   path: RouteConstants.editProfile,
      //   builder: (context, state) => const EditProfilePage(),
      // ),
    ],
  );
}
