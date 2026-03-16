import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/const/route_constants.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/providers/user_profile_providers.dart';
import 'package:xp_todo_app/widgets/profile_overview_panel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final activeUserId = ref.watch(activeUserIdProvider);
    // final router = ref.watch(routerProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // router.push(RouteConstants.login);
          return Center(
            child: FilledButton(
              onPressed: () => context.go(RouteConstants.login),
              child: const Text('Sign in'),
            ),
          );
        }

        return activeUserId.when(
          data: (userId) {
            if (userId == null) {
              return const Center(child: Text('No profile found.'));
            }
            return ProfileOverviewPanel(userId: userId);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Failed to load profile: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Auth error: $error')),
    );
  }
}
