// lib/features/log/add_observation_screen.dart
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../shared/widgets/photo_picker_widget.dart';
class AddObservationScreen extends ConsumerStatefulWidget {
  final int plantId;
  const AddObservationScreen({super.key, required this.plantId});
  @override
  ConsumerState<AddObservationScreen> createState() =>
      _AddObservationScreenState();
}
class _AddObservationScreenState extends ConsumerState<AddObservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _type = 'water';
  String? _photoPath;
  bool _saving = false;
  @override
  void dispose() {
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref.read(databaseProvider).insertObservation(
          ObservationsCompanion.insert(
            plantId: widget.plantId,
            type: _type,
            description: _descCtrl.text.trim(),
            amount: drift.Value(double.tryParse(_amountCtrl.text)),
            photoPath: drift.Value(_photoPath),
          ),
        );
    if (mounted) Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Observation')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'water', child: Text('💧 Watered')),
                DropdownMenuItem(value: 'fertilize', child: Text('🌱 Fertilized')),
                DropdownMenuItem(value: 'pest', child: Text('🐛 Pest Check')),
                DropdownMenuItem(value: 'prune', child: Text('✂️ Pruned')),
                DropdownMenuItem(value: 'note', child: Text('📝 Note')),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'Description *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountCtrl,
              decoration: const InputDecoration(
                labelText: 'Amount (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            PhotoPickerWidget(
              photoPath: _photoPath,
              onChanged: (p) => setState(() => _photoPath = p),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.check),
              label: const Text('Save Observation'),
            ),
          ],
        ),
      ),
    );
  }
}
