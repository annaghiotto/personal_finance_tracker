import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_tracker/cubit/theme/theme_cubit.dart';
import 'package:personal_finance_tracker/cubit/transactions/transaction_cubit.dart';
import 'package:personal_finance_tracker/cubit/transactions/transaction_state.dart';

import 'package:personal_finance_tracker/data/models/transaction.dart';
import 'package:personal_finance_tracker/ui/screens/add_transaction_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Finance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
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
              _BalanceSection(balance: state.balance),
              const SizedBox(height: 8),
              _FilterSection(
                currentFilter: state.filter,
                onFilterChanged: (filter) {
                  context.read<TransactionCubit>().changeFilter(filter);
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _TransactionList(
                  transactions: state.filteredTransactions,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => BlocProvider.value(
              value: context.read<TransactionCubit>(),
              child: AddTransactionSheet(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BalanceSection extends StatelessWidget {
  final double balance;

  const _BalanceSection({required this.balance});

  @override
  Widget build(BuildContext context) {
    final isPositive = balance >= 0;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balance',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            balance.toStringAsFixed(2),
            style: textTheme.headlineMedium?.copyWith(
              color: isPositive ? Colors.green : Colors.red,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('All'),
          selected: currentFilter == TransactionFilter.all,
          onSelected: (_) => onFilterChanged(TransactionFilter.all),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('Incoming'),
          selected: currentFilter == TransactionFilter.income,
          onSelected: (_) => onFilterChanged(TransactionFilter.income),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('Expenses'),
          selected: currentFilter == TransactionFilter.expense,
          onSelected: (_) => onFilterChanged(TransactionFilter.expense),
        ),
      ],
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
      return const Center(
        child: Text('Still nothing here. Add some transactions!'),
      );
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final t = transactions[index];
        final isIncome = t.type == 'income';
        final sign = isIncome ? '+' : '-';

        return ListTile(
          leading: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
          ),
          title: Text(t.category),
          subtitle: Text(
            '${DateFormat('yyyy-MM-dd HH:mm:ss').format(t.date)}${t.notes != null ? ' • ${t.notes}' : ''}',
          ),
          trailing: Text(
            '$sign${t.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isIncome ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
