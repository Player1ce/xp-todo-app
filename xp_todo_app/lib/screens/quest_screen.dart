import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/widgets/quest_creation_dialog.dart';
import 'package:xp_todo_app/widgets/todo_list_panel.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
}
