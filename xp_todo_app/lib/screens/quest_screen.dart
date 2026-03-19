import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/widgets/quest_creation_dialog.dart';
import 'package:xp_todo_app/widgets/todo_list_panel.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  // TODO: quest retrievela needs to be optimized in some way. Right now doing it by game workds, but it makes the todo page feel bad
  //  Lets update todo page to display a default main game at the top or a chosen main game then have the others collapsed for later expansion?
  //  either way we will need some kind of pagination at some point or it will become nasty.
  //  This is a firestore pagination solution at the end of the day
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
