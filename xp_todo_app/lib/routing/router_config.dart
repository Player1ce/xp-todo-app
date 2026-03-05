// go_router
import 'package:go_router/go_router.dart';

// Screens
import 'package:xp_todo_app/screens/my_demo_home_screen.dart';
import 'package:xp_todo_app/screens/settings_screen.dart';

// Route constants
import 'package:xp_todo_app/util/route_constants.dart';

// GoRouter configuration
final mainRouter = GoRouter(
  routes: [
    GoRoute(
      path: RouteConstants.home,
      builder: (context, state) =>
          const MyDemoHomePage(title: "Flutter Demo Home Page"),
    ),
    GoRoute(
      path: RouteConstants.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  // debugLogDiagnostics: true,
);
