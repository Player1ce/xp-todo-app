import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/providers/game_providers.dart';

class GameCreationDialog extends ConsumerStatefulWidget {
  final String userId;
  const GameCreationDialog({required this.userId, super.key});

  @override
  ConsumerState<GameCreationDialog> createState() => _GameCreationDialogState();
}

class _GameCreationDialogState extends ConsumerState<GameCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _imageUrl = '';
  String _description = '';
  Difficulty _difficulty = Difficulty.normal;

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final gameAction = ref.watch(gameActionProvider);
    final gameActionNotifier = ref.read(gameActionProvider.notifier);

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
                    'Create New Game',
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
                  labelText: 'Image URL',
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
                onChanged: (value) => setState(() => _imageUrl = value),
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
                          setState(() => _isSubmitting = true);
                          final game = Game(
                            id: '', // will be set by Firestore
                            title: _title,
                            imageUrl: _imageUrl,
                            description: _description,
                            isActive: true,
                            totalQuests: 0,
                            completedQuests: 0,
                            difficulty: _difficulty,
                            availableXP: 0,
                            totalXP: 0,
                            completionPercentage: 0.0,
                            userId: widget.userId,
                            dateCreated: DateTime.now(),
                            dateUpdated: DateTime.now(),
                          );
                          await gameActionNotifier.createGame(
                            widget.userId,
                            game,
                          );
                          setState(() => _isSubmitting = false);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
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
