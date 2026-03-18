import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/widgets/game_card.dart';
import 'package:xp_todo_app/widgets/game_creation_dialog.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(title: 'Library'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: GamesGridView())],
      ),
      floatingActionButton: AdaptiveFloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => GameCreationDialog(),
          );
        },
        tooltip: 'Create New Game',
        child: const Icon(Icons.add),
      ),
    );
  }
}
