import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/providers/user_profile_providers.dart';
import 'package:xp_todo_app/widgets/todo_list_panel.dart';

class MainTodoScreen extends ConsumerWidget {
  const MainTodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeUserId = ref.watch(activeUserIdProvider);

    return activeUserId.when(
      data: (userId) {
        if (userId == null) {
          return const Center(
            child: Text('Please sign in to view your quests.'),
          );
        }
        return TodoListPanel(userId: userId);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load user: $error')),
    );
  }
}
