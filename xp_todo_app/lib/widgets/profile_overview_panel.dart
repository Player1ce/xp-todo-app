import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/providers/user_profile_providers.dart';

class ProfileOverviewPanel extends ConsumerWidget {
  final String userId;

  const ProfileOverviewPanel({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider(userId));
    final gamesAsync = ref.watch(gamesProvider(userId));

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const Center(child: Text('Profile not found.'));
        }

        final totalProgress = gamesAsync.maybeWhen(
          data: (games) {
            if (games.isEmpty) return 0.0;
            final value =
                games
                    .map((g) => g.completionPercentage)
                    .reduce((a, b) => a + b) /
                games.length;
            return value > 1 ? value / 100 : value;
          },
          orElse: () => 0.0,
        );

        final gameCount = gamesAsync.maybeWhen(
          data: (games) => games.length,
          orElse: () => 0,
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
          children: [
            _ProfileHeroCard(
              displayName: profile.fullName.isEmpty
                  ? 'Adventurer'
                  : profile.fullName,
              roleLabel: profile.role.displayName,
              email: profile.email ?? 'No email',
              onEdit: () => _showEditProfileDialog(
                context,
                ref,
                profile.id,
                profile.name ?? '',
              ),
            ),
            const SizedBox(height: 10),
            _ProgressCard(progress: totalProgress),
            const SizedBox(height: 10),
            _StatCard(title: 'Tracked Games', value: '$gameCount'),
            const SizedBox(height: 10),
            _StatCard(
              title: 'Security',
              value: profile.twoFactorEnabled ? '2FA Enabled' : '2FA Disabled',
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Failed to load profile: $error')),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  final String displayName;
  final String roleLabel;
  final String email;
  final VoidCallback onEdit;

  const _ProfileHeroCard({
    required this.displayName,
    required this.roleLabel,
    required this.email,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primaryContainer, colorScheme.surface],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colorScheme.primary),
            ),
            child: Icon(Icons.person, color: colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Rajdhani',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  roleLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'ShareTechMono',
                    fontSize: 10,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_rounded)),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final double progress;

  const _ProgressCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pct = (progress * 100).clamp(0, 100).toInt();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Completion',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.72),
              fontFamily: 'ShareTechMono',
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: progress,
              color: colorScheme.primary,
              backgroundColor: colorScheme.outline,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$pct%',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'ShareTechMono',
                color: colorScheme.secondary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.72),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontFamily: 'Rajdhani',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showEditProfileDialog(
  BuildContext context,
  WidgetRef ref,
  String userId,
  String currentName,
) async {
  final controller = TextEditingController(text: currentName);

  await showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Profile'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Display Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await ref
                  .read(userProfileActionProvider.notifier)
                  .updateUserProfile(userId, {'name': controller.text.trim()});
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
