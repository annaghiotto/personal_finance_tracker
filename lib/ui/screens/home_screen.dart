import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_tracker/cubit/settings/settings_cubit.dart';
import 'package:personal_finance_tracker/cubit/transactions/transaction_cubit.dart';
import 'package:personal_finance_tracker/cubit/transactions/transaction_state.dart';

import 'package:personal_finance_tracker/data/models/transaction.dart';
import 'package:personal_finance_tracker/ui/screens/add_transaction_sheet.dart';
import 'package:personal_finance_tracker/ui/screens/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderSection(),
                const SizedBox(height: 24),
                _BalanceCard(balance: state.balance),
                const SizedBox(height: 24),
                _FilterSection(
                  currentFilter: state.filter,
                  onFilterChanged: (filter) {
                    context.read<TransactionCubit>().changeFilter(filter);
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _TransactionList(
                    transactions: state.filteredTransactions,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => BlocProvider.value(
                value: context.read<TransactionCubit>(),
                child: AddTransactionSheet(),
              ),
            );
          },
          icon: const Icon(Icons.add, size: 28),
          color: Colors.black,
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, User',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back to your Personal Finance Tracker',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                    ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;

  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context.watch<SettingsCubit>().state.currencySymbol;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet Balance',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "$currencySymbol${NumberFormat('#,##0.00').format(balance)}",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final TransactionFilter currentFilter;
  final ValueChanged<TransactionFilter> onFilterChanged;

  const _FilterSection({
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: currentFilter == TransactionFilter.all,
            onTap: () => onFilterChanged(TransactionFilter.all),
            isDark: isDark,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Income',
            isSelected: currentFilter == TransactionFilter.income,
            onTap: () => onFilterChanged(TransactionFilter.income),
            isDark: isDark,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Expenses',
            isSelected: currentFilter == TransactionFilter.expense,
            onTap: () => onFilterChanged(TransactionFilter.expense),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.black
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const _TransactionList({
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(75),
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your finances!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all transactions
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _TransactionCard(transaction: transactions[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencySymbol = context.watch<SettingsCubit>().state.currencySymbol;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to transaction details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transaction details: ${transaction.category}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.transparent : const Color(0xFFF0F0F0),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getCategoryColor(transaction.category).withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(transaction.category),
                  color: _getCategoryColor(transaction.category),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d, yyyy').format(transaction.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isIncome ? '+' : '-'}$currencySymbol${transaction.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(75),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final categoryLower = category.toLowerCase();
    
    if (categoryLower.contains('food') || categoryLower.contains('restaurant')) {
      return Icons.restaurant;
    } else if (categoryLower.contains('transport') || categoryLower.contains('uber') || categoryLower.contains('taxi')) {
      return Icons.directions_car;
    } else if (categoryLower.contains('shopping') || categoryLower.contains('amazon')) {
      return Icons.shopping_bag;
    } else if (categoryLower.contains('subscription') || categoryLower.contains('netflix') || categoryLower.contains('spotify')) {
      return Icons.subscriptions;
    } else if (categoryLower.contains('salary') || categoryLower.contains('income')) {
      return Icons.account_balance_wallet;
    } else if (categoryLower.contains('coffee') || categoryLower.contains('starbucks')) {
      return Icons.local_cafe;
    } else if (categoryLower.contains('entertainment') || categoryLower.contains('movie')) {
      return Icons.movie;
    } else if (categoryLower.contains('health') || categoryLower.contains('medical')) {
      return Icons.medical_services;
    } else if (categoryLower.contains('education')) {
      return Icons.school;
    } else if (categoryLower.contains('bill') || categoryLower.contains('utility')) {
      return Icons.receipt;
    } else {
      return Icons.attach_money;
    }
  }

  Color _getCategoryColor(String category) {
    final categoryLower = category.toLowerCase();
    
    if (categoryLower.contains('food') || categoryLower.contains('restaurant')) {
      return Colors.orange;
    } else if (categoryLower.contains('transport')) {
      return Colors.blue;
    } else if (categoryLower.contains('shopping')) {
      return Colors.purple;
    } else if (categoryLower.contains('subscription')) {
      return Colors.pink;
    } else if (categoryLower.contains('salary') || categoryLower.contains('income')) {
      return Colors.green;
    } else if (categoryLower.contains('coffee')) {
      return Colors.brown;
    } else if (categoryLower.contains('entertainment')) {
      return Colors.red;
    } else if (categoryLower.contains('health')) {
      return Colors.teal;
    } else if (categoryLower.contains('education')) {
      return Colors.indigo;
    } else {
      return Colors.grey;
    }
  }
}