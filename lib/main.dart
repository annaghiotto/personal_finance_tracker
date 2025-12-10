import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_finance_tracker/cubit/theme/theme_cubit.dart';
import 'package:personal_finance_tracker/cubit/transactions/transaction_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/models/transaction.dart';
import 'data/repositories/transaction_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactionsBox');

  final prefs = await SharedPreferences.getInstance();
  final transactionRepository = TransactionRepository();

  runApp(
    MyApp(
      prefs: prefs,
      transactionRepository: transactionRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final TransactionRepository transactionRepository;

  const MyApp({
    super.key,
    required this.prefs,
    required this.transactionRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              TransactionCubit(transactionRepository)..loadTransactions(),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(prefs),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Personal Finance Tracker',
            themeMode: themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: Placeholder(),
          );
        },
      ),
    );
  }
}


