// lib/features/plants/plant_detail_screen.dart
import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/garden_providers.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/photo_service.dart';
import '../../core/utils/formatters.dart';
class PlantDetailScreen extends ConsumerWidget {
  final int plantId;
  final int bedId;
  const PlantDetailScreen({super.key, required this.plantId, required this.bedId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantAsync = ref.watch(plantProvider(plantId));
    final obsAsync = ref.watch(observationsByPlantProvider(plantId));
    final harvestsAsync = ref.watch(harvestsByPlantProvider(plantId));
    final photosAsync = ref.watch(photosByPlantProvider(plantId));
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return plantAsync.when(
      data: (plant) {
        if (plant == null) return const Scaffold(body: Center(child: Text('Not found')));
        final statusClr = statusColor(context, plant.status);
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                title: Text('${plant.commonName}\n${plant.variety}',
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () =>
                        context.push('/garden/bed/$bedId/plant/$plantId/edit'),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (plant.photoPath != null && plant.photoPath!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(File(plant.photoPath!),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover),
                        ),
                      const SizedBox(height: 12),
                      // Status + Growth Stage badges
                      Wrap(
                        spacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusClr.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              plant.status[0].toUpperCase() +
                                  plant.status.substring(1),
                              style: tt.labelMedium?.copyWith(
                                  color: statusClr,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (plant.growthStage != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: cs.tertiaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _stageLabel(plant.growthStage!),
                                style: tt.labelMedium?.copyWith(
                                    color: cs.onTertiaryContainer,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                      if (plant.quantity != null || plant.source != null) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          children: [
                            if (plant.quantity != null)
                              Text('${plant.quantity} plants',
                                  style: TextStyle(color: cs.onSurfaceVariant)),
                            if (plant.source != null)
                              Text('Source: ${plant.source}',
                                  style: TextStyle(color: cs.onSurfaceVariant)),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      // Growth stage progress bar
                      if (plant.growthStage != null) ...[
                        Text('Growth Progress',
                            style: tt.labelMedium
                                ?.copyWith(color: cs.onSurfaceVariant)),
                        const SizedBox(height: 6),
                        _GrowthStageBar(stage: plant.growthStage!),
                        const SizedBox(height: 16),
                      ],
                      // Lifecycle timeline
                      Text('Lifecycle',
                          style: tt.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _TimelineRow(
                        items: [
                          _TimelineItem('🌱', 'Seed Start',
                              formatDate(plant.seedStartDate)),
                          _TimelineItem('🌿', 'Transplant',
                              formatDate(plant.transplantDate)),
                          _TimelineItem('🥬', 'Harvest',
                              formatDate(plant.expectedHarvestStart)),
                        ],
                      ),
                      if (plant.notes != null) ...[
                        const SizedBox(height: 12),
                        Text('Notes',
                            style: tt.labelLarge
                                ?.copyWith(color: cs.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Text(plant.notes!),
                      ],
                      const SizedBox(height: 20),
                      // Quick actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.push(
                                  '/garden/bed/$bedId/plant/$plantId/add-observation'),
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('Log Obs.'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => context.push(
                                  '/garden/bed/$bedId/plant/$plantId/add-harvest'),
                              icon: const Icon(Icons.grass),
                              label: const Text('Log Harvest'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Photo gallery section
                      photosAsync.when(
                        data: (photos) => _PhotoGallerySection(
                          plantId: plantId,
                          photos: photos,
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (e, _) => const SizedBox.shrink(),
                      ),
                      const Divider(height: 32),
                      Text('Observations',
                          style: tt.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              obsAsync.when(
                data: (obs) => obs.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('No observations yet.',
                              style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => _ObsTile(obs: obs[i]),
                          childCount: obs.length,
                        ),
                      ),
                loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator())),
                error: (e, _) =>
                    SliverToBoxAdapter(child: Text('Error: $e')),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text('Harvests',
                      style: tt.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              harvestsAsync.when(
                data: (harvests) => harvests.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Padding(
                         padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('No harvests yet.',
                              style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => _HarvestTile(harvest: harvests[i]),
                          childCount: harvests.length,
                        ),
                      ),
                loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator())),
                error: (e, _) =>
                    SliverToBoxAdapter(child: Text('Error: $e')),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  String _stageLabel(String stage) {
    const labels = {
      'seedling': '🌱 Seedling',
      'vegetative': '🌿 Vegetative',
      'flowering': '🌸 Flowering',
      'fruiting': '🍅 Fruiting',
      'harvest_ready': '✅ Harvest Ready',
    };
    return labels[stage] ?? stage;
  }
}

class _TimelineItem {
  final String emoji;
  final String label;
  final String date;
  const _TimelineItem(this.emoji, this.label, this.date);
}

// ── Growth Stage Progress Bar ─────────────────────────────────────────────────

class _GrowthStageBar extends StatelessWidget {
  final String stage;
  const _GrowthStageBar({required this.stage});

  static const _stages = [
    'seedling', 'vegetative', 'flowering', 'fruiting', 'harvest_ready'
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final idx = _stages.indexOf(stage);
    final progress = idx < 0 ? 0.0 : (idx + 1) / _stages.length;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: cs.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
          ),
        ),
        const SizedBox(height: 4),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('🌱', style: TextStyle(fontSize: 14)),
            Text('🌿', style: TextStyle(fontSize: 14)),
            Text('🌸', style: TextStyle(fontSize: 14)),
            Text('🍅', style: TextStyle(fontSize: 14)),
            Text('✅', style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}

// ── Photo Gallery Section ─────────────────────────────────────────────────────

class _PhotoGallerySection extends ConsumerWidget {
  final int plantId;
  final List<PlantPhoto> photos;
  const _PhotoGallerySection(
      {required this.plantId, required this.photos});

  Future<void> _addPhoto(BuildContext context, WidgetRef ref) async {
    final choice = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (choice == null) return;
    String? caption;
    if (context.mounted) {
      final ctrl = TextEditingController();
      caption = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Add Caption (optional)'),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(
              hintText: 'e.g. First tomatoes forming',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Skip')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
                child: const Text('Save')),
          ],
        ),
      );
      ctrl.dispose();
    }
    try {
      final path = await PhotoService.pickAndSave(source: choice);
      if (path != null && context.mounted) {
        await ref.read(databaseProvider).insertPlantPhoto(
              PlantPhotosCompanion.insert(
                plantId: plantId,
                photoPath: path,
                caption: drift.Value(
                    caption != null && caption.isNotEmpty ? caption : null),
              ),
            );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Photo Gallery (${photos.length})',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            TextButton.icon(
              icon: const Icon(Icons.add_a_photo_outlined, size: 16),
              label: const Text('Add'),
              onPressed: () => _addPhoto(context, ref),
            ),
          ],
        ),
        if (photos.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (_, i) {
                final photo = photos[i];
                return GestureDetector(
                  onLongPress: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Photo?'),
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
                    if (ok == true) {
                      ref.read(databaseProvider).deletePlantPhoto(photo.id);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(photo.photoPath),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final List<_TimelineItem> items;
  const _TimelineRow({required this.items});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: items.asMap().entries.map((e) {
        final isLast = e.key == items.length - 1;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: cs.primaryContainer,
                      child: Text(e.value.emoji),
                    ),
                    const SizedBox(height: 4),
                    Text(e.value.label,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                        textAlign: TextAlign.center),
                    Text(e.value.date,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 10),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                    height: 2, width: 20, color: cs.outlineVariant),
            ],
          ),
        );
      }).toList(),
    );
  }
}
class _ObsTile extends ConsumerWidget {
  final Observation obs;
  const _ObsTile({required this.obs});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(obs.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: cs.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: cs.onErrorContainer),
      ),
      onDismissed: (_) =>
          ref.read(databaseProvider).deleteObservation(obs.id),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cs.surfaceContainerHighest,
          child: Text(obsTypeEmoji(obs.type),
              style: const TextStyle(fontSize: 18)),
        ),
        title: Text(obsTypeLabel(obs.type),
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(obs.description, maxLines: 2),
        trailing: Text(formatShortDate(obs.date),
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
      ),
    );
  }
}
class _HarvestTile extends ConsumerWidget {
  final Harvest harvest;
  const _HarvestTile({required this.harvest});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(harvest.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: cs.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: cs.onErrorContainer),
      ),
      onDismissed: (_) =>
          ref.read(databaseProvider).deleteHarvest(harvest.id),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber.shade700.withValues(alpha: 0.15),
          child: const Text('🥬', style: TextStyle(fontSize: 18)),
        ),
        title: Text(
          '${harvest.quantity.toStringAsFixed(2)} ${harvest.unit}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: harvest.notes != null ? Text(harvest.notes!) : null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatShortDate(harvest.date),
                style:
                    TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
            if (harvest.qualityRating != null)
              Text('⭐' * harvest.qualityRating!,
                  style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

