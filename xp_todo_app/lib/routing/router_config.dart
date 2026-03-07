// go_router
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/const/page_view_configurations.dart';

// Screens
import 'package:xp_todo_app/screens/settings_screen.dart';
import 'package:xp_todo_app/screens/page_view_home_screen.dart';

// Route constants
import 'package:xp_todo_app/const/route_constants.dart';

// GoRouter configuration
final mainRouter = GoRouter(
  routes: [
    GoRoute(
      path: RouteConstants.home,
      builder: (context, state) =>
          const PageViewHomeScreen(pageLayout: mainPageLayout),
    ),
    GoRoute(
      path: RouteConstants.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  // debugLogDiagnostics: true,
);
