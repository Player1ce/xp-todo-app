import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/const/route_constants.dart';

class SignInRequiredWidget extends ConsumerWidget {
  final String message;
  const SignInRequiredWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveScaffold(
      // ← add this
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_outlined, size: 48),
            const SizedBox(height: 8),
            Text(message, style: Theme.of(context).textTheme.headlineMedium),
            AdaptiveButton(
              onPressed: () {
                context.go(RouteConstants.login);
              },
              label: "Sign In",
            ),
          ],
        ),
      ),
    );
  }
}
