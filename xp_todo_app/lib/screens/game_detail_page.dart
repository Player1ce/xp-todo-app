import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/data/models/quest.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/providers/quest_providers.dart';
import 'package:xp_todo_app/providers/quest_ui_providers.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/widgets/quest_item_card.dart';
import 'package:xp_todo_app/widgets/quest_preview_dialog.dart';

class GameDetailPage extends ConsumerStatefulWidget {
  final String userId;
  final String gameId;

  const GameDetailPage({super.key, required this.userId, required this.gameId});

  @override
  ConsumerState<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends ConsumerState<GameDetailPage> {
  static const Duration _textDebounce = Duration(milliseconds: 350);

  late String _title;
  late String _description;
  late String _imageUrl;
  late Difficulty _difficulty;
  late bool _isActive;
  QuestSegment _segment = QuestSegment.all;

  String? _initializedGameId;
  bool _isSaving = false;
  String? _errorMessage;
  Timer? _debounceTimer;
  final Map<String, dynamic> _pendingTextUpdates = <String, dynamic>{};
  Future<void> _saveQueue = Future<void>.value();
  final Set<String> _busyQuestIds = <String>{};

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameAsync = ref.watch(gameProvider(widget.userId, widget.gameId));

    return gameAsync.when(
      data: (game) {
        if (game == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Game Details')),
            body: const Center(child: Text('Game was not found.')),
          );
        }

        _seedFromGame(game);

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
          child: Scaffold(
            appBar: AppBar(
              title: Text(game.title),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  final canClose = await _requestClose();
                  if (canClose && mounted) {
                    Navigator.of(this.context).pop();
                  }
                },
              ),
            ),
            body: _GameDetailContent(
              userId: widget.userId,
              game: game,
              title: _title,
              description: _description,
              imageUrl: _imageUrl,
              difficulty: _difficulty,
              isActive: _isActive,
              segment: _segment,
              isSaving: _isSaving,
              errorMessage: _errorMessage,
              isQuestBusy: (questId) => _busyQuestIds.contains(questId),
              onImageUrlChanged: (value) {
                setState(() => _imageUrl = value);
                _scheduleTextSave({'imageUrl': value});
              },
              onTitleChanged: (value) {
                setState(() => _title = value);
                _scheduleTextSave({'title': value});
              },
              onDescriptionChanged: (value) {
                setState(() => _description = value);
                _scheduleTextSave({'description': value});
              },
              onDifficultyChanged: (value) {
                setState(() => _difficulty = value);
                _queueSave({'difficulty': value.toStorage()});
              },
              onIsActiveChanged: (value) {
                setState(() => _isActive = value);
                _queueSave({'isActive': value});
              },
              onSegmentChanged: (segment) {
                setState(() => _segment = segment);
              },
              onQuestTap: (quest) {
                showDialog<void>(
                  context: context,
                  builder: (context) {
                    return QuestPreviewDialog(
                      userId: widget.userId,
                      gameId: game.id,
                      quest: quest,
                    );
                  },
                );
              },
              onQuestCompletionChanged:
                  (quest, allQuests, nextCompleted) async {
                    if (_busyQuestIds.contains(quest.id)) {
                      return;
                    }

                    setState(() => _busyQuestIds.add(quest.id));

                    try {
                      await _setQuestCompletedAndRefreshCache(
                        quest: quest,
                        allQuests: allQuests,
                        completed: nextCompleted,
                        gameId: game.id,
                      );
                    } catch (_) {
                      if (context.mounted) {
                        final theme = Theme.of(context);
                        final colorScheme = theme.colorScheme;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: colorScheme.errorContainer,
                            content: Text(
                              'Unable to update quest completion right now.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onErrorContainer,
                              ),
                            ),
                            action: SnackBarAction(
                              label: 'Dismiss',
                              textColor: colorScheme.onErrorContainer,
                              onPressed: () {},
                            ),
                          ),
                        );
                      }
                      return;
                    } finally {
                      if (mounted) {
                        setState(() => _busyQuestIds.remove(quest.id));
                      }
                    }

                    final previousCompleted = !nextCompleted;
                    final snackBar = SnackBar(
                      content: Text(
                        nextCompleted
                            ? 'Quest marked complete.'
                            : 'Quest marked incomplete.',
                      ),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () async {
                          await _setQuestCompletedAndRefreshCache(
                            quest: quest,
                            allQuests: allQuests,
                            completed: previousCompleted,
                            gameId: game.id,
                          );
                        },
                      ),
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  },
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Game Details')),
        body: Center(child: Text('Failed to load game: $error')),
      ),
    );
  }

  void _seedFromGame(Game game) {
    if (_initializedGameId == game.id) {
      return;
    }

    _initializedGameId = game.id;
    _title = game.title;
    _description = game.description;
    _imageUrl = game.imageUrl;
    _difficulty = game.difficulty;
    _isActive = game.isActive;
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
          .updateGame(widget.userId, widget.gameId, updates);
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

  Future<void> _setQuestCompletedAndRefreshCache({
    required Quest quest,
    required List<Quest> allQuests,
    required bool completed,
    required String gameId,
  }) async {
    await ref
        .read(questActionProvider.notifier)
        .setQuestCompleted(
          userId: widget.userId,
          gameId: gameId,
          questId: quest.id,
          completed: completed,
        );

    final updatedQuests = allQuests
        .map((currentQuest) {
          if (currentQuest.id != quest.id) {
            return currentQuest;
          }
          return currentQuest.copyWith(completed: completed);
        })
        .toList(growable: false);

    final completedQuests = updatedQuests
        .where((currentQuest) => currentQuest.completed)
        .length;
    final totalQuests = updatedQuests.length;
    final totalXp = updatedQuests.fold<int>(
      0,
      (sum, currentQuest) => sum + currentQuest.xpReward,
    );
    final availableXp = updatedQuests
        .where((currentQuest) => currentQuest.completed)
        .fold<int>(0, (sum, currentQuest) => sum + currentQuest.xpReward);

    await ref
        .read(gameActionProvider.notifier)
        .setGameProgressCache(
          userId: widget.userId,
          gameId: gameId,
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

class _GameDetailContent extends ConsumerWidget {
  final String userId;
  final Game game;
  final String title;
  final String description;
  final String imageUrl;
  final Difficulty difficulty;
  final bool isActive;
  final QuestSegment segment;
  final bool isSaving;
  final String? errorMessage;
  final bool Function(String questId) isQuestBusy;
  final ValueChanged<String> onImageUrlChanged;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<Difficulty> onDifficultyChanged;
  final ValueChanged<bool> onIsActiveChanged;
  final ValueChanged<QuestSegment> onSegmentChanged;
  final ValueChanged<Quest> onQuestTap;
  final Future<void> Function(Quest quest, List<Quest> allQuests, bool next)
  onQuestCompletionChanged;

  const _GameDetailContent({
    required this.userId,
    required this.game,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.difficulty,
    required this.isActive,
    required this.segment,
    required this.isSaving,
    required this.errorMessage,
    required this.isQuestBusy,
    required this.onImageUrlChanged,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onDifficultyChanged,
    required this.onIsActiveChanged,
    required this.onSegmentChanged,
    required this.onQuestTap,
    required this.onQuestCompletionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final questsAsync = ref.watch(
      activeUserIncompleteGameQuestsProvider(game.id),
    );

    return questsAsync.when(
      data: (quests) {
        final allQuests = quests ?? <Quest>[];
        final filtered = _filterQuests(allQuests, segment);

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _GameImagePreview(
                      imageUrl: imageUrl,
                      onImageUrlChanged: onImageUrlChanged,
                    ),
                    const SizedBox(height: 14),
                    _InlineEditableField(
                      label: 'Title',
                      value: title,
                      onChanged: onTitleChanged,
                    ),
                    const SizedBox(height: 10),
                    _InlineEditableField(
                      label: 'Description',
                      value: description,
                      maxLines: 3,
                      onChanged: onDescriptionChanged,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Difficulty>(
                      initialValue: difficulty,
                      decoration: const InputDecoration(
                        labelText: 'Difficulty',
                      ),
                      items: Difficulty.values
                          .map(
                            (value) => DropdownMenuItem<Difficulty>(
                              value: value,
                              child: Text(value.displayName),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        onDifficultyChanged(value);
                      },
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Active in quest list'),
                      value: isActive,
                      onChanged: onIsActiveChanged,
                    ),
                    Row(
                      children: [
                        if (isSaving)
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          ),
                        if (isSaving) const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage ??
                                (isSaving
                                    ? 'Saving changes...'
                                    : 'Changes are saved automatically.'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: errorMessage == null
                                  ? colorScheme.onSurface.withValues(
                                      alpha: 0.72,
                                    )
                                  : colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Quests',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Only incomplete quests are shown, using the same segment filters as Quest Log.',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CupertinoSlidingSegmentedControl<QuestSegment>(
                      groupValue: segment,
                      children: const {
                        QuestSegment.all: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('All'),
                        ),
                        QuestSegment.overdue: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Overdue'),
                        ),
                        QuestSegment.upcoming: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Soon'),
                        ),
                        QuestSegment.undated: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('No Date'),
                        ),
                      },
                      onValueChanged: (next) {
                        if (next != null) {
                          onSegmentChanged(next);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'No quests in this segment.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverList.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final quest = filtered[index];
                    return QuestItemCard(
                      quest: quest,
                      isBusy: isQuestBusy(quest.id),
                      onTap: () => onQuestTap(quest),
                      onCompletedChanged: (nextCompleted) {
                        onQuestCompletionChanged(
                          quest,
                          allQuests,
                          nextCompleted,
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load quests: $error')),
    );
  }

  List<Quest> _filterQuests(List<Quest> quests, QuestSegment nextSegment) {
    final now = DateTime.now();
    final endOfSoon = now.add(const Duration(days: 3));

    bool include(Quest quest) {
      final due = quest.expireDate;
      switch (nextSegment) {
        case QuestSegment.all:
          return true;
        case QuestSegment.overdue:
          return due != null && due.isBefore(now);
        case QuestSegment.upcoming:
          return due != null && due.isAfter(now) && due.isBefore(endOfSoon);
        case QuestSegment.undated:
          return due == null;
      }
    }

    final filtered = quests.where(include).toList(growable: false);
    filtered.sort((a, b) {
      final aDue = a.expireDate;
      final bDue = b.expireDate;
      if (aDue == null && bDue == null) {
        return 0;
      }
      if (aDue == null) {
        return 1;
      }
      if (bDue == null) {
        return -1;
      }
      return aDue.compareTo(bDue);
    });

    return filtered;
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
