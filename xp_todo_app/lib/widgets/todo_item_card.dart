import 'package:flutter/material.dart';
import 'package:xp_todo_app/data/models/quest.dart';

class TodoItemCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onCompletedChanged;
  final bool isBusy;

  const TodoItemCard({
    super.key,
    required this.quest,
    this.onTap,
    this.onCompletedChanged,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dueDate = quest.expireDate;
    final isOverdue = dueDate != null && dueDate.isBefore(DateTime.now());
    final isCompleted = quest.completed;
    final textColor = isCompleted
      ? colorScheme.onSurface.withValues(alpha: 0.56)
      : colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
        decoration: BoxDecoration(
          color: isCompleted
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: InkWell(
                onTap: onCompletedChanged == null || isBusy
                    ? null
                    : () => onCompletedChanged!(!isCompleted),
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.86),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                  ),
                  child: Center(
                    child: isBusy
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          )
                        : Icon(
                            isCompleted
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 16,
                            color: isCompleted
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.56),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 3,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isCompleted
                    ? colorScheme.outline
                    : isOverdue
                    ? colorScheme.error
                    : colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _Tag(
                        label: quest.difficulty.displayName,
                        color: quest.difficulty.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LVL ${quest.level}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.56),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+${quest.xpReward} XP',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isCompleted
                        ? colorScheme.onSurface.withValues(alpha: 0.56)
                        : colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  dueDate == null
                      ? 'No due date'
                      : '${_monthLabel(dueDate.month)} ${dueDate.day}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isOverdue
                        ? colorScheme.error
                        : colorScheme.onSurface.withValues(alpha: 0.56),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: color.withValues(alpha: 0.16),
        border: Border.all(color: color.withValues(alpha: 0.42)),
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
        ),
      ),
    );
  }
}

String _monthLabel(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}
