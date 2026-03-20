import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/data/models/quest.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/providers/quest_ui_providers.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/providers/quest_providers.dart';
import 'package:xp_todo_app/util/listen_for_provider_errors.dart';

class QuestCreationDialog extends ConsumerStatefulWidget {
  String? selectedGameId;
  QuestCreationDialog({super.key, this.selectedGameId});

  @override
  ConsumerState<QuestCreationDialog> createState() =>
      _QuestCreationDialogState();
}

class _QuestCreationDialogState extends ConsumerState<QuestCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _xpFocusNode = FocusNode();
  final FocusNode _levelFocusNode = FocusNode();
  String _title = '';
  String _description = '';
  Difficulty _difficulty = Difficulty.easy;
  String _xpReward = '100';
  String _level = '1';
  DateTime? _expireDate;
  String? _selectedGameId;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedGameId != null) {
      _selectedGameId = widget.selectedGameId;
    } else {
      _selectedGameId = ref.read(selectedQuestGameIdProvider);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _titleFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _xpFocusNode.dispose();
    _levelFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitForm(
    QuestActionNotifier questActionNotifier,
    String userId,
    String effectiveGameId,
  ) async {
    if (_isSubmitting || !_formKey.currentState!.validate()) {
      return;
    }

    final parsedXpReward = int.parse(_xpReward);
    final parsedLevel = int.parse(_level);

    setState(() => _isSubmitting = true);
    final quest = Quest(
      id: '', // will be set by Firestore
      title: _title,
      description: _description,
      difficulty: _difficulty,
      completed: false,
      xpReward: parsedXpReward,
      gameId: effectiveGameId,
      level: parsedLevel,
      expireDate: _expireDate,
      userId: userId,
      dateCreated: DateTime.now(),
      dateUpdated: DateTime.now(),
    );

    await questActionNotifier.createQuest(userId, effectiveGameId, quest);
    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final questActionNotifier = ref.read(questActionProvider.notifier);
    final String userId = ref.watch(
      requiredAuthStateProvider.select((authState) => authState.uid),
    )!;
    final activeGamesAsync = ref.watch(activeUserActiveGamesProvider);

    listenForProviderErrors(
      widgetRef: ref,
      context: context,
      provider: questActionProvider,
    );

    if (activeGamesAsync.isLoading) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Loading active games...', style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    if (activeGamesAsync.hasError) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Failed to load games. Please try again.',
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    }

    final activeGames = activeGamesAsync.asData?.value ?? const [];
    if (widget.selectedGameId != null &&
        !activeGames.any((game) => game.id == widget.selectedGameId)) {
      final directSelectedGame = ref.watch(
        activeUserGameProvider(widget.selectedGameId!),
      );
      directSelectedGame.whenData((game) {
        if (game != null) {
          activeGames.add(game);
        }
      });
    }

    if (activeGames.isEmpty) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No active games found. Activate a game first.',
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    }

    final selectedGameId = _selectedGameId ?? activeGames.first.id;
    final selectedGameStillExists = activeGames.any(
      (game) => game.id == selectedGameId,
    );
    final effectiveGameId = selectedGameStillExists
        ? selectedGameId
        : activeGames.first.id;

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
                  Text(
                    'Create New Quest',
                    style: theme.textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TextFormField(
                focusNode: _titleFocusNode,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                onChanged: (value) => setState(() => _title = value),
                onFieldSubmitted: (_) {
                  _descriptionFocusNode.requestFocus();
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                focusNode: _descriptionFocusNode,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 1,
                // validator: (value) =>
                // value == null || value.isEmpty ? 'Required' : null,
                onChanged: (value) => setState(() => _description = value),
                onFieldSubmitted: (_) {
                  _xpFocusNode.requestFocus();
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: effectiveGameId,
                decoration: const InputDecoration(labelText: 'Game'),
                items: activeGames
                    .map(
                      (game) => DropdownMenuItem(
                        value: game.id,
                        child: Text(game.title),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) => setState(() => _selectedGameId = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Difficulty>(
                initialValue: _difficulty,
                // TODO: make sure this styles correctly (and in both modeS)
                decoration: const InputDecoration(labelText: 'Difficulty'),
                items: Difficulty.values
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text(
                          d.name[0].toUpperCase() + d.name.substring(1),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (d) =>
                    setState(() => _difficulty = d ?? Difficulty.medium),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: _xpFocusNode,
                      initialValue: _xpReward,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'XP Reward'),
                      validator: (value) {
                        final parsed = int.tryParse(value ?? '');
                        if (parsed == null || parsed < 0) {
                          return 'Invalid XP';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => _xpReward = value),
                      onFieldSubmitted: (_) {
                        _levelFocusNode.requestFocus();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      focusNode: _levelFocusNode,
                      initialValue: _level,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Level'),
                      validator: (value) {
                        final parsed = int.tryParse(value ?? '');
                        if (parsed == null || parsed < 0) {
                          return 'Invalid level';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => _level = value),
                      onFieldSubmitted: (_) {
                        _submitForm(
                          questActionNotifier,
                          userId,
                          effectiveGameId,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _expireDate == null
                          ? 'No expiration date selected'
                          : 'Expires: ${MaterialLocalizations.of(context).formatMediumDate(_expireDate!)}',
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 1),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                        initialDate: _expireDate ?? DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _expireDate = picked);
                      }
                    },
                    child: const Text('Set date'),
                  ),
                  if (_expireDate != null)
                    TextButton(
                      onPressed: () => setState(() => _expireDate = null),
                      child: const Text('Clear'),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _submitForm(
                          questActionNotifier,
                          userId,
                          effectiveGameId,
                        ),
                  child: _isSubmitting
                      ? CircularProgressIndicator(color: colorScheme.onPrimary)
                      : const Text('Create Quest'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
