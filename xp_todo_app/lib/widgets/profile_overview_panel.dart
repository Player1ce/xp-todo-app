import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/providers/user_profile_providers.dart';
import 'package:xp_todo_app/theme/app_theme.dart';

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
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF14243C), Color(0xFF1A2035)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.bgElevated(context),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.accentBlue),
            ),
            child: const Icon(Icons.person, color: AppColors.accentBlue),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  roleLabel,
                  style: TextStyle(
                    fontFamily: 'ShareTechMono',
                    fontSize: 10,
                    color: AppColors.accentBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary(context),
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
    final pct = (progress * 100).clamp(0, 100).toInt();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Completion',
            style: TextStyle(
              color: AppColors.textSecondary(context),
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
              color: AppColors.accentBlue,
              backgroundColor: AppColors.border(context),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$pct%',
              style: const TextStyle(
                fontFamily: 'ShareTechMono',
                color: AppColors.accentGold,
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary(context),
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
