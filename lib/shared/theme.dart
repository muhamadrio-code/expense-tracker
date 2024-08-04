import 'package:flutter/material.dart';

class ThemeSettings {
  final Color sourceColor;
  final ThemeMode themeMode;

  const ThemeSettings({required this.sourceColor, required this.themeMode});
}

class AppThemeProvider extends InheritedWidget {
  const AppThemeProvider(
      {required this.settings, required super.child, super.key});

  final ValueNotifier<ThemeSettings> settings;

  final pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  static AppThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeProvider>()!;
  }

  ShapeBorder get shapeMedium => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      );

  ColorScheme colors(Brightness brightness) => ColorScheme(
        brightness: brightness,
        primary: const Color(0xFFD6FF65),
        onPrimary: const Color(0xFF252525),
        error: const Color(0xffba1a1a),
        onError: const Color(0xfff5f5f5),
        secondary: const Color(0xFF1D1D1D),
        onSecondary: const Color(0xffffffff),
        surface: const Color(0xFF252525),
        onSurface: const Color(0xFFF5F5F5),
        surfaceDim: const Color(0xffdbdbcf),
      );

  ThemeData dark() {
    final colorScheme = colors(Brightness.dark);
    return ThemeData(
        pageTransitionsTheme: pageTransitionsTheme,
        colorScheme: colorScheme,
        bottomAppBarTheme: bottomAppBarTheme(colorScheme),
        scaffoldBackgroundColor: colorScheme.surface,
        iconTheme: iconTheme(colorScheme),
        floatingActionButtonTheme: floatingActionButton(colorScheme),
        useMaterial3: true);
  }

  @override
  bool updateShouldNotify(covariant AppThemeProvider oldWidget) {
    return oldWidget.settings != settings;
  }

  BottomAppBarTheme bottomAppBarTheme(ColorScheme colorScheme) {
    return BottomAppBarTheme(
      color: colorScheme.surface,
      height: 55,
    );
  }

  IconThemeData iconTheme(ColorScheme colorScheme) {
    return IconThemeData(color: colorScheme.onSurface, size: 35);
  }

  FloatingActionButtonThemeData floatingActionButton(ColorScheme colorScheme) {
    return FloatingActionButtonThemeData(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        shape: const CircleBorder(),
        iconSize: 35,
        elevation: 0,
        sizeConstraints: const BoxConstraints(minWidth: 50, minHeight: 50));
  }
}
