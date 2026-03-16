import 'package:flutter/material.dart';
import 'package:xp_todo_app/data/models/quest.dart';
import 'package:xp_todo_app/theme/app_theme.dart';

class TodoItemCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback? onTap;

  const TodoItemCard({super.key, required this.quest, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dueDate = quest.expireDate;
    final isOverdue = dueDate != null && dueDate.isBefore(DateTime.now());

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
        decoration: BoxDecoration(
          color: AppColors.bgCard(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isOverdue ? AppColors.accentRed : AppColors.accentBlue,
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
                    style: TextStyle(
                      fontFamily: 'ExoTwo',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary(context),
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
                        style: TextStyle(
                          fontFamily: 'ShareTechMono',
                          fontSize: 9,
                          color: AppColors.textDim(context),
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
                  style: const TextStyle(
                    fontFamily: 'ShareTechMono',
                    fontSize: 11,
                    color: AppColors.accentGold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  dueDate == null
                      ? 'No due date'
                      : '${_monthLabel(dueDate.month)} ${dueDate.day}',
                  style: TextStyle(
                    fontFamily: 'ShareTechMono',
                    fontSize: 9,
                    color: isOverdue
                        ? AppColors.accentRed
                        : AppColors.textDim(context),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: color.withValues(alpha: 0.16),
        border: Border.all(color: color.withValues(alpha: 0.42)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Rajdhani',
          fontSize: 8,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w700,
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
