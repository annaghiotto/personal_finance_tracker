import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/models/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactionsBox');

  //final box = Hive.box<Transaction>('transactionsBox');
  //print("Box opened with ${box.length} items");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance Tracker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const Placeholder(),
    );
  }
}
