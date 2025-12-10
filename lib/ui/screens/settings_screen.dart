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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Settings'),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              /*
              // Profile Section
              _ProfileSection(),
              const SizedBox(height: 24),
*/
              // Appearance Section
              _SectionHeader(title: 'Appearance'),
              const SizedBox(height: 12),
              _SettingsCard(
                child: _SettingsTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Toggle dark theme',
                  trailing: Switch(
                    value: isDark,
                    onChanged: (_) {
                      context.read<SettingsCubit>().toggleTheme();
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Currency Section
              _SectionHeader(title: 'Currency'),
              const SizedBox(height: 12),
              _SettingsCard(
                child: _CurrencySelector(
                  currentCurrency: state.currencySymbol,
                  onCurrencyChanged: (value) {
                    if (value != null) {
                      context.read<SettingsCubit>().changeCurrency(value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

/*
              // General Section
              _SectionHeader(title: 'General'),
              const SizedBox(height: 12),
              _SettingsCard(
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Manage notification settings',
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        // TODO: Navigate to notifications settings
                      },
                    ),
                    const Divider(height: 1),
                    _SettingsTile(
                      icon: Icons.security,
                      title: 'Security',
                      subtitle: 'Privacy and security settings',
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        // TODO: Navigate to security settings
                      },
                    ),
                    const Divider(height: 1),
                    _SettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help and support',
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        // TODO: Navigate to help
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // About Section
              _SectionHeader(title: 'About'),
              const SizedBox(height: 12),
              _SettingsCard(
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'App version and info',
                      trailing: Text(
                        'v1.0.0',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withAlpha(0.6),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        // TODO: Show terms
                      },
                    ),
                    const Divider(height: 1),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        // TODO: Show privacy policy
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Logout Button
              OutlinedButton(
                onPressed: () {
                  // TODO: Implement logout
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Implement logout logic
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Logout'),
              ),
              */
            ],
          ),
        );
      },
    );
  }
}

/*
class _ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              'A',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'name@example.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(0.6),
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Edit profile
            },
          ),
        ],
      ),
    );
  }
}
*/

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(210),
          ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.transparent : const Color(0xFFF0F0F0),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                          ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _CurrencySelector extends StatelessWidget {
  final String currentCurrency;
  final ValueChanged<String?> onCurrencyChanged;

  const _CurrencySelector({
    required this.currentCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currencies = [
      {'symbol': '€', 'name': 'Euro (EUR)', 'flag': '🇪🇺'},
      {'symbol': '\$', 'name': 'US Dollar (USD)', 'flag': '🇺🇸'},
      {'symbol': '£', 'name': 'British Pound (GBP)', 'flag': '🇬🇧'},
    ];

    return Column(
      children: currencies.map((currency) {
        final isSelected = currentCurrency == currency['symbol'];
        final isLast = currency == currencies.last;

        return Column(
          children: [
            InkWell(
              onTap: () => onCurrencyChanged(currency['symbol']),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      currency['flag']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currency['name']!,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Symbol: ${currency['symbol']}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.black,
                        ),
                      )
                    else
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (!isLast) const Divider(height: 1),
          ],
        );
      }).toList(),
    );
  }
}