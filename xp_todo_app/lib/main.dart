import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// adaptive_platform_ui
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';

// flutter_riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/firebase_options.dart';
import 'package:xp_todo_app/theme/app_theme.dart';

// go_router
// router code
import 'routing/router_config.dart' as router_config;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveApp.router(
      title: 'XP Todo App',

      // GoRouter configuration
      routerConfig: router_config.mainRouter,

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
