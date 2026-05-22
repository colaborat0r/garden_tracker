// lib/features/log/add_harvest_screen.dart
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../shared/widgets/photo_picker_widget.dart';
class AddHarvestScreen extends ConsumerStatefulWidget {
  final int plantId;
  const AddHarvestScreen({super.key, required this.plantId});
  @override
  ConsumerState<AddHarvestScreen> createState() => _AddHarvestScreenState();
}
class _AddHarvestScreenState extends ConsumerState<AddHarvestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _qtyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _unit = 'lb';
  int _quality = 3;
  String? _photoPath;
  bool _saving = false;
  @override
  void dispose() {
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref.read(databaseProvider).insertHarvest(
          HarvestsCompanion.insert(
            plantId: widget.plantId,
            quantity: double.parse(_qtyCtrl.text),
            unit: drift.Value(_unit),
            qualityRating: drift.Value(_quality),
            notes: drift.Value(
                _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
            photoPath: drift.Value(_photoPath),
          ),
        );
    if (mounted) Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Harvest')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _qtyCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Quantity *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _unit,
                    decoration: const InputDecoration(
                        labelText: 'Unit', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'lb', child: Text('lb')),
                      DropdownMenuItem(value: 'kg', child: Text('kg')),
                      DropdownMenuItem(value: 'oz', child: Text('oz')),
                      DropdownMenuItem(value: 'each', child: Text('each')),
                      DropdownMenuItem(value: 'bunch', child: Text('bunch')),
                    ],
                    onChanged: (v) => setState(() => _unit = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Quality', style: Theme.of(context).textTheme.labelLarge),
            Row(
              children: List.generate(
                5,
                (i) => IconButton(
                  icon: Icon(i < _quality ? Icons.star : Icons.star_border,
                      color: Colors.amber.shade700),
                  onPressed: () => setState(() => _quality = i + 1),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                  labelText: 'Notes', border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            PhotoPickerWidget(
              photoPath: _photoPath,
              onChanged: (p) => setState(() => _photoPath = p),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.grass),
              label: const Text('Save Harvest'),
            ),
          ],
        ),
      ),
    );
  }
}
