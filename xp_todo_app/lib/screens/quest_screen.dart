import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/providers/user_profile_providers.dart';
import 'package:xp_todo_app/widgets/quest_creation_dialog.dart';
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
        } else {
          return AdaptiveScaffold(
            appBar: AdaptiveAppBar(title: "TODO"),
            body: TodoListPanel(),
            floatingActionButton: AdaptiveFloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => QuestCreationDialog(),
                );
              },
              tooltip: 'Create New Game',
              child: const Icon(Icons.add),
            ),
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        debugPrintStack(
          stackTrace: stackTrace,
          label: "Failed to load user in TodoScreen: ${error.toString()}",
        );
        return Center(child: Text('Failed to load user: $error'));
      },
    );
  }
}
