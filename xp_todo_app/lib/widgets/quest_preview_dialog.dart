import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/data/models/quest.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/providers/quest_providers.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';

class QuestPreviewDialog extends ConsumerStatefulWidget {
  final String userId;
  final String gameId;
  final Quest quest;

  const QuestPreviewDialog({
    super.key,
    required this.userId,
    required this.gameId,
    required this.quest,
  });

  @override
  ConsumerState<QuestPreviewDialog> createState() => _QuestPreviewDialogState();
}

class _QuestPreviewDialogState extends ConsumerState<QuestPreviewDialog> {
  static const Duration _textDebounce = Duration(milliseconds: 350);

  late String _title;
  late String _description;
  late String _xpReward;
  late Difficulty _difficulty;
  late DateTime? _dueDate;
  late bool _completed;

  bool _isSaving = false;
  String? _errorMessage;
  Timer? _debounceTimer;
  final Map<String, dynamic> _pendingTextUpdates = <String, dynamic>{};
  Future<void> _saveQueue = Future<void>.value();

  @override
  void initState() {
    super.initState();
    _title = widget.quest.title;
    _description = widget.quest.description;
    _xpReward = widget.quest.xpReward.toString();
    _difficulty = widget.quest.difficulty;
    _dueDate = widget.quest.expireDate;
    _completed = widget.quest.completed;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        final canClose = await _requestClose();
        if (canClose && mounted) {
          Navigator.of(this.context).pop();
        }
      },
      child: AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(20, 18, 12, 8),
        contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        title: Row(
          children: [
            const Icon(Icons.assignment_turned_in_outlined),
            const SizedBox(width: 8),
            const Expanded(child: Text('Quest Preview')),
            IconButton(
              tooltip: 'Close',
              onPressed: () async {
                final canClose = await _requestClose();
                if (canClose && mounted) {
                  Navigator.of(this.context).pop();
                }
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InlineEditableField(
                  label: 'Title',
                  value: _title,
                  onChanged: (value) {
                    setState(() => _title = value);
                    _scheduleTextSave({'name': value});
                  },
                ),
                const SizedBox(height: 10),
                _InlineEditableField(
                  label: 'Description',
                  value: _description,
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() => _description = value);
                    _scheduleTextSave({'description': value});
                  },
                ),
                const SizedBox(height: 10),
                _InlineEditableField(
                  label: 'XP Reward',
                  value: _xpReward,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() => _xpReward = value);
                    final parsed = int.tryParse(value);
                    if (parsed != null && parsed >= 0) {
                      _scheduleTextSave({'xpReward': parsed});
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Difficulty>(
                  initialValue: _difficulty,
                  decoration: const InputDecoration(labelText: 'Difficulty'),
                  items: Difficulty.values
                      .map(
                        (difficulty) => DropdownMenuItem<Difficulty>(
                          value: difficulty,
                          child: Text(difficulty.displayName),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _difficulty = value);
                    _queueSave({'difficulty': value.toStorage()});
                  },
                ),
                const SizedBox(height: 8),
                _DueDateEditor(
                  dueDate: _dueDate,
                  onDateChanged: (nextDate) {
                    setState(() => _dueDate = nextDate);
                    _queueSave({'expireDate': nextDate});
                  },
                ),
                const SizedBox(height: 8),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Completed'),
                  value: _completed,
                  onChanged: (next) {
                    setState(() => _completed = next);
                    _queueSave({'completed': next}, refreshCache: true);
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (_isSaving)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                    if (_isSaving) const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage ??
                            (_isSaving
                                ? 'Saving changes...'
                                : 'Changes are saved automatically.'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _errorMessage == null
                              ? colorScheme.onSurface.withValues(alpha: 0.72)
                              : colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _scheduleTextSave(Map<String, dynamic> updates) {
    _pendingTextUpdates.addAll(updates);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_textDebounce, _flushTextUpdates);
  }

  Future<void> _flushTextUpdates() async {
    if (_pendingTextUpdates.isEmpty) {
      return;
    }

    final updates = Map<String, dynamic>.from(_pendingTextUpdates);
    _pendingTextUpdates.clear();
    _queueSave(updates, refreshCache: updates.containsKey('xpReward'));
    await _saveQueue;
  }

  void _queueSave(Map<String, dynamic> updates, {bool refreshCache = false}) {
    _saveQueue = _saveQueue.then(
      (_) => _performSave(updates, refreshCache: refreshCache),
    );
  }

  Future<void> _performSave(
    Map<String, dynamic> updates, {
    bool refreshCache = false,
  }) async {
    if (updates.isEmpty) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(questActionProvider.notifier)
          .updateQuest(widget.userId, widget.gameId, widget.quest.id, updates);
      if (refreshCache) {
        await _refreshGameProgressCache();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to save one or more edits. Fix and retry.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _refreshGameProgressCache() async {
    final quests = await ref.read(
      gameQuestsProvider(widget.userId, widget.gameId).future,
    );
    final completedQuests = quests.where((quest) => quest.completed).length;
    final totalQuests = quests.length;
    final totalXp = quests.fold<int>(0, (sum, quest) => sum + quest.xpReward);
    final availableXp = quests
        .where((quest) => quest.completed)
        .fold<int>(0, (sum, quest) => sum + quest.xpReward);

    await ref
        .read(gameActionProvider.notifier)
        .setGameProgressCache(
          userId: widget.userId,
          gameId: widget.gameId,
          totalQuests: totalQuests,
          completedQuests: completedQuests,
          availableXP: availableXp,
          totalXP: totalXp,
        );
  }

  Future<bool> _requestClose() async {
    _debounceTimer?.cancel();
    await _flushTextUpdates();
    await _saveQueue;

    if (_errorMessage != null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_errorMessage!)));
      }
      return false;
    }

    return true;
  }
}

class _DueDateEditor extends StatelessWidget {
  final DateTime? dueDate;
  final ValueChanged<DateTime?> onDateChanged;

  const _DueDateEditor({required this.dueDate, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final dueLabel = dueDate == null
        ? 'No due date'
        : localizations.formatMediumDate(dueDate!);

    return Row(
      children: [
        Expanded(child: Text('Due date: $dueLabel')),
        TextButton(
          onPressed: () async {
            final pickedDate = await showDatePicker(
              context: context,
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
              initialDate: dueDate ?? DateTime.now(),
            );
            if (pickedDate != null) {
              onDateChanged(pickedDate);
            }
          },
          child: const Text('Set'),
        ),
        if (dueDate != null)
          TextButton(
            onPressed: () => onDateChanged(null),
            child: const Text('Clear'),
          ),
      ],
    );
  }
}

class _InlineEditableField extends StatefulWidget {
  final String label;
  final String value;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _InlineEditableField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  State<_InlineEditableField> createState() => _InlineEditableFieldState();
}

class _InlineEditableFieldState extends State<_InlineEditableField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _InlineEditableField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: const Icon(Icons.edit),
      ),
      onChanged: widget.onChanged,
    );
  }
}
