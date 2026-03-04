// go_router
import 'package:go_router/go_router.dart';

// Screens
import 'package:xp_todo_app/screens/my_demo_home_screen.dart';

// GoRouter configuration
final mainRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          MyDemoHomePage(title: "Flutter Demo Home Page"),
    ),
  ],
);
