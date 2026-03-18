import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/const/route_constants.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/providers/firebase_providers.dart';
import 'package:xp_todo_app/providers/go_router_provider.dart';
import 'package:xp_todo_app/providers/user_profile_providers.dart';
import 'package:xp_todo_app/util/enums/user_role.dart';
import 'package:xp_todo_app/widgets/profile_overview_panel.dart';
import 'package:xp_todo_app/widgets/sign_in_required_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    // final router = ref.watch(routerProvider);
    final userRolesAsync = ref.watch(userRolesProvider());

    return authState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Auth error: $error')),
      data: (user) {
        if (user == null) {
          return SignInRequiredWidget(
            message: "Please sign in to view your profile.",
          );
        }
        final isAdmin = userRolesAsync.maybeWhen(
          data: (roles) => roles.contains(UserRole.admin),
          orElse: () => false,
        );

        // return AdaptiveScaffold(
        return Scaffold(
          // appBar: AsaptiveAppBar(
          appBar: AppBar(
            // backgroundColor: Colors.red,
            title: Text("Profile"),
            actions: [
              // logout
              // AdaptiveAppBarAction(
              IconButton(
                onPressed: () {
                  ref.read(firebaseAuthProvider).signOut();
                },
                icon: Icon(Icons.logout),
                // iosSymbol: 'rectangle.portrait.and.arrow.right',
                // title: "Logout",
              ),
              if (isAdmin)
                // AdaptiveAppBarAction(
                // AdaptiveAppBarAction(
                IconButton(
                  onPressed: () async {
                    await ref
                        .read(goRouterProvider)
                        .push(RouteConstants.adminPage);
                  },
                  icon: Icon(Icons.admin_panel_settings),

                  // iosSymbol: 'person.crop.circle.badge.exclam',
                  // title: "Admin Page",
                ),
            ],
          ), // TODO: center app bar text
          body: ProfileOverviewPanel(userId: user.uid),
        );
      },
    );
  }
}
