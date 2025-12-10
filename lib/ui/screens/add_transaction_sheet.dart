import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/cubit/transactions/transaction_cubit.dart';
import 'package:personal_finance_tracker/data/models/transaction.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _notesController = TextEditingController();

  String _type = 'expense'; // default to expense like in the design
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(75),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                Text(
                  'Add Transaction',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),

                // Type Selector (Income/Expense)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TypeButton(
                          label: 'Income',
                          icon: Icons.arrow_downward,
                          isSelected: _type == 'income',
                          onTap: () => setState(() => _type = 'income'),
                        ),
                      ),
                      Expanded(
                        child: _TypeButton(
                          label: 'Expense',
                          icon: Icons.arrow_upward,
                          isSelected: _type == 'expense',
                          onTap: () => setState(() => _type = 'expense'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        hintText: '0.00',
                        prefixIcon: Icon(Icons.attach_money),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: Theme.of(context).textTheme.titleLarge,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter an amount';
                        if (double.tryParse(value) == null) return 'Enter a valid number';
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Shopping, Food, Transport',
                        prefixIcon: Icon(Icons.category),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter a category';
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Date and Time
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() => _date = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_date.day}/${_date.month}/${_date.year}',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: _time,
                              );
                              if (picked != null) {
                                setState(() => _time = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    _time.format(context),
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Notes
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes (Optional)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        hintText: 'Add any additional notes...',
                        prefixIcon: Icon(Icons.notes),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    // Combine date and time
                    final txDateTime = DateTime(
                      _date.year,
                      _date.month,
                      _date.day,
                      _time.hour,
                      _time.minute,
                    );

                    final tx = Transaction(
                      amount: double.parse(_amountController.text),
                      type: _type,
                      category: _categoryController.text,
                      date: txDateTime,
                      notes: _notesController.text.isEmpty
                          ? null
                          : _notesController.text,
                    );

                    context.read<TransactionCubit>().addTransaction(tx);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Add Transaction',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.black
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}