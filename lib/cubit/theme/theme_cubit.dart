import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  // SharedPreferences instance to persist theme choice
  final SharedPreferences _prefs;

  static const _keyIsDark = 'isDark';

  ThemeCubit(this._prefs) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = _prefs.getBool(_keyIsDark) ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    final isCurrentlyDark = state == ThemeMode.dark;
    final newMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    _prefs.setBool(_keyIsDark, newMode == ThemeMode.dark);
    emit(newMode);
  }
}
