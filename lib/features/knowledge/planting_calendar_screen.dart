// lib/features/knowledge/planting_calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/regional_calendars.dart';
import '../../core/providers/settings_provider.dart';

class PlantingCalendarScreen extends ConsumerStatefulWidget {
  const PlantingCalendarScreen({super.key});

  @override
  ConsumerState<PlantingCalendarScreen> createState() =>
      _PlantingCalendarScreenState();
}

class _PlantingCalendarScreenState
    extends ConsumerState<PlantingCalendarScreen> {
  int _selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final regionId =
        ref.watch(gardenRegionProvider).valueOrNull ?? 'tt';
    final region = regionById(regionId);
    final calendar = calendarForRegion(regionId);
    final data = calendar[_selectedMonth] ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('📅 Planting Calendar')),
      body: Column(
        children: [
          // ── Region banner ────────────────────────────────────────────
          Container(
            color: cs.primaryContainer.withValues(alpha: 0.35),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Text(region.emoji,
                    style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(region.label,
                          style: tt.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface)),
                      Text(region.description,
                          style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.swap_horiz, size: 16),
                  label: const Text('Change'),
                  onPressed: () =>
                      _showRegionPicker(context, ref, regionId),
                ),
              ],
            ),
          ),
          // ── Month selector ───────────────────────────────────────────
          Container(
            color: cs.surfaceContainerHighest,
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              itemCount: 12,
              itemBuilder: (_, i) {
                final m = i + 1;
                final isSelected = m == _selectedMonth;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMonth = m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? cs.primary : cs.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      regionMonthNames[i].substring(0, 3),
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? cs.onPrimary
                            : cs.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ── Month header ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Text(regionMonthNames[_selectedMonth - 1],
                    style: tt.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text('— ${region.shortLabel}',
                    style: tt.bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                if (data.containsKey('Notes'))
                  _NoteCard(data['Notes']!.first),
                if ((data['Start Indoors'] ?? []).isNotEmpty)
                  _CategorySection(
                    emoji: '🪴',
                    title: 'Start Indoors',
                    items: data['Start Indoors']!,
                    color: Colors.purple,
                  ),
                if ((data['Direct Sow'] ?? []).isNotEmpty)
                  _CategorySection(
                    emoji: '🌱',
                    title: 'Direct Sow Outdoors',
                    items: data['Direct Sow']!,
                    color: Colors.green,
                  ),
                if ((data['Transplant'] ?? []).isNotEmpty)
                  _CategorySection(
                    emoji: '🌿',
                    title: 'Transplant / Set Out',
                    items: data['Transplant']!,
                    color: Colors.teal,
                  ),
                if ((data['Start Indoors'] ?? []).isEmpty &&
                    (data['Direct Sow'] ?? []).isEmpty &&
                    (data['Transplant'] ?? []).isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'Rest & plan 🌙\nNo major planting this month.',
                        textAlign: TextAlign.center,
                        style: tt.bodyMedium
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ),
                  ),
                const SizedBox(height: 80),
              ],
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
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
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
                Text(
                    'Your region determines the planting calendar shown.',
                    style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: Theme.of(ctx)
                            .colorScheme
                            .onSurfaceVariant)),
                const SizedBox(height: 16),
                ...gardenRegions.map((r) => ListTile(
                      leading: Text(r.emoji,
                          style: const TextStyle(fontSize: 24)),
                      title: Text(r.label,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
                      subtitle: Text(r.description),
                      trailing: currentId == r.id
                          ? Icon(Icons.check_circle,
                              color: cs.primary)
                          : null,
                      onTap: () => Navigator.pop(ctx, r.id),
                    )),
              ],
            ),
          ),
        );
      },
    );
    if (selected != null && selected != currentId) {
      await ref.read(gardenRegionProvider.notifier).setRegion(selected);
    }
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _NoteCard extends StatelessWidget {
  final String note;
  const _NoteCard(this.note);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          const Text('📌', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(note,
                  style: TextStyle(color: Colors.amber.shade900))),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String emoji;
  final String title;
  final List<String> items;
  final Color color;
  const _CategorySection({
    required this.emoji,
    required this.title,
    required this.items,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map((plant) => ActionChip(
                    label: Text(plant),
                    backgroundColor:
                        color.withValues(alpha: 0.1),
                    side: BorderSide(
                        color: color.withValues(alpha: 0.3)),
                    labelStyle: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w500),
                    onPressed: () {},
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
