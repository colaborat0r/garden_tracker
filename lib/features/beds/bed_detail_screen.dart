// lib/features/beds/bed_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/garden_providers.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/empty_state.dart';
class BedDetailScreen extends ConsumerWidget {
  final int bedId;
  const BedDetailScreen({super.key, required this.bedId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bedAsync = ref.watch(bedProvider(bedId));
    final plantsAsync = ref.watch(plantsByBedProvider(bedId));
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: bedAsync.when(
        data: (bed) {
          if (bed == null) {
            return const Center(child: Text('Bed not found'));
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar.large(
                title: Text(bed.name),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () =>
                        context.push('/garden/bed/$bedId/edit'),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _InfoChip(Icons.square_foot,
                          bed.areaSqFt != null
                              ? '${bed.areaSqFt!.toStringAsFixed(0)} sq ft'
                              : 'No size set'),
                      const SizedBox(width: 8),
                      _InfoChip(Icons.wb_sunny_outlined,
                          bed.location ?? 'No location'),
                    ],
                  ),
                ),
              ),
              if (bed.soilType != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.spa_outlined,
                            size: 16, color: cs.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text('Soil: ${bed.soilType}',
                            style: tt.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                sliver: SliverToBoxAdapter(
                  child: Text('Plants',
                      style:
                          tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              plantsAsync.when(
                data: (plants) => plants.isEmpty
                    ? SliverFillRemaining(
                        child: EmptyState(
                          emoji: '🌱',
                          title: 'No plants yet',
                          subtitle:
                              'Add your first plant to this bed to start tracking.',
                          actionLabel: 'Add Plant',
                          onAction: () =>
                              context.push('/garden/bed/$bedId/add-plant'),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, i) => _PlantTile(
                              plant: plants[i],
                              onTap: () => context.push(
                                  '/garden/bed/$bedId/plant/${plants[i].id}'),
                            ),
                            childCount: plants.length,
                          ),
                        ),
                      ),
                loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator())),
                error: (e, _) => SliverFillRemaining(
                    child: Center(child: Text('Error: $e'))),
              ),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/garden/bed/$bedId/add-plant'),
        icon: const Icon(Icons.add),
        label: const Text('Add Plant'),
      ),
    );
  }
}
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip(this.icon, this.label);
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(icon, size: 14, color: cs.onSurfaceVariant),
      label: Text(label),
      labelStyle: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: cs.onSurfaceVariant),
      visualDensity: VisualDensity.compact,
    );
  }
}
class _PlantTile extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;
  const _PlantTile({required this.plant, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final color = statusColor(context, plant.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: const Text('🌿', style: TextStyle(fontSize: 18)),
        ),
        title: Text(
          '${plant.commonName} — ${plant.variety}',
          style:
              const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plant.transplantDate != null)
              Text('Transplanted: ${formatDate(plant.transplantDate)}'),
            if (plant.expectedHarvestStart != null)
              Text(
                  'Expected harvest: ${formatDate(plant.expectedHarvestStart)}'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            plant.status[0].toUpperCase() + plant.status.substring(1),
            style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold),
          ),
        ),
        isThreeLine: plant.transplantDate != null &&
            plant.expectedHarvestStart != null,
      ),
    );
  }
}
