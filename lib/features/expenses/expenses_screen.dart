// lib/features/expenses/expenses_screen.dart
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/garden_providers.dart';
import '../../core/providers/database_provider.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/empty_state.dart';
class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(allExpensesProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: expensesAsync.when(
        data: (expenses) {
          final total = expenses.fold(0.0, (s, e) => s + e.amount);
          return CustomScrollView(
            slivers: [
              const SliverAppBar.large(title: Text('💰 Expenses')),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Card(
                    color: cs.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Spent',
                              style: tt.titleMedium?.copyWith(
                                  color: cs.onPrimaryContainer)),
                          Text(formatCurrency(total),
                              style: tt.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.onPrimaryContainer)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              expenses.isEmpty
                  ? const SliverFillRemaining(
                      child: EmptyState(
                        emoji: '💰',
                        title: 'No expenses yet',
                        subtitle: 'Track your seeds, soil, tools, and more.',
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) => _ExpenseTile(expense: expenses[i]),
                          childCount: expenses.length,
                        ),
                      ),
                    ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
  void _showAddExpenseSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => UncontrolledProviderScope(
        container: ProviderScope.containerOf(context),
        child: const _AddExpenseSheet(),
      ),
    );
  }
}
class _ExpenseTile extends ConsumerWidget {
  final Expense expense;
  const _ExpenseTile({required this.expense});
  static const _categoryEmoji = {
    'seeds': '🌱',
    'soil': '🪱',
    'tools': '🔧',
    'amendments': '🧪',
    'other': '📦',
  };
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final emoji = _categoryEmoji[expense.category] ?? '📦';
    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: cs.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: cs.onErrorContainer),
      ),
      onDismissed: (_) =>
          ref.read(databaseProvider).deleteExpense(expense.id),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cs.surfaceContainerHighest,
          child: Text(emoji, style: const TextStyle(fontSize: 18)),
        ),
        title: Text(expense.description,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
            '${expense.category[0].toUpperCase()}${expense.category.substring(1)}${expense.vendor != null ? ' • ${expense.vendor}' : ''}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatCurrency(expense.amount),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cs.primary)),
            Text(formatShortDate(expense.date),
                style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
class _AddExpenseSheet extends ConsumerStatefulWidget {
  const _AddExpenseSheet();
  @override
  ConsumerState<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}
class _AddExpenseSheetState extends ConsumerState<_AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _vendorCtrl = TextEditingController();
  String _category = 'seeds';
  bool _saving = false;
  @override
  void dispose() {
    _descCtrl.dispose();
    _amountCtrl.dispose();
    _vendorCtrl.dispose();
    super.dispose();
  }
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref.read(databaseProvider).insertExpense(
          ExpensesCompanion.insert(
            category: _category,
            description: _descCtrl.text.trim(),
            amount: double.parse(_amountCtrl.text),
            vendor: drift.Value(
                _vendorCtrl.text.trim().isEmpty ? null : _vendorCtrl.text.trim()),
          ),
        );
    if (mounted) Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Expense',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                  labelText: 'Category', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'seeds', child: Text('🌱 Seeds')),
                DropdownMenuItem(value: 'soil', child: Text('🪱 Soil / Mix')),
                DropdownMenuItem(value: 'tools', child: Text('🔧 Tools')),
                DropdownMenuItem(
                    value: 'amendments', child: Text('🧪 Amendments')),
                DropdownMenuItem(value: 'other', child: Text('📦 Other')),
              ],
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                  labelText: 'Description *', border: OutlineInputBorder()),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amountCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Amount * (\$)',
                        border: OutlineInputBorder(),
                        prefixText: '\$'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _vendorCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Vendor (optional)',
                        border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.check),
                label: const Text('Add Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
