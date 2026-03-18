import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/theme/app_theme.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onActiveChanged;

  const GameCard({
    super.key,
    required this.game,
    this.onTap,
    this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = AppColors.bgCard(context);
    final borderColor = AppColors.border(context);
    final textColor = AppColors.textPrimary(context);
    final dimColor = AppColors.textDim(context);
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.22)
        : Colors.black.withValues(alpha: 0.10);
    final progress = _normalizedCompletion(game.completionPercentage);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  _GameCover(imageUrl: game.imageUrl),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _ActiveBadge(
                      isActive: game.isActive,
                      onTap: onActiveChanged,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.accentBlueDark,
                              AppColors.accentBlue,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontFamily: 'ShareTechMono',
                          fontSize: 9,
                          color: dimColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${game.completedQuests}/${game.totalQuests}',
                        style: TextStyle(
                          fontFamily: 'ShareTechMono',
                          fontSize: 9,
                          color: dimColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _normalizedCompletion(double value) {
    final normalized = value <= 1 ? value : value / 100;
    return normalized.clamp(0.0, 1.0);
  }
}

class ProviderGameCard extends ConsumerWidget {
  final String userId;
  final String gameId;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onActiveChanged;

  const ProviderGameCard({
    super.key,
    required this.userId,
    required this.gameId,
    this.onTap,
    this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(gameProvider(userId, gameId));

    return gameAsync.when(
      data: (game) {
        if (game == null) {
          return const _GameCardSkeleton();
        }
        return GameCard(
          game: game,
          onTap: onTap,
          onActiveChanged:
              onActiveChanged ??
              (nextActive) => ref
                  .read(gameActionProvider.notifier)
                  .setGameActive(
                    userId: userId,
                    gameId: game.id,
                    isActive: nextActive,
                  ),
        );
      },
      loading: () => const _GameCardSkeleton(),
      error: (_, _) => const _GameCardError(),
    );
  }
}

class GamesGridView extends ConsumerWidget {
  final bool activeOnly;
  final EdgeInsetsGeometry padding;
  final ValueChanged<Game>? onGameTap;
  final void Function(Game game, bool nextActive)? onGameActiveChanged;

  const GamesGridView({
    super.key,
    this.activeOnly = false,
    this.padding = const EdgeInsets.all(12),
    this.onGameTap,
    this.onGameActiveChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(requiredAuthStateProvider);
    final gamesAsync = ref.watch(
      activeOnly
          ? activeGamesProvider(authState.uid)
          : gamesProvider(authState.uid),
    );

    // ref.listen<AsyncValue<Game?>>(gameActionProvider, (previous, next) {
    //   next.whenOrNull(
    //     data: (game) {
    //       if (game != null) {
    //         // createGame completed — navigate to new game
    //         context.push(game.id);
    //       }
    //       // game == null means another action completed — no navigation needed
    //     },
    //     error: (e, _) => AdaptiveSnackBar.show(
    //       context,
    //       message: 'Something went wrong',
    //       type: AdaptiveSnackBarType.error,
    //     ),
    //   );
    // });

    return gamesAsync.when(
      data: (games) {
        if (games.isEmpty) {
          return const Center(child: Text('No games yet.'));
        }

        return GridView.builder(
          padding: padding,
          itemCount: games.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.67,
          ),
          itemBuilder: (context, index) {
            final game = games[index];
            return GameCard(
              game: game,
              onTap: onGameTap != null ? () => onGameTap!(game) : null,
              onActiveChanged: (nextActive) {
                if (onGameActiveChanged != null) {
                  onGameActiveChanged!(game, nextActive);
                  return;
                }

                ref
                    .read(gameActionProvider.notifier)
                    .setGameActive(
                      userId: authState.uid,
                      gameId: game.id,
                      isActive: nextActive,
                    );
              },
            );
          },
        );
      },
      loading: () => GridView.builder(
        padding: padding,
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.67,
        ),
        itemBuilder: (_, _) => const _GameCardSkeleton(),
      ),
      error: (error, _) => Center(
        child: Text(
          'Failed to load games: $error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _GameCover extends StatelessWidget {
  final String imageUrl;

  const _GameCover({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.trim().isEmpty) {
      return _gradientPlaceholder(context);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _gradientPlaceholder(context),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _gradientPlaceholder(context);
      },
    );
  }

  Widget _gradientPlaceholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? const [Color(0xFF1A2A50), Color(0xFF0E1520)]
        : const [Color(0xFFDCE8FF), Color(0xFFEEF3FF)];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.videogame_asset_rounded,
          size: 22,
          color: AppColors.textDim(context),
        ),
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool>? onTap;

  const _ActiveBadge({required this.isActive, this.onTap});

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? AppColors.accentGreen
        : AppColors.borderBright(context);
    final iconColor = isActive
        ? AppColors.accentGreen
        : AppColors.textDim(context);

    return InkWell(
      onTap: onTap == null ? null : () => onTap!(!isActive),
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: AppColors.bgPrimary(context).withValues(alpha: 0.86),
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Icon(
            isActive ? Icons.check : Icons.circle_outlined,
            size: 11,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

class _GameCardSkeleton extends StatelessWidget {
  const _GameCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final block = AppColors.border(context).withValues(alpha: 0.35);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: block,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10, width: double.infinity, color: block),
                const SizedBox(height: 6),
                Container(height: 3, width: double.infinity, color: block),
                const SizedBox(height: 5),
                Container(height: 8, width: 40, color: block),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCardError extends StatelessWidget {
  const _GameCardError();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accentRed.withValues(alpha: 0.45)),
      ),
      child: const Center(
        child: Icon(Icons.error_outline_rounded, color: AppColors.accentRed),
      ),
    );
  }
}
