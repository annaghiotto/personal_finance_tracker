import 'package:equatable/equatable.dart';
import 'package:personal_finance_tracker/data/models/transaction.dart';

/// Filter options for transactions
enum TransactionFilter {
  all,
  income,
  expense,
}

/// State management for transactions
class TransactionState extends Equatable {
  final List<Transaction> allTransactions;
  final List<Transaction> filteredTransactions;
  final TransactionFilter filter;
  final double balance;
  final bool isLoading;
  final String? errorMessage;

  const TransactionState({
    required this.allTransactions,
    required this.filteredTransactions,
    required this.filter,
    required this.balance,
    required this.isLoading,
    this.errorMessage,
  });

  /// Initial empty state
  factory TransactionState.initial() {
    return const TransactionState(
      allTransactions: [],
      filteredTransactions: [],
      filter: TransactionFilter.all,
      balance: 0,
      isLoading: false,
      errorMessage: null,
    );
  }

  /// Create a copy with updated fields
  TransactionState copyWith({
    List<Transaction>? allTransactions,
    List<Transaction>? filteredTransactions,
    TransactionFilter? filter,
    double? balance,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TransactionState(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      filter: filter ?? this.filter,
      balance: balance ?? this.balance,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        allTransactions,
        filteredTransactions,
        filter,
        balance,
        isLoading,
        errorMessage,
      ];
}
