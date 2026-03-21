import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// adaptive_platform_ui
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';

// flutter_riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/firebase_options.dart';
import 'package:xp_todo_app/providers/go_router_provider.dart';
import 'package:xp_todo_app/theme/app_theme.dart';
import 'package:xp_todo_app/util/configure_firestore_cache.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // debugPrint("Initializing Firebase");
  // try {
  //   if (Firebase.apps.isEmpty) {
  //     await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform,
  //     );
  //   } else {
  //     Firebase.app();
  //   }
  // } on FirebaseException catch (e) {
  //   if (e.code == 'duplicate-app') {
  //     Firebase.app();
  //   } else {
  //     rethrow;
  //   }
  // }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await configureFirestoreCache();

  // TODO: use this to implement top level error catching and display a nice error screen instead of crashing
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   // In debug mode, show the normal red screen
  //   if (kDebugMode) return ErrorWidget(details.exception);
  //   // In release, show something clean
  //   return const _AppErrorWidget();
  // };
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return AdaptiveApp.router(
      title: 'XP Todo App',

      // GoRouter configuration
      routerConfig: router,

      // AdaptiveApp configuration
      themeMode: ThemeMode.system,
      materialLightTheme: AppMaterialTheme.light,
      materialDarkTheme: AppMaterialTheme.dark,
      cupertinoLightTheme: AppCupertinoTheme.light,
      cupertinoDarkTheme: AppCupertinoTheme.dark,
      // cupertinoLightTheme: const CupertinoThemeData(
      //   brightness: Brightness.light,
      // ),
      // cupertinoDarkTheme: const CupertinoThemeData(brightness: Brightness.dark),

      // Localization configuration
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // Important!
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English
        Locale('sp', ''), // Spanish
        // Add more locales as needed
      ],
    );
  }
}
