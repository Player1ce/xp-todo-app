import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/const/route_constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.scaffoldBackgroundColor, colorScheme.surface],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('QuestLog', style: theme.textTheme.displayLarge),
                    const SizedBox(height: 4),
                    Text(
                      'Sign in to continue your progression',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SignInScreen(
                  providers: [EmailAuthProvider()],
                  showPasswordVisibilityToggle: true,
                  headerBuilder: (context, constraints, _) {
                    return const SizedBox.shrink();
                  },
                  subtitleBuilder: (context, action) {
                    return Text(
                      action == AuthAction.signIn
                          ? 'Use email + password to enter your quest log.'
                          : 'Create your account to start tracking quests.',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextButton(
                  onPressed: () => context.go(RouteConstants.home),
                  child: const Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
