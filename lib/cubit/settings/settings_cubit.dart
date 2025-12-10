import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;

  static const _keyIsDark = 'isDark';
  static const _keyCurrency = 'currencySymbol';

  SettingsCubit(this._prefs) : super(SettingsState.initial()) {
    _loadSettings();
  }

  void _loadSettings() {
    // Theme
    final isDark = _prefs.getBool(_keyIsDark) ?? false;
    final theme = isDark ? ThemeMode.dark : ThemeMode.light;

    // Currency
    final savedCurrency = _prefs.getString(_keyCurrency) ?? '€';

    emit(state.copyWith(
      themeMode: theme,
      currencySymbol: savedCurrency,
    ));
  }

  void toggleTheme() {
    final isCurrentlyDark = state.themeMode == ThemeMode.dark;
    final newMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;

    _prefs.setBool(_keyIsDark, newMode == ThemeMode.dark);

    emit(state.copyWith(themeMode: newMode));
  }

  void changeCurrency(String symbol) {
    _prefs.setString(_keyCurrency, symbol);
    emit(state.copyWith(currencySymbol: symbol));
  }
}
