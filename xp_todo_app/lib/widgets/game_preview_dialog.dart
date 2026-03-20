import 'dart:async';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/widgets/quest_creation_dialog.dart';

class GamePreviewDialog extends ConsumerStatefulWidget {
  final String userId;
  final Game game;

  const GamePreviewDialog({
    super.key,
    required this.userId,
    required this.game,
  });

  @override
  ConsumerState<GamePreviewDialog> createState() => _GamePreviewDialogState();
}

class _GamePreviewDialogState extends ConsumerState<GamePreviewDialog> {
  static const Duration _textDebounce = Duration(milliseconds: 350);

  late String _title;
  late String _description;
  late String _imageUrl;
  late Difficulty _difficulty;
  late bool _isActive;

  bool _isSaving = false;
  String? _errorMessage;
  Timer? _debounceTimer;
  final Map<String, dynamic> _pendingTextUpdates = <String, dynamic>{};
  Future<void> _saveQueue = Future<void>.value();

  @override
  void initState() {
    super.initState();
    _title = widget.game.title;
    _description = widget.game.description;
    _imageUrl = widget.game.imageUrl;
    _difficulty = widget.game.difficulty;
    _isActive = widget.game.isActive;
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
            const Icon(Icons.preview),
            const SizedBox(width: 8),
            const Expanded(child: Text('Game Preview')),
            IconButton(
              tooltip: 'Archive game',
              onPressed: _isSaving ? null : _archiveGame,
              icon: const Icon(Icons.inventory_2_outlined),
            ),
            IconButton(
              tooltip: 'Delete game',
              onPressed: _isSaving ? null : _deleteGame,
              icon: const Icon(Icons.delete_outline),
            ),
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
        content: 
        SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GameImagePreview(
                  imageUrl: _imageUrl,
                  onImageUrlChanged: (value) {
                    setState(() => _imageUrl = value);
                    _scheduleTextSave({'imageUrl': value});
                  },
                ),
                const SizedBox(height: 14),
                _InlineEditableField(
                  label: 'Title',
                  value: _title,
                  onChanged: (value) {
                    setState(() => _title = value);
                    _scheduleTextSave({'title': value});
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
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Active in quest list'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() => _isActive = value);
                    _queueSave({'isActive': value});
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
    _queueSave(updates);
    await _saveQueue;
  }

  void _queueSave(Map<String, dynamic> updates) {
    _saveQueue = _saveQueue.then((_) => _performSave(updates));
  }

  Future<void> _performSave(Map<String, dynamic> updates) async {
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
          .read(gameActionProvider.notifier)
          .updateGame(widget.userId, widget.game.id, updates);
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

  Future<void> _archiveGame() async {
    final shouldArchive = await _confirmAction(
      title: 'Archive game?',
      message:
          'This will mark the game as archived and inactive. Archived games are hidden from game lists and selectors.',
      confirmLabel: 'Archive',
      isDestructive: false,
    );
    if (!shouldArchive) {
      return;
    }

    final canProceed = await _requestClose();
    if (!canProceed || !mounted) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(gameActionProvider.notifier)
          .archiveGame(userId: widget.userId, gameId: widget.game.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Game archived.')),
        );
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Failed to archive this game. Please verify your connection and retry.';
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

  Future<void> _deleteGame() async {
    final shouldDelete = await _confirmAction(
      title: 'Delete game permanently?',
      message:
          'This permanently deletes the game and all quests in this game. This action cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (!shouldDelete) {
      return;
    }

    final canProceed = await _requestClose();
    if (!canProceed || !mounted) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref.read(gameActionProvider.notifier).deleteGame(
        widget.userId,
        widget.game.id,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Game deleted permanently.')),
        );
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Failed to delete this game. Please verify your connection and retry.';
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

  Future<bool> _confirmAction({
    required String title,
    required String message,
    required String confirmLabel,
    required bool isDestructive,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: isDestructive
                  ? FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                    )
                  : null,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }
}

class _GameImagePreview extends StatelessWidget {
  final String imageUrl;
  final ValueChanged<String> onImageUrlChanged;

  const _GameImagePreview({
    required this.imageUrl,
    required this.onImageUrlChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl.trim().isEmpty
                    ? ColoredBox(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.videogame_asset,
                          size: 42,
                          color: colorScheme.onSurface.withValues(alpha: 0.56),
                        ),
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => ColoredBox(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.broken_image,
                            size: 42,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.56,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: FilledButton.tonalIcon(
                onPressed: () async {
                  final controller = TextEditingController(text: imageUrl);
                  final nextUrl = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Edit cover image URL'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(
                              context,
                            ).pop(controller.text.trim()),
                            child: const Text('Apply'),
                          ),
                        ],
                      );
                    },
                  );
                  if (nextUrl != null) {
                    onImageUrlChanged(nextUrl);
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InlineEditableField extends StatefulWidget {
  final String label;
  final String value;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const _InlineEditableField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.maxLines = 1,
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
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: const Icon(Icons.edit),
      ),
      onChanged: widget.onChanged,
    );
  }
}
