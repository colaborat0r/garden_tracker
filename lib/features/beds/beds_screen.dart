// lib/features/beds/beds_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/garden_providers.dart';
import '../../shared/widgets/empty_state.dart';
class BedsScreen extends ConsumerWidget {
  const BedsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bedsAsync = ref.watch(allBedsProvider);
    final allPlants = ref.watch(allPlantsProvider).valueOrNull ?? [];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('🌿 My Garden')),
          bedsAsync.when(
            data: (beds) => beds.isEmpty
                ? SliverFillRemaining(
                    child: EmptyState(
                      emoji: '🪴',
                      title: 'No beds yet',
                      subtitle:
                          'Add your first garden bed, raised bed, or container.',
                      actionLabel: 'Add Bed',
                      onAction: () => context.push('/garden/add-bed'),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final bed = beds[i];
                          final plantCount = allPlants
                              .where((p) => p.bedId == bed.id)
                              .length;
                          final activePlants = allPlants
                              .where((p) =>
                                  p.bedId == bed.id &&
                                  (p.status == 'planted' ||
                                      p.status == 'growing'))
                              .length;
                          return _BedCard(
                            bed: bed,
                            plantCount: plantCount,
                            activeCount: activePlants,
                            onTap: () =>
                                context.push('/garden/bed/${bed.id}'),
                          );
                        },
                        childCount: beds.length,
                      ),
                    ),
                  ),
            loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator())),
            error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $e'))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/garden/add-bed'),
        icon: const Icon(Icons.add),
        label: const Text('Add Bed'),
      ),
    );
  }
}
class _BedCard extends StatelessWidget {
  final Bed bed;
  final int plantCount;
  final int activeCount;
  final VoidCallback onTap;
  const _BedCard({
    required this.bed,
    required this.plantCount,
    required this.activeCount,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bed.photoPath != null && bed.photoPath!.isNotEmpty)
              Image.file(File(bed.photoPath!),
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover)
            else
              Container(
                height: 100,
                width: double.infinity,
                color: cs.surfaceContainerHighest,
                child: Center(
                  child: Text(
                    _bedEmoji(bed.type),
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bed.name,
                            style: tt.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _TypeChip(bed.type),
                            if (bed.areaSqFt != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '${bed.areaSqFt!.toStringAsFixed(0)} sq ft',
                                style: tt.bodySmall
                                    ?.copyWith(color: cs.onSurfaceVariant),
                              ),
                            ],
                          ],
                        ),
                        if (bed.soilType != null) ...[
                          const SizedBox(height: 4),
                          Text('Soil: ${bed.soilType}',
                              style: tt.bodySmall
                                  ?.copyWith(color: cs.onSurfaceVariant)),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _StatPill(
                          '$activeCount active',
                          cs.primary.withValues(alpha: 0.15),
                          cs.primary),
                      const SizedBox(height: 4),
                      _StatPill(
                          '$plantCount total',
                          cs.surfaceContainerHighest,
                          cs.onSurfaceVariant),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _bedEmoji(String type) {
    switch (type) {
      case 'raised':
        return '📦';
      case 'container':
        return '🪴';
      case 'ground':
        return '🌍';
      case 'hydro':
        return '💧';
      default:
        return '🌿';
    }
  }
}
class _TypeChip extends StatelessWidget {
  final String type;
  const _TypeChip(this.type);
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type[0].toUpperCase() + type.substring(1),
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: cs.onPrimaryContainer),
      ),
    );
  }
}
class _StatPill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _StatPill(this.label, this.bg, this.fg);
  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: fg)),
      );
}
