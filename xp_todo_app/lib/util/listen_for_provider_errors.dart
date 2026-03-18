import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void listenForProviderErrors<T>({
  required WidgetRef widgetRef,
  required BuildContext context,
  required ProviderListenable<AsyncValue<T>> provider,
}) {
  widgetRef.listen<AsyncValue<T>>(provider, (_, state) {
    if (state is AsyncError) {
      debugPrint(
        "ProviderListener on ${provider.toString()} caught error: ${state.error.toString()}",
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  });
}

// TODO: map errors to human readable strings for users
// String _friendlyError(Object error) {
//   // Map your sealed domain exceptions to user-facing messages
//   return switch (error) {
//     // PermissionDeniedException() => 'You don\'t have permission to do that.',
//     NetworkException() => 'Network error. Check your connection.',
//     // NotFoundExcepion()          => 'That item no longer exists.',
//     _ => 'Something went wrong. Please try again.',
//   };
// }
