// lib/features/reminders/reminders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/garden_providers.dart';
import '../../core/providers/database_provider.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/empty_state.dart';
class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(allRemindersProvider);
    return Scaffold(
      body: remindersAsync.when(
        data: (reminders) => CustomScrollView(
          slivers: [
            const SliverAppBar.large(title: Text('🔔 Reminders')),
            reminders.isEmpty
                ? const SliverFillRemaining(
                    child: EmptyState(
                      emoji: '🔔',
                      title: 'No reminders',
                      subtitle: 'Add reminders for watering, fertilizing, and more.',
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => _ReminderTile(reminder: reminders[i]),
                        childCount: reminders.length,
                      ),
                    ),
                  ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReminderSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Reminder'),
      ),
    );
  }
  void _showAddReminderSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => UncontrolledProviderScope(
        container: ProviderScope.containerOf(context),
        child: const _AddReminderSheet(),
      ),
    );
  }
}
class _ReminderTile extends ConsumerWidget {
  final Reminder reminder;
  const _ReminderTile({required this.reminder});
  static const _typeEmoji = {
    'water': '💧',
    'fertilize': '🌱',
    'harvest': '🥬',
    'pest_check': '🐛',
    'custom': '📝',
  };
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final db = ref.read(databaseProvider);
    final emoji = _typeEmoji[reminder.type] ?? '📝';
    final isOverdue = reminder.dueDate.isBefore(DateTime.now()) &&
        !reminder.isCompleted;
    return Dismissible(
      key: ValueKey(reminder.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: cs.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: cs.onErrorContainer),
      ),
      onDismissed: (_) => db.deleteReminder(reminder.id),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOverdue
              ? cs.errorContainer
              : cs.surfaceContainerHighest,
          child: Text(emoji, style: const TextStyle(fontSize: 18)),
        ),
        title: Text(
          reminder.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: reminder.isCompleted
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Text(
          reminder.isCompleted
              ? 'Completed'
              : isOverdue
                  ? 'Overdue! Due: ${formatDate(reminder.dueDate)}'
                  : 'Due: ${formatDate(reminder.dueDate)}',
          style: TextStyle(
              color: isOverdue && !reminder.isCompleted
                  ? cs.error
                  : cs.onSurfaceVariant),
        ),
        trailing: Checkbox(
          value: reminder.isCompleted,
          onChanged: (v) => db.updateReminder(
            reminder.copyWith(isCompleted: v ?? false),
          ),
        ),
      ),
    );
  }
}
class _AddReminderSheet extends ConsumerStatefulWidget {
  const _AddReminderSheet();
  @override
  ConsumerState<_AddReminderSheet> createState() => _AddReminderSheetState();
}
class _AddReminderSheetState extends ConsumerState<_AddReminderSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  String _type = 'water';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _saving = false;
  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref.read(databaseProvider).insertReminder(
          RemindersCompanion.insert(
            type: _type,
            title: _titleCtrl.text.trim(),
            dueDate: _dueDate,
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
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Reminder',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(
                  labelText: 'Type', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'water', child: Text('💧 Water')),
                DropdownMenuItem(value: 'fertilize', child: Text('🌱 Fertilize')),
                DropdownMenuItem(value: 'harvest', child: Text('🥬 Harvest')),
                DropdownMenuItem(
                    value: 'pest_check', child: Text('🐛 Pest Check')),
                DropdownMenuItem(value: 'custom', child: Text('📝 Custom')),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                  labelText: 'Title *', border: OutlineInputBorder()),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Due Date'),
              subtitle: Text(formatDate(_dueDate)),
              trailing: TextButton(
                onPressed: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (d != null) setState(() => _dueDate = d);
                },
                child: const Text('Change'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.check),
                label: const Text('Add Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
