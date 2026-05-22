// lib/features/journal/add_edit_journal_screen.dart
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../shared/widgets/photo_picker_widget.dart';

class AddEditJournalScreen extends ConsumerStatefulWidget {
  final JournalEntry? entry;
  const AddEditJournalScreen({super.key, this.entry});

  @override
  ConsumerState<AddEditJournalScreen> createState() =>
      _AddEditJournalScreenState();
}

class _AddEditJournalScreenState
    extends ConsumerState<AddEditJournalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();
  String? _mood;
  String? _photoPath;
  bool _loading = false;

  static const _moods = [
    ('🌱', 'Growing'),
    ('😄', 'Happy'),
    ('🌧️', 'Rough Day'),
    ('🤔', 'Thinking'),
    ('✨', 'Great Harvest'),
    ('🐛', 'Pest Problems'),
    ('💪', 'Hard Work'),
    ('🎉', 'Celebrating'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      final e = widget.entry!;
      _titleCtrl.text = e.title;
      _bodyCtrl.text = e.body ?? '';
      _tagsCtrl.text = e.tags ?? '';
      _mood = e.mood;
      _photoPath = e.photoPath;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final db = ref.read(databaseProvider);
    try {
      if (widget.entry != null) {
        await db.updateJournalEntry(widget.entry!.copyWith(
          title: _titleCtrl.text.trim(),
          body: drift.Value(
              _bodyCtrl.text.trim().isEmpty ? null : _bodyCtrl.text.trim()),
          mood: drift.Value(_mood),
          tags: drift.Value(
              _tagsCtrl.text.trim().isEmpty ? null : _tagsCtrl.text.trim()),
          photoPath: drift.Value(_photoPath),
        ));
      } else {
        await db.insertJournalEntry(JournalEntriesCompanion.insert(
          title: _titleCtrl.text.trim(),
          body: drift.Value(
              _bodyCtrl.text.trim().isEmpty ? null : _bodyCtrl.text.trim()),
          mood: drift.Value(_mood),
          tags: drift.Value(
              _tagsCtrl.text.trim().isEmpty ? null : _tagsCtrl.text.trim()),
          photoPath: drift.Value(_photoPath),
        ));
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.entry != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Entry' : 'New Journal Entry'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Photo
            PhotoPickerWidget(
              photoPath: _photoPath,
              onChanged: (p) => setState(() => _photoPath = p),
            ),
            const SizedBox(height: 16),
            // Mood picker
            Text('Mood',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _moods.map((m) {
                final selected = _mood == m.$1;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _mood = selected ? null : m.$1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? Theme.of(context)
                              .colorScheme
                              .primaryContainer
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      border: selected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(m.$1,
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 4),
                        Text(m.$2,
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Title
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'e.g. First tomatoes of the season!',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            // Body
            TextFormField(
              controller: _bodyCtrl,
              decoration: const InputDecoration(
                labelText: 'Notes / Story',
                hintText:
                    'What happened? What did you learn? What will you do differently?',
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            // Tags
            TextFormField(
              controller: _tagsCtrl,
              decoration: const InputDecoration(
                labelText: 'Tags',
                hintText: 'e.g. tomato, harvest, lessons-learned',
                border: OutlineInputBorder(),
                helperText: 'Comma-separated tags',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(isEdit ? 'Save Changes' : 'Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}

