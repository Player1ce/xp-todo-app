import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/widgets/game_card.dart';
import 'package:xp_todo_app/widgets/game_creation_dialog.dart';
import 'package:xp_todo_app/widgets/game_preview_dialog.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(requiredAuthStateProvider);

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(title: 'Library'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GamesGridView(
              onGameTap: (game) {
                showDialog<void>(
                  context: context,
                  builder: (context) {
                    // TODO: this is a bit wierd to have composed here. we might want to move this to be within the game_card file
                    return GamePreviewDialog(userId: authState.uid, game: game);
                  },
                );
              },
            ),
          ),
        ],
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
