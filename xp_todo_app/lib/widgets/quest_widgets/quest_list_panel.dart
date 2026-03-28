import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/data/models/quest.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/providers/quest_providers.dart';
import 'package:xp_todo_app/providers/quest_ui_providers.dart';
import 'package:xp_todo_app/widgets/quest_widgets/quest_preview_dialog.dart';
import 'package:xp_todo_app/widgets/quest_widgets/quest_item_card.dart';

class QuestListPanel extends ConsumerStatefulWidget {
  const QuestListPanel({super.key});

  @override
  ConsumerState<QuestListPanel> createState() => _QuestListPanelState();
}

class _QuestListPanelState extends ConsumerState<QuestListPanel> {
  void _setSelectedGameId(String nextGameId) {
    final selectedGameId = ref.read(selectedQuestGameIdProvider);
    if (selectedGameId == nextGameId) {
      return;
    }
    ref.read(selectedQuestGameIdProvider.notifier).updateValue(nextGameId);
  }

  @override
  Widget build(BuildContext context) {
    // userID is not null here we handle that in the above widget (maybe move that here)
    final userId = ref.watch(requiredAuthStateProvider).uid;
    final gamesAsync = ref.watch(activeUserActiveGamesProvider);
    final selectedGameId = ref.watch(selectedQuestGameIdProvider);

    return gamesAsync.when(
      data: (games) {
        if (games == null || games.isEmpty) {
          return _EmptyQuestState(userId: userId);
        }

        final effectiveSelectedGameId =
            selectedGameId != null && games.any((g) => g.id == selectedGameId)
            ? selectedGameId
            : games.first.id;

        if (selectedGameId != effectiveSelectedGameId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(selectedQuestGameIdProvider.notifier)
                  .updateValue(effectiveSelectedGameId);
            }
          });
        }

        final selectedGame = games.firstWhere(
          (g) => g.id == effectiveSelectedGameId,
        );
        return _QuestListContent(
          userId: userId,
          games: games,
          selectedGame: selectedGame,
          // TODO: remove this dependency chain and just ref the provider directly where needed
          onGameChanged: _setSelectedGameId,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load games: $error')),
    );
  }
}

class _QuestListContent extends ConsumerStatefulWidget {
  final String userId;
  final List<Game> games;
  final Game selectedGame;
  final ValueChanged<String> onGameChanged;

  // TODO: remove pass in of userID here
  const _QuestListContent({
    required this.userId,
    required this.games,
    required this.selectedGame,
    required this.onGameChanged,
  });

  @override
  ConsumerState<_QuestListContent> createState() => _QuestListContentState();
}

class _QuestListContentState extends ConsumerState<_QuestListContent> {
  final Set<String> _busyQuestIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final questsAsync = ref.watch(
      activeUserIncompleteGameQuestsProvider(widget.selectedGame.id),
    );
    // TODO: this state probably shouldn't be persisted
    final segment = ref.watch(questFilterProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Quests',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Track and complete your current objectives',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: 10),
              _GameSelector(
                games: widget.games,
                selectedGameId: widget.selectedGame.id,
                onChanged: widget.onGameChanged,
              ),
              const SizedBox(height: 10),
              _QuestSegmentControl(current: segment),
            ],
          ),
        ),
        Expanded(
          child: questsAsync.when(
            data: (quests) {
              quests ??= []; // Could be null so set to empty list in that case
              final filtered = _filterQuests(quests, segment);
              return _QuestListView(
                quests: filtered,
                isQuestBusy: (questId) => _busyQuestIds.contains(questId),
                onQuestTap: (quest) {
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return QuestPreviewDialog(
                        userId: widget.userId,
                        gameId: widget.selectedGame.id,
                        quest: quest,
                      );
                    },
                  );
                },
                onQuestCompletionChanged: (quest, nextCompleted) async {
                  if (_busyQuestIds.contains(quest.id)) {
                    return;
                  }

                  setState(() => _busyQuestIds.add(quest.id));

                  try {
                    await _setQuestCompletedAndRefreshCache(
                      quest: quest,
                      allQuests: quests!,
                      completed: nextCompleted,
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
                          allQuests: quests!,
                          completed: previousCompleted,
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
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('Failed to load quests: $error')),
          ),
        ),
      ],
    );
  }

  Future<void> _setQuestCompletedAndRefreshCache({
    required Quest quest,
    required List<Quest> allQuests,
    required bool completed,
  }) async {
    await ref
        .read(questActionProvider.notifier)
        .setQuestCompleted(
          userId: widget.userId,
          gameId: widget.selectedGame.id,
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
          gameId: widget.selectedGame.id,
          totalQuests: totalQuests,
          completedQuests: completedQuests,
          availableXP: availableXp,
          totalXP: totalXp,
        );
  }

  List<Quest> _filterQuests(List<Quest> quests, QuestSegment segment) {
    final now = DateTime.now();
    final endOfSoon = now.add(const Duration(days: 3));

    bool include(Quest quest) {
      final due = quest.expireDate;
      switch (segment) {
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
      if (aDue == null && bDue == null) return 0;
      if (aDue == null) return 1;
      if (bDue == null) return -1;
      return aDue.compareTo(bDue);
    });

    return filtered;
  }
}

class _QuestListView extends StatelessWidget {
  final List<Quest> quests;
  final ValueChanged<Quest> onQuestTap;
  final bool Function(String questId) isQuestBusy;
  final Future<void> Function(Quest quest, bool nextCompleted)
  onQuestCompletionChanged;

  const _QuestListView({
    required this.quests,
    required this.onQuestTap,
    required this.isQuestBusy,
    required this.onQuestCompletionChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) {
      final color = Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: 0.72);
      final textTheme = Theme.of(context).textTheme;
      return Center(
        child: Text(
          'No quests in this segment.',
          style: textTheme.bodyMedium?.copyWith(color: color),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      itemCount: quests.length,
      itemBuilder: (context, index) {
        final quest = quests[index];
        return QuestItemCard(
          quest: quest,
          isBusy: isQuestBusy(quest.id),
          onTap: () => onQuestTap(quest),
          onCompletedChanged: (nextCompleted) {
            onQuestCompletionChanged(quest, nextCompleted);
          },
        );
      },
    );
  }
}

class _QuestSegmentControl extends ConsumerWidget {
  final QuestSegment current;

  const _QuestSegmentControl({required this.current});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoSlidingSegmentedControl<QuestSegment>(
      groupValue: current,
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
          ref.read(questFilterProvider.notifier).setSegment(next);
        }
      },
    );
  }
}

class _GameSelector extends StatelessWidget {
  final List<Game> games;
  final String selectedGameId;
  final ValueChanged<String> onChanged;

  const _GameSelector({
    required this.games,
    required this.selectedGameId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedGameId,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Current game'),
      items: games
          .map(
            (game) => DropdownMenuItem(value: game.id, child: Text(game.title)),
          )
          .toList(growable: false),
      onChanged: (next) {
        if (next != null) onChanged(next);
      },
    );
  }
}

class _EmptyQuestState extends StatelessWidget {
  final String userId;

  const _EmptyQuestState({required this.userId});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.72);
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No active games found. Create and activate a game in Library first.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: color),
        ),
      ),
    );
  }
}
