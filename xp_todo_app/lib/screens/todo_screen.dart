import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/const/route_constants.dart';
import 'package:xp_todo_app/providers/user_profile_providers.dart';
import 'package:xp_todo_app/widgets/sign_in_required_widget.dart';
import 'package:xp_todo_app/widgets/todo_list_panel.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeUserId = ref.watch(activeUserIdProvider);

    return activeUserId.when(
      data: (userId) {
        if (userId == null) {
          return SignInRequiredWidget(
            message: "Please sign in to view your quests.",
          );
        }
        return TodoListPanel();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load user: $error')),
    );
  }
}
