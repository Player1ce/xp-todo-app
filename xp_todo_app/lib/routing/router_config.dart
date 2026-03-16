// go_router
import 'package:go_router/go_router.dart';

// Screens
import 'package:xp_todo_app/screens/auth_gate_screen.dart';
import 'package:xp_todo_app/screens/login_screen.dart';
import 'package:xp_todo_app/screens/settings_screen.dart';

// Route constants
import 'package:xp_todo_app/const/route_constants.dart';

// GoRouter configuration
final mainRouter = GoRouter(
  routes: [
    GoRoute(
      path: RouteConstants.home,
      builder: (context, state) => const AuthGateScreen(),
    ),
    GoRoute(
      path: RouteConstants.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteConstants.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  // debugLogDiagnostics: true,
);
