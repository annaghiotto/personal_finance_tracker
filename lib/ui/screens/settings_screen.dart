import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/cubit/settings/settings_cubit.dart';
import 'package:personal_finance_tracker/cubit/settings/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;

        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark mode'),
                value: isDark,
                onChanged: (_) {
                  context.read<SettingsCubit>().toggleTheme();
                },
              ),
              ListTile(
                title: const Text('Currency'),
                subtitle: Text(state.currencySymbol),
                trailing: DropdownButton<String>(
                  value: state.currencySymbol,
                  items: const [
                    DropdownMenuItem(value: '€', child: Text('Euro')),
                    DropdownMenuItem(value: '\$', child: Text('US Dollars')),
                    DropdownMenuItem(value: '£', child: Text('UK Pounds')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsCubit>().changeCurrency(value);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
