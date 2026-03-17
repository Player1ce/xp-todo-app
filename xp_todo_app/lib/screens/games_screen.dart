import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/data/models/user_profile.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/providers/game_providers.dart';
import 'package:xp_todo_app/providers/repository_providers.dart';
import 'package:xp_todo_app/providers/user_profile_providers.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/widgets/game_card.dart';
import 'package:xp_todo_app/widgets/game_creation_dialog.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userActions = ref.watch(userProfileActionProvider.notifier);
    final gameActions = ref.watch(gameActionProvider.notifier);
    ref.listen<AsyncValue<void>>(gameActionProvider, (_, state) {
      if (state is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error.toString())));
      }
    });

    return authState.when(
      data: (user) {
        if (user == null) {
          return const Center(
            child: Text('Please sign in to view your library.'),
          );
        }
        final asyncActiveUser = ref.watch(activeUserProvider);
        UserProfile? activeUser;
        asyncActiveUser.when(
          data: (profile) {
            activeUser = profile;
          },
          loading: () {
            activeUser = null;
          },
          error: (error, _) {
            debugPrint('Error loading active user profile: $error');
            activeUser = null;
          },
        );

        final asyncUserExists = ref.watch(userExistsProvider(user.uid));
        bool? userExists = false;
        asyncUserExists.when(
          data: (exists) {
            userExists = exists;
          },
          loading: () {
            userExists = null;
          },
          error: (error, _) {
            debugPrint('Error checking if user exists: $error');
            userExists = null;
          },
        );

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("User exists: $userExists"),
              Text(
                activeUser == null
                    ? "Loading user profile..."
                    : "Edit User Profile: ${activeUser!.id} | phone Number: "
                          "${activeUser!.phoneNumber} | email: ${activeUser!.email} | displayName: ${activeUser!.name}",
              ),
              IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                  color: Color(0xFF4d9fff),
                ),
                onPressed: () {
                  userActions.updateUserProfile(
                    user.uid,
                    UserProfile.createUpdateMap(phoneNumber: "321213"),
                  );
                },
              ),
              Text("Create test Game"),
              IconButton(
                icon: Icon(Icons.add_box, size: 48, color: Color(0xFF4d9fff)),
                onPressed: () {
                  gameActions.createGame(
                    user.uid,
                    Game(
                      id: '', // will be set by backend
                      title: 'New Game',
                      description: '',
                      imageUrl: '',
                      availableXP: 0,
                      completedQuests: 0,
                      completionPercentage: 0.0,
                      difficulty: Difficulty.normal,
                      isActive: false,
                      totalQuests: 0,
                      totalXP: 0,
                      userId: user.uid,
                    ),
                  );
                },
              ),
            ],
          ),
        );

        // return AdaptiveScaffold(
        //   appBar: AdaptiveAppBar(title: 'Library'),
        //   body: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [Expanded(child: GamesGridView(userId: userId))],
        //   ),
        //   floatingActionButton: AdaptiveFloatingActionButton(
        //     onPressed: () {
        //       showDialog(
        //         context: context,
        //         builder: (context) => GameCreationDialog(userId: userId),
        //       );
        //     },
        //     tooltip: 'Create New Game',
        //     child: const Icon(Icons.add),
        //   ),
        // );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load user: $error')),
    );
  }
}
