import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/data/models/quest.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/providers/user_profile_providers.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/providers/quest_providers.dart';
import 'package:xp_todo_app/util/listen_for_provider_errors.dart';

class QuestCreationDialog extends ConsumerStatefulWidget {
  const QuestCreationDialog({super.key});

  @override
  ConsumerState<QuestCreationDialog> createState() =>
      _QuestCreationDialogState();
}

class _QuestCreationDialogState extends ConsumerState<QuestCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  Difficulty _difficulty = Difficulty.normal;
  String _xpReward = '100';
  String _level = '1';
  DateTime? _expireDate;
  String? _selectedGameId;

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final questActionNotifier = ref.read(questActionProvider.notifier);
    final String userId = ref.watch(
      requiredAuthStateProvider.select((authState) => authState.uid),
    )!;
    final activeGamesAsync = ref.watch(activeGamesProvider(userId));

    listenForProviderErrors(
      widgetRef: ref,
      context: context,
      provider: questActionProvider,
    );

    if (activeGamesAsync.isLoading) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1a2035),
        child: const Padding(
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
              Text('Loading active games...'),
            ],
          ),
        ),
      );
    }

    if (activeGamesAsync.hasError) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1a2035),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Text('Failed to load games. Please try again.'),
        ),
      );
    }

    final activeGames = activeGamesAsync.asData?.value ?? const [];
    if (activeGames.isEmpty) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1a2035),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Text('No active games found. Activate a game first.'),
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
      backgroundColor: const Color(0xFF1a2035), // matches design reference
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
                  const Icon(Icons.add_box, color: Color(0xFF4d9fff)),
                  const SizedBox(width: 8),
                  Text(
                    'Create New Quest',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFe8eaf2),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    fontFamily: 'Rajdhani',
                    color: Color(0xFF8a9bc0),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF161b27),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Color(0xFF2a3550)),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                onChanged: (value) => setState(() => _title = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    fontFamily: 'Rajdhani',
                    color: Color(0xFF8a9bc0),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF161b27),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Color(0xFF2a3550)),
                  ),
                ),
                maxLines: 1,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                onChanged: (value) => setState(() => _description = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: effectiveGameId,
                decoration: InputDecoration(
                  labelText: 'Game',
                  labelStyle: TextStyle(
                    fontFamily: 'Rajdhani',
                    color: Color(0xFF8a9bc0),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF161b27),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Color(0xFF2a3550)),
                  ),
                ),
                items: activeGames
                    .map(
                      (game) => DropdownMenuItem(
                        value: game.id,
                        child: Text(
                          game.title,
                          style: const TextStyle(fontFamily: 'Rajdhani'),
                        ),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) => setState(() => _selectedGameId = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Difficulty>(
                initialValue: _difficulty,
                decoration: InputDecoration(
                  labelText: 'Difficulty',
                  labelStyle: TextStyle(
                    fontFamily: 'Rajdhani',
                    color: Color(0xFF8a9bc0),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF161b27),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Color(0xFF2a3550)),
                  ),
                ),
                items: Difficulty.values
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text(
                          d.name[0].toUpperCase() + d.name.substring(1),
                          style: const TextStyle(fontFamily: 'Rajdhani'),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (d) =>
                    setState(() => _difficulty = d ?? Difficulty.normal),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _xpReward,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'XP Reward',
                        labelStyle: TextStyle(
                          fontFamily: 'Rajdhani',
                          color: Color(0xFF8a9bc0),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF161b27),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Color(0xFF2a3550)),
                        ),
                      ),
                      validator: (value) {
                        final parsed = int.tryParse(value ?? '');
                        if (parsed == null || parsed < 0) {
                          return 'Invalid XP';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => _xpReward = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: _level,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Level',
                        labelStyle: TextStyle(
                          fontFamily: 'Rajdhani',
                          color: Color(0xFF8a9bc0),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF161b27),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Color(0xFF2a3550)),
                        ),
                      ),
                      validator: (value) {
                        final parsed = int.tryParse(value ?? '');
                        if (parsed == null || parsed < 0) {
                          return 'Invalid level';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => _level = value),
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
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        color: Color(0xFF8a9bc0),
                      ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4d9fff),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontFamily: 'Rajdhani',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      letterSpacing: 1.5,
                    ),
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          final parsedXpReward = int.parse(_xpReward);
                          final parsedLevel = int.parse(_level);
                          setState(() => _isSubmitting = true);
                          final quest = Quest(
                            id: '', // will be set by Firestore
                            title: _title,
                            description: _description,
                            isActive: true,
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
                          await questActionNotifier.createQuest(
                            userId,
                            effectiveGameId,
                            quest,
                          );
                          setState(() => _isSubmitting = false);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
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
