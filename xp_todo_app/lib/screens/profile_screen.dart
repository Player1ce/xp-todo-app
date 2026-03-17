import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/const/route_constants.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/providers/user_profile_providers.dart';
import 'package:xp_todo_app/widgets/profile_overview_panel.dart';
import 'package:xp_todo_app/widgets/sign_in_required_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    // final router = ref.watch(routerProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return SignInRequiredWidget(
            message: "Please sign in to view your profile.",
          );
        }
        return AdaptiveScaffold(
          appBar: AdaptiveAppBar(title: "Profile"), // TODO: center app bar text
          body: ProfileOverviewPanel(userId: user.uid),
        );
      },

      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Auth error: $error')),
    );
  }
}
