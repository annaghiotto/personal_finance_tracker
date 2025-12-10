import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/data/models/transaction.dart';
import 'package:personal_finance_tracker/data/repositories/transaction_repository.dart';

import 'transaction_state.dart';

/// Cubit for managing transaction operations and state
class TransactionCubit extends Cubit<TransactionState> {
  /// Repository for transaction data operations
  final TransactionRepository _repository;

  /// Initialize with empty state
  TransactionCubit(this._repository) : super(TransactionState.initial());

  /// Load all transactions from repository
  Future<void> loadTransactions() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final all = _repository.getAll(); // List<Transaction>
      all.sort((a, b) => b.date.compareTo(a.date));
      final filtered = _applyFilter(all, state.filter);
      final balance = _calculateBalance(all);

      emit(
        state.copyWith(
          allTransactions: all,
          filteredTransactions: filtered,
          balance: balance,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Update the active filter and refresh filtered list
  void changeFilter(TransactionFilter filter) {
    final filtered = _applyFilter(state.allTransactions, filter);
    emit(
      state.copyWith(
        filter: filter,
        filteredTransactions: filtered,
      ),
    );
  }

  /// Add a new transaction and reload data
  Future<void> addTransaction(Transaction t) async {
    await _repository.add(t);
    await loadTransactions();
  }

  /// Delete transaction at given index and reload data
  Future<void> deleteTransaction(Transaction transaction) async {
    final all = state.allTransactions;

    final index = all.indexOf(transaction);
    if (index == -1) {
      return;
    }

    await _repository.delete(index);
    await loadTransactions();
  }

  /// Update transaction at given index and reload data
  Future<void> updateTransaction({
    required Transaction oldTransaction,
    required Transaction newTransaction,
  }) async {
    final all = state.allTransactions;
    final index = all.indexOf(oldTransaction);
    if (index == -1) return;

    await _repository.update(index, newTransaction);
    await loadTransactions();
  }

  /// Apply filter to transaction list based on type (income/expense/all)
  List<Transaction> _applyFilter(
    List<Transaction> all,
    TransactionFilter filter,
  ) {
    switch (filter) {
      case TransactionFilter.income:
        return all.where((t) => t.type == 'income').toList();
      case TransactionFilter.expense:
        return all.where((t) => t.type == 'expense').toList();
      case TransactionFilter.all:
      return all;
    }
  }

  /// Calculate total balance (income - expenses)
  double _calculateBalance(List<Transaction> all) {
    double balance = 0;
    for (final t in all) {
      if (t.type == 'income') {
        balance += t.amount;
      } else if (t.type == 'expense') {
        balance -= t.amount;
      }
    }
    return balance;
  }
}
