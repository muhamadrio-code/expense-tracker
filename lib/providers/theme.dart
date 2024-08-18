import 'package:expense_tracker/shared/app_theme.dart';
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

  ThemeData light() {
    final ColorScheme colorScheme = AppTheme.lightScheme();
    return AppTheme.theme(colorScheme);
  }

  ThemeData dark() {
    final ColorScheme colorScheme = AppTheme.darkScheme();
    return AppTheme.theme(colorScheme);
  }

  static ThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return true;
  }
}
