import 'package:expense_tracker/providers/theme.dart';
import 'package:flutter/material.dart';

extension ThemeUtils on BuildContext {
  ThemeData get theme => Theme.of(this);
  Function(ThemeMode) get setThemeMode => (mode) {
        ThemeSettingsChange(settings: ThemeSettings(themeMode: mode))
            .dispatch(this);
      };
}
