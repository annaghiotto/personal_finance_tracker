import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finance_tracker/cubit/transactions/transaction_cubit.dart';
import 'package:personal_finance_tracker/cubit/transactions/transaction_state.dart';
import 'package:personal_finance_tracker/data/models/transaction.dart';
import 'package:personal_finance_tracker/data/repositories/transaction_repository.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      Transaction(
        amount: 0,
        type: 'expense',
        category: 'Unknown',
        date: DateTime.now(),
      ),
    );
  });

  group('TransactionCubit', () {
    late TransactionCubit transactionCubit;
    late MockTransactionRepository mockRepository;

    setUp(() {
      mockRepository = MockTransactionRepository();
      transactionCubit = TransactionCubit(mockRepository);
    });

    tearDown(() {
      transactionCubit.close();
    });

    group('loadTransactions', () {
      test('emits [loading, loaded] when transactions are loaded successfully',
          () async {
        // Arrange
        final transactions = [
          Transaction(
            amount: 100,
            type: 'income',
            category: 'Salary',
            date: DateTime(2025, 12, 10),
          ),
          Transaction(
            amount: 50,
            type: 'expense',
            category: 'Food',
            date: DateTime(2025, 12, 9),
          ),
        ];

        when(() => mockRepository.getAll()).thenReturn(transactions);

        // Act & Assert
        expect(
          transactionCubit.stream,
          emitsInOrder([
            predicate<TransactionState>((state) =>
                state.isLoading == true && state.errorMessage == null),
            predicate<TransactionState>((state) =>
                state.isLoading == false &&
                state.allTransactions.length == 2 &&
                state.balance == 50),
          ]),
        );

        await transactionCubit.loadTransactions();
      });

      test('emits error state when repository throws exception', () async {
        // Arrange
        when(() => mockRepository.getAll())
            .thenThrow(Exception('Failed to load'));

        // Act & Assert
        expect(
          transactionCubit.stream,
          emitsInOrder([
            predicate<TransactionState>((state) => state.isLoading == true),
            predicate<TransactionState>((state) =>
                state.isLoading == false &&
                state.errorMessage != null &&
                state.errorMessage!.contains('Failed to load')),
          ]),
        );

        await transactionCubit.loadTransactions();
      });

      test('sorts transactions by date in descending order', () async {
        // Arrange
        final oldTransaction = Transaction(
          amount: 100,
          type: 'income',
          category: 'Salary',
          date: DateTime(2025, 12, 1),
        );
        final newTransaction = Transaction(
          amount: 50,
          type: 'expense',
          category: 'Food',
          date: DateTime(2025, 12, 10),
        );

        when(() => mockRepository.getAll())
            .thenReturn([oldTransaction, newTransaction]);

        // Act
        await transactionCubit.loadTransactions();

        // Assert
        expect(transactionCubit.state.allTransactions[0], newTransaction);
        expect(transactionCubit.state.allTransactions[1], oldTransaction);
      });

      test('correctly calculates balance from income and expenses', () async {
        // Arrange
        final transactions = [
          Transaction(
            amount: 1000,
            type: 'income',
            category: 'Salary',
            date: DateTime(2025, 12, 10),
          ),
          Transaction(
            amount: 300,
            type: 'expense',
            category: 'Food',
            date: DateTime(2025, 12, 9),
          ),
          Transaction(
            amount: 200,
            type: 'expense',
            category: 'Transport',
            date: DateTime(2025, 12, 8),
          ),
          Transaction(
            amount: 500,
            type: 'income',
            category: 'Freelance',
            date: DateTime(2025, 12, 7),
          ),
        ];

        when(() => mockRepository.getAll()).thenReturn(transactions);

        // Act
        await transactionCubit.loadTransactions();

        // Assert
        expect(transactionCubit.state.balance, 1000); // 1000 + 500 - 300 - 200
      });
    });

    group('changeFilter', () {
      test('filters to show only income transactions', () async {
        // Arrange
        final allTransactions = [
          Transaction(
            amount: 100,
            type: 'income',
            category: 'Salary',
            date: DateTime(2025, 12, 10),
          ),
          Transaction(
            amount: 50,
            type: 'expense',
            category: 'Food',
            date: DateTime(2025, 12, 9),
          ),
          Transaction(
            amount: 200,
            type: 'income',
            category: 'Freelance',
            date: DateTime(2025, 12, 8),
          ),
        ];

        when(() => mockRepository.getAll()).thenReturn(allTransactions);
        await transactionCubit.loadTransactions();

        // Act
        transactionCubit.changeFilter(TransactionFilter.income);

        // Assert
        expect(transactionCubit.state.filteredTransactions.length, 2);
        expect(
            transactionCubit.state.filteredTransactions
                .every((t) => t.type == 'income'),
            true);
      });

      test('filters to show only expense transactions', () async {
        // Arrange
        final allTransactions = [
          Transaction(
            amount: 100,
            type: 'income',
            category: 'Salary',
            date: DateTime(2025, 12, 10),
          ),
          Transaction(
            amount: 50,
            type: 'expense',
            category: 'Food',
            date: DateTime(2025, 12, 9),
          ),
          Transaction(
            amount: 30,
            type: 'expense',
            category: 'Transport',
            date: DateTime(2025, 12, 8),
          ),
        ];

        when(() => mockRepository.getAll()).thenReturn(allTransactions);
        await transactionCubit.loadTransactions();

        // Act
        transactionCubit.changeFilter(TransactionFilter.expense);

        // Assert
        expect(transactionCubit.state.filteredTransactions.length, 2);
        expect(
            transactionCubit.state.filteredTransactions
                .every((t) => t.type == 'expense'),
            true);
      });

      test('shows all transactions when filter is set to all', () async {
        // Arrange
        final allTransactions = [
          Transaction(
            amount: 100,
            type: 'income',
            category: 'Salary',
            date: DateTime(2025, 12, 10),
          ),
          Transaction(
            amount: 50,
            type: 'expense',
            category: 'Food',
            date: DateTime(2025, 12, 9),
          ),
        ];

        when(() => mockRepository.getAll()).thenReturn(allTransactions);
        await transactionCubit.loadTransactions();

        // Act
        transactionCubit.changeFilter(TransactionFilter.all);

        // Assert
        expect(transactionCubit.state.filteredTransactions.length, 2);
      });
    });

    group('addTransaction', () {
      test('adds transaction and reloads data', () async {
        // Arrange
        final initialTransaction = Transaction(
          amount: 100,
          type: 'income',
          category: 'Salary',
          date: DateTime(2025, 12, 10),
        );

        final newTransaction = Transaction(
          amount: 50,
          type: 'expense',
          category: 'Food',
          date: DateTime(2025, 12, 9),
        );

        when(() => mockRepository.getAll()).thenReturn([initialTransaction]);
        when(() => mockRepository.add(any())).thenAnswer((_) async {});

        await transactionCubit.loadTransactions();

        when(() => mockRepository.getAll())
            .thenReturn([initialTransaction, newTransaction]);

        // Act
        await transactionCubit.addTransaction(newTransaction);

        // Assert
        verify(() => mockRepository.add(newTransaction)).called(1);
        expect(transactionCubit.state.allTransactions.length, 2);
      });
    });

    group('deleteTransaction', () {
      test('deletes transaction and reloads data', () async {
        // Arrange
        final transaction1 = Transaction(
          amount: 100,
          type: 'income',
          category: 'Salary',
          date: DateTime(2025, 12, 10),
        );

        final transaction2 = Transaction(
          amount: 50,
          type: 'expense',
          category: 'Food',
          date: DateTime(2025, 12, 9),
        );

        when(() => mockRepository.getAll())
            .thenReturn([transaction1, transaction2]);
        when(() => mockRepository.delete(any())).thenAnswer((_) async {});

        await transactionCubit.loadTransactions();

        when(() => mockRepository.getAll()).thenReturn([transaction1]);

        // Act
        await transactionCubit.deleteTransaction(transaction2);

        // Assert
        verify(() => mockRepository.delete(any())).called(1);
        expect(transactionCubit.state.allTransactions.length, 1);
      });

      test('does nothing if transaction not found', () async {
        // Arrange
        final transaction = Transaction(
          amount: 100,
          type: 'income',
          category: 'Salary',
          date: DateTime(2025, 12, 10),
        );

        final nonExistentTransaction = Transaction(
          amount: 50,
          type: 'expense',
          category: 'Food',
          date: DateTime(2025, 12, 9),
        );

        when(() => mockRepository.getAll()).thenReturn([transaction]);
        await transactionCubit.loadTransactions();

        // Act
        await transactionCubit.deleteTransaction(nonExistentTransaction);

        // Assert
        verifyNever(() => mockRepository.delete(any()));
      });
    });

    group('updateTransaction', () {
      test('updates transaction and reloads data', () async {
        // Arrange
        final oldTransaction = Transaction(
          amount: 100,
          type: 'income',
          category: 'Salary',
          date: DateTime(2025, 12, 10),
        );

        final updatedTransaction = Transaction(
          amount: 120,
          type: 'income',
          category: 'Salary',
          date: DateTime(2025, 12, 10),
        );

        when(() => mockRepository.getAll()).thenReturn([oldTransaction]);
        when(() => mockRepository.update(any(), any()))
            .thenAnswer((_) async {});

        await transactionCubit.loadTransactions();

        when(() => mockRepository.getAll()).thenReturn([updatedTransaction]);

        // Act
        await transactionCubit.updateTransaction(
          oldTransaction: oldTransaction,
          newTransaction: updatedTransaction,
        );

        // Assert
        verify(() => mockRepository.update(any(), any())).called(1);
        expect(transactionCubit.state.allTransactions[0].amount, 120);
      });

      test('does nothing if old transaction not found', () async {
        // Arrange
        final transaction = Transaction(
          amount: 100,
          type: 'income',
          category: 'Salary',
          date: DateTime(2025, 12, 10),
        );

        final nonExistentTransaction = Transaction(
          amount: 50,
          type: 'expense',
          category: 'Food',
          date: DateTime(2025, 12, 9),
        );

        final updatedTransaction = Transaction(
          amount: 150,
          type: 'expense',
          category: 'Food',
          date: DateTime(2025, 12, 9),
        );

        when(() => mockRepository.getAll()).thenReturn([transaction]);
        await transactionCubit.loadTransactions();

        // Act
        await transactionCubit.updateTransaction(
          oldTransaction: nonExistentTransaction,
          newTransaction: updatedTransaction,
        );

        // Assert
        verifyNever(() => mockRepository.update(any(), any()));
      });
    });
  });
}