// lib/features/beds/add_edit_bed_screen.dart
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../shared/widgets/photo_picker_widget.dart';
class AddEditBedScreen extends ConsumerStatefulWidget {
  final int? bedId;
  const AddEditBedScreen({super.key, this.bedId});
  @override
  ConsumerState<AddEditBedScreen> createState() => _AddEditBedScreenState();
}
class _AddEditBedScreenState extends ConsumerState<AddEditBedScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _soilCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _type = 'raised';
  String? _photoPath;
  bool _loading = false;
  Bed? _existing;
  @override
  void initState() {
    super.initState();
    if (widget.bedId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadBed());
    }
  }
  Future<void> _loadBed() async {
    final bed = await ref.read(databaseProvider).getBed(widget.bedId!);
    if (bed != null && mounted) {
      setState(() {
        _existing = bed;
        _nameCtrl.text = bed.name;
        _type = bed.type;
        _areaCtrl.text = bed.areaSqFt?.toString() ?? '';
        _locationCtrl.text = bed.location ?? '';
        _soilCtrl.text = bed.soilType ?? '';
        _notesCtrl.text = bed.notes ?? '';
        _photoPath = bed.photoPath;
      });
    }
  }
  @override
  void dispose() {
    _nameCtrl.dispose();
    _areaCtrl.dispose();
    _locationCtrl.dispose();
    _soilCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final db = ref.read(databaseProvider);
    final area = double.tryParse(_areaCtrl.text);
    if (_existing != null) {
      await db.updateBed(_existing!.copyWith(
        name: _nameCtrl.text.trim(),
        type: _type,
        areaSqFt: drift.Value(area),
        location: drift.Value(
            _locationCtrl.text.trim().isEmpty ? null : _locationCtrl.text.trim()),
        soilType: drift.Value(
            _soilCtrl.text.trim().isEmpty ? null : _soilCtrl.text.trim()),
        notes:
            drift.Value(_notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
        photoPath: drift.Value(_photoPath),
      ));
    } else {
      // gardenId=1 (default garden)
      await db.insertBed(BedsCompanion.insert(
        gardenId: 1,
        name: _nameCtrl.text.trim(),
        type: drift.Value(_type),
        areaSqFt: drift.Value(area),
        location: drift.Value(
            _locationCtrl.text.trim().isEmpty ? null : _locationCtrl.text.trim()),
        soilType: drift.Value(
            _soilCtrl.text.trim().isEmpty ? null : _soilCtrl.text.trim()),
        notes: drift.Value(
            _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
        photoPath: drift.Value(_photoPath),
      ));
    }
    if (mounted) Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.bedId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Bed' : 'Add New Bed'),
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
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Bed Name *',
                hintText: 'e.g. Raised Bed 1, Tomato Pot',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Bed Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'raised', child: Text('Raised Bed')),
                DropdownMenuItem(value: 'container', child: Text('Container / Pot')),
                DropdownMenuItem(value: 'ground', child: Text('Ground / In-Ground')),
                DropdownMenuItem(value: 'hydro', child: Text('Hydroponic')),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _areaCtrl,
              decoration: const InputDecoration(
                labelText: 'Area (sq ft)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationCtrl,
              decoration: const InputDecoration(
                labelText: 'Location / Sun Exposure',
                hintText: 'e.g. Full Sun, Back Yard',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _soilCtrl,
              decoration: const InputDecoration(
                labelText: 'Soil Type / Mix',
                hintText: 'e.g. Mel\'s Mix, Compost + Perlite',
                border: OutlineInputBorder(),
              ),
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
                  : Text(isEdit ? 'Save Changes' : 'Add Bed'),
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
        title: const Text('Delete Bed?'),
        content: const Text(
            'This will delete the bed and all its plant records. This cannot be undone.'),
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
      await ref.read(databaseProvider).deleteBed(widget.bedId!);
      if (mounted) Navigator.pop(context);
    }
  }
}
