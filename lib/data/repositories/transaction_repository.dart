import 'package:hive/hive.dart';
import '../models/transaction.dart';

class TransactionRepository {
  final Box<Transaction> box = Hive.box<Transaction>('transactionsBox');

  List<Transaction> getAll() => box.values.toList();

  Future<void> add(Transaction t) async => box.add(t);

  Future<void> update(int index, Transaction t) async => box.putAt(index, t);

  Future<void> delete(int index) async => box.deleteAt(index);
}
