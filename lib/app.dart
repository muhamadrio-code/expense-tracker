import 'package:expense_tracker/router/router.dart';
import 'package:expense_tracker/shared/theme.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ValueNotifier<ThemeSettings> settings = ValueNotifier(
      const ThemeSettings(
          sourceColor: Color(0xFFD6FF65), themeMode: ThemeMode.system));

  @override
  Widget build(BuildContext context) {
    return AppThemeProvider(
      settings: settings,
      // !Toggle theme mode are not available yet
      child: ValueListenableBuilder<ThemeSettings>(
        valueListenable: settings,
        builder: (context, value, _) {
          final theme = AppThemeProvider.of(context);
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: theme.dark(),
            routerDelegate: appRouter.routerDelegate,
            routeInformationParser: appRouter.routeInformationParser,
            routeInformationProvider: appRouter.routeInformationProvider,
          );
        },
      ),
    );
  }
}
