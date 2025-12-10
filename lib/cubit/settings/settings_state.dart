import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final String currencySymbol;

  const SettingsState({
    required this.themeMode,
    required this.currencySymbol,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      themeMode: ThemeMode.light,
      currencySymbol: '€', // default
    );
  }

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? currencySymbol,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }

  @override
  List<Object?> get props => [themeMode, currencySymbol];
}
