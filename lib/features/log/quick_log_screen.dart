// lib/features/log/quick_log_screen.dart
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/garden_providers.dart';
import '../../core/providers/database_provider.dart';
import '../../shared/widgets/photo_picker_widget.dart';
class QuickLogScreen extends ConsumerStatefulWidget {
  const QuickLogScreen({super.key});
  @override
  ConsumerState<QuickLogScreen> createState() => _QuickLogScreenState();
}
class _QuickLogScreenState extends ConsumerState<QuickLogScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Quick Log'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(icon: Icon(Icons.visibility_outlined), text: 'Observation'),
            Tab(icon: Icon(Icons.grass), text: 'Harvest'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _AddObservationForm(),
          _AddHarvestForm(),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────────────
// Observation Form (inline, for Quick Log tab)
// ─────────────────────────────────────────────────────
class _AddObservationForm extends ConsumerStatefulWidget {
  const _AddObservationForm();
  @override
  ConsumerState<_AddObservationForm> createState() =>
      _AddObservationFormState();
}
class _AddObservationFormState extends ConsumerState<_AddObservationForm> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _type = 'water';
  String? _photoPath;
  int? _plantId;
  bool _saving = false;
  @override
  void dispose() {
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_plantId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select a plant')));
      return;
    }
    setState(() => _saving = true);
    await ref.read(databaseProvider).insertObservation(
          ObservationsCompanion.insert(
            plantId: _plantId!,
            type: _type,
            description: _descCtrl.text.trim(),
            amount: drift.Value(double.tryParse(_amountCtrl.text)),
            photoPath: drift.Value(_photoPath),
          ),
        );
    if (mounted) {
      setState(() {
        _saving = false;
        _descCtrl.clear();
        _amountCtrl.clear();
        _photoPath = null;
        _plantId = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Observation logged ✓'),
            backgroundColor: Colors.green),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final plants = ref.watch(allPlantsProvider).valueOrNull ?? [];
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            initialValue: _plantId,
            decoration: const InputDecoration(
              labelText: 'Plant *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.eco_outlined),
            ),
            hint: const Text('Select a plant...'),
            items: plants
                .map((p) => DropdownMenuItem(
                      value: p.id,
                      child: Text('${p.commonName} — ${p.variety}'),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _plantId = v),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _type,
            decoration: const InputDecoration(
              labelText: 'Observation Type',
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
              hintText: 'What did you observe or do?',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Please add a description' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _amountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Amount (optional)',
                    hintText: 'e.g. 2',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
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
            label: const Text('Log Observation'),
          ),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────────────
// Harvest Form (inline, for Quick Log tab)
// ─────────────────────────────────────────────────────
class _AddHarvestForm extends ConsumerStatefulWidget {
  const _AddHarvestForm();
  @override
  ConsumerState<_AddHarvestForm> createState() => _AddHarvestFormState();
}
class _AddHarvestFormState extends ConsumerState<_AddHarvestForm> {
  final _formKey = GlobalKey<FormState>();
  final _qtyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _unit = 'lb';
  int _quality = 3;
  String? _photoPath;
  int? _plantId;
  bool _saving = false;
  @override
  void dispose() {
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_plantId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select a plant')));
      return;
    }
    setState(() => _saving = true);
    await ref.read(databaseProvider).insertHarvest(
          HarvestsCompanion.insert(
            plantId: _plantId!,
            quantity: double.parse(_qtyCtrl.text),
            unit: drift.Value(_unit),
            qualityRating: drift.Value(_quality),
            notes: drift.Value(
                _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
            photoPath: drift.Value(_photoPath),
          ),
        );
    if (mounted) {
      setState(() {
        _saving = false;
        _qtyCtrl.clear();
        _notesCtrl.clear();
        _photoPath = null;
        _plantId = null;
        _quality = 3;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Harvest logged ✓'),
            backgroundColor: Colors.green),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final plants = ref.watch(allPlantsProvider).valueOrNull ?? [];
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            initialValue: _plantId,
            decoration: const InputDecoration(
              labelText: 'Plant *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.eco_outlined),
            ),
            hint: const Text('Select a plant...'),
            items: plants
                .map((p) => DropdownMenuItem(
                      value: p.id,
                      child: Text('${p.commonName} — ${p.variety}'),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _plantId = v),
          ),
          const SizedBox(height: 16),
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
                    if (double.tryParse(v) == null) return 'Invalid number';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _unit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
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
          Text('Quality Rating',
              style: Theme.of(context).textTheme.labelLarge),
          Row(
            children: List.generate(
              5,
              (i) => IconButton(
                icon: Icon(
                  i < _quality ? Icons.star : Icons.star_border,
                  color: Colors.amber.shade700,
                ),
                onPressed: () => setState(() => _quality = i + 1),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _notesCtrl,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              border: OutlineInputBorder(),
            ),
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
            label: const Text('Log Harvest'),
          ),
        ],
      ),
    );
  }
}
