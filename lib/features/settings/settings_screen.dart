// lib/features/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/services/export_service.dart';
import '../../core/services/sample_data_service.dart';
import '../../core/data/regional_calendars.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final gardenName =
        ref.watch(gardenNameProvider).valueOrNull ?? 'My Garden';
    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Garden Info'),
          ListTile(
            leading: const Icon(Icons.yard_outlined),
            title: const Text('Garden Name'),
            subtitle: Text(gardenName),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () => _editGardenName(context, ref, gardenName),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Growing Region'),
            subtitle: Builder(builder: (_) {
              final id = ref.watch(gardenRegionProvider).valueOrNull ?? 'tt';
              final r = regionById(id);
              return Text('${r.emoji} ${r.label}');
            }),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              final regionId =
                  ref.read(gardenRegionProvider).valueOrNull ?? 'tt';
              _showRegionPicker(context, ref, regionId);
            },
          ),
          const Divider(),
          const _SectionHeader('Export'),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: const Text('Export Harvests (CSV)'),
            subtitle: const Text('Spreadsheet-ready harvest log'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _exportCsvHarvests(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Export Expenses (CSV)'),
            subtitle: const Text('Spreadsheet-ready expense log'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _exportCsvExpenses(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf_outlined),
            title: const Text('Export PDF Report'),
            subtitle: const Text('Shareable harvest & expense report'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _exportPdf(context, ref, gardenName),
          ),
          const Divider(),
          const _SectionHeader('Backup & Restore'),
          ListTile(
            leading: const Icon(Icons.data_object_outlined),
            title: const Text('Backup Data (JSON)'),
            subtitle: const Text('Full backup of all garden data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _exportJson(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.restore_outlined),
            title: const Text('Restore from Backup (JSON)'),
            subtitle: const Text('Import a previously exported JSON backup'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _importJson(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.science_outlined),
            title: const Text('Load Sample Data'),
            subtitle: const Text('Populate with example beds, plants, harvests & more'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _confirmLoadSampleData(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: cs.error),
            title: Text('Clear All Data', style: TextStyle(color: cs.error)),
            subtitle: const Text('Delete everything — cannot be undone'),
            onTap: () => _confirmClearData(context, ref),
          ),
          const Divider(),
          const _SectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.info_outlined),
            title: const Text('About Garden Tracker'),
            subtitle: const Text('App info, features & support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/more/settings/about'),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '🌱 Built with love for homesteaders everywhere',
              textAlign: TextAlign.center,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showRegionPicker(
      BuildContext context, WidgetRef ref, String currentId) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Growing Region',
                    style: Theme.of(ctx)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Your region determines the planting calendar.',
                    style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                ...gardenRegions.map((r) => ListTile(
                      leading: Text(r.emoji,
                          style: const TextStyle(fontSize: 24)),
                      title: Text(r.label,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(r.description),
                      trailing: currentId == r.id
                          ? Icon(Icons.check_circle, color: cs.primary)
                          : null,
                      onTap: () => Navigator.pop(ctx, r.id),
                    )),
              ],
            ),
          ),
        );
      },
    );
    if (selected != null && selected != currentId && context.mounted) {
      await ref.read(gardenRegionProvider.notifier).setRegion(selected);
    }
  }

  Future<void> _editGardenName(
      BuildContext context, WidgetRef ref, String current) async {
    final controller = TextEditingController(text: current);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Garden Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Backyard Homestead',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          onSubmitted: (v) => Navigator.of(ctx).pop(v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(controller.text),
              child: const Text('Save')),
        ],
      ),
    );
    controller.dispose();
    if (newName != null && context.mounted) {
      await ref.read(gardenNameProvider.notifier).setName(newName);
    }
  }

  Future<void> _exportCsvHarvests(BuildContext context, WidgetRef ref) async {
    try {
      final db = ref.read(databaseProvider);
      final harvests = await db.watchAllHarvests().first;
      final plants = await db.watchAllPlants().first;
      final beds = await db.watchAllBeds().first;
      await ExportService.exportHarvestsCsv(harvests, plants, beds);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _exportCsvExpenses(BuildContext context, WidgetRef ref) async {
    try {
      final expenses = await ref.read(databaseProvider).watchAllExpenses().first;
      await ExportService.exportExpensesCsv(expenses);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _exportJson(BuildContext context, WidgetRef ref) async {
    try {
      await ExportService.exportJson(ref.read(databaseProvider));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _importJson(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore from Backup?'),
        content: const Text(
            'This will ADD the backup data to your existing garden. '
            'Existing data will not be deleted.\n\n'
            'To start fresh, use "Clear All Data" first, then restore.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Choose File')),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    try {
      final summary =
          await ExportService.importJson(ref.read(databaseProvider));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('✅ $summary'),
          duration: const Duration(seconds: 5),
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Restore failed: $e')));
      }
    }
  }

  Future<void> _exportPdf(
      BuildContext context, WidgetRef ref, String gardenName) async {
    try {
      await ExportService.exportPdf(ref.read(databaseProvider), gardenName);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _confirmLoadSampleData(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Load Sample Data?'),
        content: const Text(
            'This will add example beds, plants, harvests, expenses, reminders, and journal entries to your garden. '
            'Existing data will not be deleted.\n\nGreat for exploring the app!'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Load Sample Data'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      try {
        await SampleDataService.loadSampleData(ref.read(databaseProvider));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Sample data loaded! Explore your garden.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to load sample data: $e')));
        }
      }
    }
  }

  Future<void> _confirmClearData(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
            'This will permanently delete all beds, plants, harvests, expenses, journal entries, and photos. This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      final db = ref.read(databaseProvider);
      for (final h in await db.watchAllHarvests().first) {
        await db.deleteHarvest(h.id);
      }
      for (final o in await db.watchRecentObservations(limit: 9999).first) {
        await db.deleteObservation(o.id);
      }
      for (final p in await db.watchAllPhotos().first) {
        await db.deletePlantPhoto(p.id);
      }
      for (final j in await db.watchAllJournalEntries().first) {
        await db.deleteJournalEntry(j.id);
      }
      for (final p in await db.watchAllPlants().first) {
        await db.deletePlant(p.id);
      }
      for (final b in await db.watchAllBeds().first) {
        await db.deleteBed(b.id);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('All data cleared.')));
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2),
        ),
      );
}
