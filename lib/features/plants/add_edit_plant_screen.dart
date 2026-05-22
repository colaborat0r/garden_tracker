// lib/features/plants/add_edit_plant_screen.dart
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/plant_database.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../shared/widgets/photo_picker_widget.dart';

class AddEditPlantScreen extends ConsumerStatefulWidget {
  final int bedId;
  final int? plantId;
  const AddEditPlantScreen({super.key, required this.bedId, this.plantId});
  @override
  ConsumerState<AddEditPlantScreen> createState() => _AddEditPlantScreenState();
}

class _AddEditPlantScreenState extends ConsumerState<AddEditPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commonNameCtrl = TextEditingController();
  final _varietyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _status = 'planted';
  String? _growthStage;
  String? _source;
  int? _quantity;
  DateTime? _seedStart;
  DateTime? _transplantDate;
  DateTime? _expectedHarvest;
  String? _photoPath;
  bool _loading = false;
  Plant? _existing;

  static const _growthStages = [
    ('seedling', '🌱 Seedling'),
    ('vegetative', '🌿 Vegetative'),
    ('flowering', '🌸 Flowering'),
    ('fruiting', '🍅 Fruiting'),
    ('harvest_ready', '✅ Harvest Ready'),
  ];

  static const _sources = [
    ('seed', '🌱 Seed'),
    ('transplant', '🌿 Transplant'),
    ('nursery', '🏪 Nursery'),
    ('cutting', '✂️ Cutting'),
    ('gift', '🎁 Gift'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.plantId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadPlant());
    }
  }

  Future<void> _loadPlant() async {
    final p = await ref.read(databaseProvider).getPlant(widget.plantId!);
    if (p != null && mounted) {
      setState(() {
        _existing = p;
        _commonNameCtrl.text = p.commonName;
        _varietyCtrl.text = p.variety;
        _notesCtrl.text = p.notes ?? '';
        _status = p.status;
        _growthStage = p.growthStage;
        _source = p.source;
        _quantity = p.quantity;
        _seedStart = p.seedStartDate;
        _transplantDate = p.transplantDate;
        _expectedHarvest = p.expectedHarvestStart;
        _photoPath = p.photoPath;
      });
    }
  }

  @override
  void dispose() {
    _commonNameCtrl.dispose();
    _varietyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context,
      {required String label,
      required DateTime? current,
      required ValueChanged<DateTime?> onPicked}) async {
    final d = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: label,
    );
    if (d != null) onPicked(d);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final db = ref.read(databaseProvider);
    if (_existing != null) {
      await db.updatePlant(_existing!.copyWith(
        commonName: _commonNameCtrl.text.trim(),
        variety: _varietyCtrl.text.trim(),
        status: _status,
        growthStage: drift.Value(_growthStage),
        source: drift.Value(_source),
        quantity: drift.Value(_quantity),
        seedStartDate: drift.Value(_seedStart),
        transplantDate: drift.Value(_transplantDate),
        expectedHarvestStart: drift.Value(_expectedHarvest),
        notes: drift.Value(
            _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
        photoPath: drift.Value(_photoPath),
      ));
    } else {
      await db.insertPlant(PlantsCompanion.insert(
        bedId: widget.bedId,
        commonName: _commonNameCtrl.text.trim(),
        variety: _varietyCtrl.text.trim(),
        status: drift.Value(_status),
        growthStage: drift.Value(_growthStage),
        source: drift.Value(_source),
        quantity: drift.Value(_quantity),
        seedStartDate: drift.Value(_seedStart),
        transplantDate: drift.Value(_transplantDate),
        expectedHarvestStart: drift.Value(_expectedHarvest),
        notes: drift.Value(
            _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
        photoPath: drift.Value(_photoPath),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  void _showPlantPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _PlantPickerSheet(
        onSelected: (plant) {
          setState(() {
            _commonNameCtrl.text = plant.commonName;
            if (_varietyCtrl.text.isEmpty &&
                plant.commonVarieties.isNotEmpty) {
              _varietyCtrl.text = plant.commonVarieties.first;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.plantId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Plant' : 'Add Plant'),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PhotoPickerWidget(
              photoPath: _photoPath,
              onChanged: (p) => setState(() => _photoPath = p),
            ),
            const SizedBox(height: 16),
            // Pick from database button
            if (!isEdit)
              OutlinedButton.icon(
                onPressed: _showPlantPicker,
                icon: const Icon(Icons.local_florist_outlined),
                label: const Text('Pick from Plant Database'),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _commonNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Common Name *',
                hintText: 'e.g. Tomato, Pepper, Basil',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _varietyCtrl,
              decoration: const InputDecoration(
                labelText: 'Variety *',
                hintText: 'e.g. Roma, Florida 91, Genovese',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            // Quantity
            TextFormField(
              initialValue: _quantity?.toString(),
              decoration: const InputDecoration(
                labelText: 'Quantity (# of plants)',
                hintText: 'e.g. 4',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.format_list_numbered),
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) => _quantity = int.tryParse(v),
            ),
            const SizedBox(height: 16),
            // Source
            DropdownButtonFormField<String>(
              initialValue: _source,
              decoration: const InputDecoration(
                labelText: 'Source',
                border: OutlineInputBorder(),
              ),
              items: _sources
                  .map((s) => DropdownMenuItem(
                      value: s.$1, child: Text(s.$2)))
                  .toList(),
              onChanged: (v) => setState(() => _source = v),
            ),
            const SizedBox(height: 16),
            // Status
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'planted', child: Text('🌱 Planted')),
                DropdownMenuItem(value: 'growing', child: Text('🌿 Growing')),
                DropdownMenuItem(
                    value: 'harvested', child: Text('🥬 Harvested')),
                DropdownMenuItem(value: 'failed', child: Text('💀 Failed')),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 16),
            // Growth Stage
            DropdownButtonFormField<String>(
              initialValue: _growthStage,
              decoration: const InputDecoration(
                labelText: 'Growth Stage',
                border: OutlineInputBorder(),
                helperText: 'Current stage of development',
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Not set')),
                ..._growthStages.map((s) => DropdownMenuItem(
                    value: s.$1, child: Text(s.$2))),
              ],
              onChanged: (v) => setState(() => _growthStage = v),
            ),
            const SizedBox(height: 20),
            Text('Key Dates',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _DateTile(
              label: 'Seed Start Date',
              date: _seedStart,
              icon: Icons.eco_outlined,
              onTap: () => _pickDate(context,
                  label: 'Seed Start Date',
                  current: _seedStart,
                  onPicked: (d) => setState(() => _seedStart = d)),
              onClear: () => setState(() => _seedStart = null),
            ),
            _DateTile(
              label: 'Transplant Date',
              date: _transplantDate,
              icon: Icons.move_up_outlined,
              onTap: () => _pickDate(context,
                  label: 'Transplant Date',
                  current: _transplantDate,
                  onPicked: (d) => setState(() => _transplantDate = d)),
              onClear: () => setState(() => _transplantDate = null),
            ),
            _DateTile(
              label: 'Expected Harvest Start',
              date: _expectedHarvest,
              icon: Icons.calendar_month_outlined,
              onTap: () => _pickDate(context,
                  label: 'Expected Harvest',
                  current: _expectedHarvest,
                  onPicked: (d) => setState(() => _expectedHarvest = d)),
              onClear: () => setState(() => _expectedHarvest = null),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
                  : Text(isEdit ? 'Save Changes' : 'Add Plant'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Plant?'),
        content: const Text('All observations and harvests will be deleted.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await ref.read(databaseProvider).deletePlant(widget.plantId!);
      if (mounted) Navigator.pop(context);
    }
  }
}

// ── Plant Picker Bottom Sheet ────────────────────────────────────────────────

class _PlantPickerSheet extends StatefulWidget {
  final ValueChanged<PlantInfo> onSelected;
  const _PlantPickerSheet({required this.onSelected});

  @override
  State<_PlantPickerSheet> createState() => _PlantPickerSheetState();
}

class _PlantPickerSheetState extends State<_PlantPickerSheet> {
  String _search = '';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final plants = _search.isNotEmpty
        ? searchPlants(_search)
        : (_filter == 'all' ? masterPlantDatabase : getPlantsByCategory(_filter));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (_, ctrl) => Column(
        children: [
          const SizedBox(height: 8),
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              )),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Pick from Plant Database',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search…',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final cat in [
                        ('all', 'All'),
                        ('vegetable', '🥕 Veg'),
                        ('herb', '🌿 Herbs'),
                        ('fruit', '🍓 Fruit'),
                      ])
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat.$2),
                            selected: _filter == cat.$1,
                            onSelected: (_) =>
                                setState(() => _filter = cat.$1),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: ctrl,
              itemCount: plants.length,
              itemBuilder: (_, i) {
                final p = plants[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: cs.surfaceContainerHighest,
                    child: Text(p.emoji,
                        style: const TextStyle(fontSize: 20)),
                  ),
                  title: Text(p.commonName,
                      style:
                          const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    p.commonVarieties.take(3).join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    p.category,
                    style: TextStyle(
                        fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onSelected(p);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Date Tile ────────────────────────────────────────────────────────────────

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onClear;
  const _DateTile(
      {required this.label,
      required this.date,
      required this.icon,
      required this.onTap,
      required this.onClear});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasDate = date != null;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading:
          Icon(icon, color: hasDate ? cs.primary : cs.onSurfaceVariant),
      title: Text(label),
      subtitle: Text(
        hasDate
            ? '${date!.year}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}'
            : 'Not set',
        style: TextStyle(
            color: hasDate ? cs.primary : cs.onSurfaceVariant),
      ),
      trailing: hasDate
          ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
          : TextButton(onPressed: onTap, child: const Text('Set')),
      onTap: onTap,
    );
  }
}
