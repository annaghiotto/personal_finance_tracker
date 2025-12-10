import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  double amount;

  @HiveField(1)
  String type; // either 'income' or 'expense'

  @HiveField(2)
  String category;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String? notes;

  Transaction({
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
  });
}
