import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// adaptive_platform_ui
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';

// flutter_riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// go_router
import 'package:go_router/go_router.dart';
// router code
import 'routing/router_config.dart' as router_config;

void main() {
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
      materialLightTheme: ThemeData.light(),
      materialDarkTheme: ThemeData.dark(),
      cupertinoLightTheme: const CupertinoThemeData(
        brightness: Brightness.light,
      ),
      cupertinoDarkTheme: const CupertinoThemeData(brightness: Brightness.dark),

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
