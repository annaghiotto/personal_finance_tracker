import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finance_tracker/cubit/settings/settings_cubit.dart';
import 'package:personal_finance_tracker/cubit/settings/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SettingsCubit', () {
    late SettingsCubit settingsCubit;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
    });

    tearDown(() {
      settingsCubit.close();
    });

    group('initialization', () {
      test('initializes with light theme and default currency', () {
        // Arrange
        when(() => mockPrefs.getBool('isDark')).thenReturn(null);
        when(() => mockPrefs.getString('currencySymbol')).thenReturn(null);

        // Act
        settingsCubit = SettingsCubit(mockPrefs);

        // Assert
        expect(settingsCubit.state.themeMode, ThemeMode.light);
        expect(settingsCubit.state.currencySymbol, '€');
      });

      test('loads dark theme from preferences when saved', () {
        // Arrange
        when(() => mockPrefs.getBool('isDark')).thenReturn(true);
        when(() => mockPrefs.getString('currencySymbol')).thenReturn(null);

        // Act
        settingsCubit = SettingsCubit(mockPrefs);

        // Assert
        expect(settingsCubit.state.themeMode, ThemeMode.dark);
      });

      test('loads custom currency from preferences', () {
        // Arrange
        when(() => mockPrefs.getBool('isDark')).thenReturn(null);
        when(() => mockPrefs.getString('currencySymbol')).thenReturn('\$');

        // Act
        settingsCubit = SettingsCubit(mockPrefs);

        // Assert
        expect(settingsCubit.state.currencySymbol, '\$');
      });
    });

    group('toggleTheme', () {
      test('toggles from light to dark theme', () {
        // Arrange
        when(() => mockPrefs.getBool('isDark')).thenReturn(false);
        when(() => mockPrefs.getString('currencySymbol')).thenReturn('€');
        when(() => mockPrefs.setBool('isDark', any()))
            .thenAnswer((_) async => true);

        settingsCubit = SettingsCubit(mockPrefs);
        expect(settingsCubit.state.themeMode, ThemeMode.light);

        // Act
        settingsCubit.toggleTheme();

        // Assert
        expect(settingsCubit.state.themeMode, ThemeMode.dark);
        verify(() => mockPrefs.setBool('isDark', true)).called(1);
      });

      test('toggles from dark to light theme', () {
        // Arrange
        when(() => mockPrefs.getBool('isDark')).thenReturn(true);
        when(() => mockPrefs.getString('currencySymbol')).thenReturn('€');
        when(() => mockPrefs.setBool('isDark', any()))
            .thenAnswer((_) async => true);

        settingsCubit = SettingsCubit(mockPrefs);
        expect(settingsCubit.state.themeMode, ThemeMode.dark);

        // Act
        settingsCubit.toggleTheme();

        // Assert
        expect(settingsCubit.state.themeMode, ThemeMode.light);
        verify(() => mockPrefs.setBool('isDark', false)).called(1);
      });

      test('persists theme change to preferences', () {
        // Arrange
        when(() => mockPrefs.getBool('isDark')).thenReturn(false);
        when(() => mockPrefs.getString('currencySymbol')).thenReturn('€');
        when(() => mockPrefs.setBool('isDark', any()))
            .thenAnswer((_) async => true);

        settingsCubit = SettingsCubit(mockPrefs);

        // Act
        settingsCubit.toggleTheme();

        // Assert
        verify(() => mockPrefs.setBool('isDark', true)).called(1);
      });
    });

    group('changeCurrency', () {
      test('changes currency and persists to preferences', () {
        // Arrange
        when(() => mockPrefs.getBool('isDark')).thenReturn(null);
        when(() => mockPrefs.getString('currencySymbol')).thenReturn('€');
        when(() => mockPrefs.setString('currencySymbol', any()))
            .thenAnswer((_) async => true);

        settingsCubit = SettingsCubit(mockPrefs);
        expect(settingsCubit.state.currencySymbol, '€');

        // Act
        settingsCubit.changeCurrency('\$');

        // Assert
        expect(settingsCubit.state.currencySymbol, '\$');
        verify(() => mockPrefs.setString('currencySymbol', '\$')).called(1);
      });

      test('changes from dollar to pound currency', () {
        // Arrange
        when(() => mockPrefs.getBool('isDark')).thenReturn(null);
        when(() => mockPrefs.getString('currencySymbol')).thenReturn('\$');
        when(() => mockPrefs.setString('currencySymbol', any()))
            .thenAnswer((_) async => true);

        settingsCubit = SettingsCubit(mockPrefs);

        // Act
        settingsCubit.changeCurrency('£');

        // Assert
        expect(settingsCubit.state.currencySymbol, '£');
        verify(() => mockPrefs.setString('currencySymbol', '£')).called(1);
      });

      test('changes to yen currency', () {
        // Arrange
        when(() => mockPrefs.getBool('isDark')).thenReturn(null);
        when(() => mockPrefs.getString('currencySymbol')).thenReturn('€');
        when(() => mockPrefs.setString('currencySymbol', any()))
            .thenAnswer((_) async => true);

        settingsCubit = SettingsCubit(mockPrefs);

        // Act
        settingsCubit.changeCurrency('¥');

        // Assert
        expect(settingsCubit.state.currencySymbol, '¥');
        verify(() => mockPrefs.setString('currencySymbol', '¥')).called(1);
      });
    });

    group('state equality', () {
      test('two SettingsStates with same values are equal', () {
        // Arrange
        final state1 = const SettingsState(
          themeMode: ThemeMode.dark,
          currencySymbol: '\$',
        );
        final state2 = const SettingsState(
          themeMode: ThemeMode.dark,
          currencySymbol: '\$',
        );

        // Assert
        expect(state1, equals(state2));
      });

      test('two SettingsStates with different values are not equal', () {
        // Arrange
        final state1 = const SettingsState(
          themeMode: ThemeMode.dark,
          currencySymbol: '\$',
        );
        final state2 = const SettingsState(
          themeMode: ThemeMode.light,
          currencySymbol: '€',
        );

        // Assert
        expect(state1, isNot(equals(state2)));
      });
    });
  });
}