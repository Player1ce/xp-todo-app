import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/const/page_view_configurations.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/screens/login_screen.dart';
import 'package:xp_todo_app/screens/page_view_home_screen.dart';

class AuthGateScreen extends ConsumerWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }
        return const PageViewHomeScreen(pageLayout: mainPageLayout);
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('Authentication error: $error'))),
    );
  }
}
