import 'package:expense_tracker/shared/color_scheme.dart';
import 'package:flutter/material.dart';

class AppThemeBuilder extends StatefulWidget {
  final Widget Function(
          BuildContext context, ThemeData light, ThemeData dark, ThemeMode mode)
      builder;

  const AppThemeBuilder({super.key, required this.builder});

  @override
  State<AppThemeBuilder> createState() => _AppThemeBuilderState();
}

class _AppThemeBuilderState extends State<AppThemeBuilder> {
  final ValueNotifier<ThemeSettings> _themeSettings =
      ValueNotifier(const ThemeSettings(themeMode: ThemeMode.system));

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      child: NotificationListener<ThemeSettingsChange>(
        onNotification: (notification) {
          _themeSettings.value = notification.settings;
          return true;
        },
        child: ValueListenableBuilder(
          valueListenable: _themeSettings,
          builder: (context, value, child) {
            final theme = ThemeProvider.of(context);
            return widget.builder(
                context, theme.light(), theme.dark(), value.themeMode);
          },
        ),
      ),
    );
  }
}

class ThemeSettingsChange extends Notification {
  const ThemeSettingsChange({required this.settings});
  final ThemeSettings settings;
}

class ThemeSettings {
  const ThemeSettings({required this.themeMode});
  final ThemeMode themeMode;
}

class ThemeProvider extends InheritedWidget {
  const ThemeProvider({super.key, required super.child});

  final pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: pageTransitionsTheme,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        navigationBarTheme: _navigationBarTheme(colorScheme),
        bottomNavigationBarTheme: _bottomNavigationBarTheme(colorScheme),
        listTileTheme: _listTileTheme(colorScheme),
        tabBarTheme: _tabBarTheme(colorScheme),
        textButtonTheme: _textButtonTheme(colorScheme),
        canvasColor: colorScheme.surface,
      );

  ThemeData light() {
    final ColorScheme colorScheme = AppColorScheme.lightScheme();
    return theme(colorScheme);
  }

  ThemeData dark() {
    final ColorScheme colorScheme = AppColorScheme.darkScheme();
    return theme(colorScheme);
  }

  static ThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return true;
  }

  NavigationBarThemeData _navigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.surface,
    );
  }

  BottomNavigationBarThemeData _bottomNavigationBarTheme(
      ColorScheme colorScheme) {
    return BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.shifting);
  }

  ListTileThemeData _listTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      tileColor: Colors.white,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      subtitleTextStyle: TextStyle(
        color: colorScheme.onSurface.withOpacity(.5),
        fontWeight: FontWeight.w900,
        letterSpacing: .8,
      ),
    );
  }

  TextButtonThemeData _textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(0.0)),
        backgroundColor: WidgetStateProperty.all<Color>(colorScheme.surfaceDim),
        foregroundColor: WidgetStateProperty.all<Color>(colorScheme.onSurface),
        shape: WidgetStateProperty.all<ContinuousRectangleBorder>(
          ContinuousRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        minimumSize:
            WidgetStateProperty.all<Size>(const Size(double.infinity, 48)),
      ),
    );
  }

  TabBarTheme _tabBarTheme(ColorScheme colorScheme) {
    return TabBarTheme(
      labelPadding: const EdgeInsets.all(8),
      overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      labelColor: colorScheme.onPrimary,
      indicatorColor: colorScheme.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      indicator: ShapeDecoration(
        color: colorScheme.primary,
        shape: const ContinuousRectangleBorder(),
      ),
    );
  }
}
