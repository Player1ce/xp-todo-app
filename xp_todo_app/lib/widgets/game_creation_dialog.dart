import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/util/listen_for_provider_errors.dart';

/// Requires an authenticated user to be present in the widget tree.
/// Must be used within an auth gate or after [authStateProvider] has
/// resolved to a non-null user. See [PageViewHomeScreen] for the
/// canonical auth gate in this app.
class GameCreationDialog extends ConsumerStatefulWidget {
  const GameCreationDialog({super.key});

  @override
  ConsumerState<GameCreationDialog> createState() => _GameCreationDialogState();
}

class _GameCreationDialogState extends ConsumerState<GameCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _imageUrl = '';
  String _description = '';
  Difficulty _difficulty = Difficulty.easy;

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(requiredAuthStateProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    listenForProviderErrors(
      widgetRef: ref,
      context: context,
      provider: gameActionProvider,
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.add_box, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('Create New Game', style: theme.textTheme.headlineSmall),
                ],
              ),
              const SizedBox(height: 18),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                onChanged: (value) => setState(() => _title = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Image URL'),
                onChanged: (value) => setState(() => _imageUrl = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 1,
                onChanged: (value) => setState(() => _description = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Difficulty>(
                initialValue: _difficulty,
                decoration: const InputDecoration(labelText: 'Difficulty'),
                items: Difficulty.values
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text(
                          d.name[0].toUpperCase() + d.name.substring(1),
                          // TODO: make sure this styles correctly (and in both modeS)
                          // style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (d) =>
                    setState(() => _difficulty = d ?? _difficulty),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // TODO: make sure this styles correctly (and in both modeS)
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: colorScheme.primary,
                  //   foregroundColor: colorScheme.onPrimary,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(6),
                  //   ),
                  //   padding: const EdgeInsets.symmetric(vertical: 14),
                  //   textStyle: const TextStyle(
                  //     fontFamily: 'Rajdhani',
                  //     fontWeight: FontWeight.w700,
                  //     fontSize: 15,
                  //     letterSpacing: 1.5,
                  //   ),
                  // ),
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _isSubmitting = true);
                          final game = Game(
                            id: '', // will be set by Firestore
                            title: _title,
                            imageUrl: _imageUrl,
                            description: _description,
                            isActive: true,
                            archived: false,
                            totalQuests: 0,
                            completedQuests: 0,
                            difficulty: _difficulty,
                            availableXP: 0,
                            totalXP: 0,
                            completionPercentage: 0.0,
                            userId: authState.uid,
                            dateCreated: DateTime.now(),
                            dateUpdated: DateTime.now(),
                          );
                          await ref
                              .read(gameActionProvider.notifier)
                              .createGame(authState.uid, game);
                          if (!context.mounted) return;
                          setState(() => _isSubmitting = false);
                          if (!ref.read(gameActionProvider).hasError) {
                            if (context.mounted) Navigator.of(context).pop();
                          } else {}
                        },
                  child: _isSubmitting
                      ? SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : const Text('Create Game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
