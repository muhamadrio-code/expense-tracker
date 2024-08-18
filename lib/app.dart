import 'package:expense_tracker/providers/theme.dart';
import 'package:expense_tracker/router/router.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (context, light, dark, mode) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: light,
        darkTheme: dark,
        routerDelegate: appRouter.routerDelegate,
        routeInformationParser: appRouter.routeInformationParser,
        routeInformationProvider: appRouter.routeInformationProvider,
      ),
    );
  }
}
