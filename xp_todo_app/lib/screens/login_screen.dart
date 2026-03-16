import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/const/route_constants.dart';
import 'package:xp_todo_app/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E14), Color(0xFF101826)],
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
                    Text(
                      'QuestLog',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.4,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sign in to continue your progression',
                      style: TextStyle(
                        fontFamily: 'ShareTechMono',
                        fontSize: 11,
                        letterSpacing: 1.2,
                        color: AppColors.textSecondary(context),
                      ),
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
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontFamily: 'ExoTwo',
                        fontSize: 12,
                      ),
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
