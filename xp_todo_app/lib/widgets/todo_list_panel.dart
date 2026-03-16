import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/data/models/quest.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/providers/quest_providers.dart';
import 'package:xp_todo_app/providers/todo_ui_providers.dart';
import 'package:xp_todo_app/theme/app_theme.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/widgets/todo_item_card.dart';

class TodoListPanel extends ConsumerStatefulWidget {
  final String userId;

  const TodoListPanel({super.key, required this.userId});

  @override
  ConsumerState<TodoListPanel> createState() => _TodoListPanelState();
}

class _TodoListPanelState extends ConsumerState<TodoListPanel> {
  String? _selectedGameId;

  @override
  Widget build(BuildContext context) {
    final gamesAsync = ref.watch(activeGamesProvider(widget.userId));

    return gamesAsync.when(
      data: (games) {
        if (games.isEmpty) {
          return _EmptyTodoState(userId: widget.userId);
        }

        _selectedGameId ??= games.first.id;
        if (!games.any((g) => g.id == _selectedGameId)) {
          _selectedGameId = games.first.id;
        }

        final selectedGame = games.firstWhere((g) => g.id == _selectedGameId);
        return _TodoListContent(
          userId: widget.userId,
          games: games,
          selectedGame: selectedGame,
          onGameChanged: (next) => setState(() => _selectedGameId = next),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load games: $error')),
    );
  }
}

class _TodoListContent extends ConsumerWidget {
  final String userId;
  final List<Game> games;
  final Game selectedGame;
  final ValueChanged<String> onGameChanged;

  const _TodoListContent({
    required this.userId,
    required this.games,
    required this.selectedGame,
    required this.onGameChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questsAsync = ref.watch(questsProvider(userId, selectedGame.id));
    final segment = ref.watch(todoFilterProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Quests',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Track and complete your current objectives',
                style: TextStyle(
                  fontFamily: 'ShareTechMono',
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: AppColors.textSecondary(context),
                ),
              ),
              const SizedBox(height: 10),
              _GameSelector(
                games: games,
                selectedGameId: selectedGame.id,
                onChanged: onGameChanged,
              ),
              const SizedBox(height: 10),
              _TodoSegmentControl(current: segment),
            ],
          ),
        ),
        Expanded(
          child: questsAsync.when(
            data: (quests) {
              final filtered = _filterQuests(quests, segment);
              return _TodoListView(quests: filtered);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('Failed to load quests: $error')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () =>
                  _showCreateQuestDialog(context, ref, userId, selectedGame),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Quest'),
            ),
          ),
        ),
      ],
    );
  }

  List<Quest> _filterQuests(List<Quest> quests, TodoSegment segment) {
    final now = DateTime.now();
    final endOfSoon = now.add(const Duration(days: 3));

    bool include(Quest quest) {
      final due = quest.expireDate;
      switch (segment) {
        case TodoSegment.all:
          return true;
        case TodoSegment.overdue:
          return due != null && due.isBefore(now);
        case TodoSegment.upcoming:
          return due != null && due.isAfter(now) && due.isBefore(endOfSoon);
        case TodoSegment.undated:
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

class _TodoListView extends StatelessWidget {
  final List<Quest> quests;

  const _TodoListView({required this.quests});

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) {
      return Center(
        child: Text(
          'No quests in this segment.',
          style: TextStyle(color: AppColors.textSecondary(context)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      itemCount: quests.length,
      itemBuilder: (context, index) => TodoItemCard(quest: quests[index]),
    );
  }
}

class _TodoSegmentControl extends ConsumerWidget {
  final TodoSegment current;

  const _TodoSegmentControl({required this.current});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoSlidingSegmentedControl<TodoSegment>(
      groupValue: current,
      children: const {
        TodoSegment.all: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('All'),
        ),
        TodoSegment.overdue: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Overdue'),
        ),
        TodoSegment.upcoming: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Soon'),
        ),
        TodoSegment.undated: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('No Date'),
        ),
      },
      onValueChanged: (next) {
        if (next != null) {
          ref.read(todoFilterProvider.notifier).setSegment(next);
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
      value: selectedGameId,
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

class _EmptyTodoState extends StatelessWidget {
  final String userId;

  const _EmptyTodoState({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No active games found. Create and activate a game in Library first.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary(context)),
        ),
      ),
    );
  }
}

Future<void> _showCreateQuestDialog(
  BuildContext context,
  WidgetRef ref,
  String userId,
  Game selectedGame,
) async {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final xpController = TextEditingController(text: '50');
  final levelController = TextEditingController(text: '1');
  Difficulty selectedDifficulty = Difficulty.normal;
  DateTime? dueDate;

  await showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('New Quest'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: xpController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'XP'),
                            validator: (value) {
                              final parsed = int.tryParse(value ?? '');
                              if (parsed == null || parsed <= 0) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: levelController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Level',
                            ),
                            validator: (value) {
                              final parsed = int.tryParse(value ?? '');
                              if (parsed == null || parsed <= 0) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Difficulty>(
                      value: selectedDifficulty,
                      decoration: const InputDecoration(
                        labelText: 'Difficulty',
                      ),
                      items: Difficulty.values
                          .map(
                            (difficulty) => DropdownMenuItem(
                              value: difficulty,
                              child: Text(difficulty.displayName),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (next) {
                        if (next != null) {
                          setState(() => selectedDifficulty = next);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            dueDate == null
                                ? 'No due date'
                                : 'Due ${dueDate!.month}/${dueDate!.day}/${dueDate!.year}',
                            style: TextStyle(
                              color: AppColors.textSecondary(context),
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
                              initialDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => dueDate = picked);
                            }
                          },
                          child: const Text('Set date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  final quest = Quest(
                    id: '',
                    title: titleController.text.trim(),
                    xpReward: int.parse(xpController.text),
                    level: int.parse(levelController.text),
                    difficulty: selectedDifficulty,
                    userId: userId,
                    gameId: selectedGame.id,
                    completed: false,
                    isActive: true,
                    expireDate: dueDate,
                  );

                  await ref
                      .read(questActionProvider.notifier)
                      .createQuest(userId, selectedGame.id, quest);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      );
    },
  );
}
