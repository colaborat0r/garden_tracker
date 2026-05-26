// lib/features/plants/plants_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/garden_providers.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/empty_state.dart';

class PlantsScreen extends ConsumerStatefulWidget {
  const PlantsScreen({super.key});

  @override
  ConsumerState<PlantsScreen> createState() => _PlantsScreenState();
}

class _PlantsScreenState extends ConsumerState<PlantsScreen> {
  String _searchQuery = '';
  String _statusFilter = 'all'; // all, planted, growing, harvested, failed

  @override
  Widget build(BuildContext context) {
    final plantsAsync = ref.watch(allPlantsProvider);
    final allBeds = ref.watch(allBedsProvider).valueOrNull ?? [];
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('🌿 All Plants'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterSheet(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search plants...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
          ),
          plantsAsync.when(
            data: (plants) {
              if (plants.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    emoji: '🌱',
                    title: 'No plants yet',
                    subtitle: 'Add a bed first, then start planting!',
                    actionLabel: 'Add Bed',
                    onAction: () => context.push('/garden/add-bed'),
                  ),
                );
              }

              // Filter
              var filtered = plants.where((p) {
                if (_statusFilter != 'all' && p.status != _statusFilter) {
                  return false;
                }
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  return p.commonName.toLowerCase().contains(query) ||
                      p.variety.toLowerCase().contains(query);
                }
                return true;
              }).toList();

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No plants match your filters',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ),
                );
              }

              // Group by status
              final grouped = <String, List<Plant>>{
                'planted': [],
                'growing': [],
                'harvested': [],
                'failed': [],
              };
              for (final p in filtered) {
                grouped[p.status]?.add(p);
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Stats summary
                    _buildStatsRow(context, plants),
                    const SizedBox(height: 24),
                    // Plant groups
                    ...grouped.entries
                        .where((e) => e.value.isNotEmpty)
                        .map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Text(
                                  _statusEmoji(entry.key),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${entry.key[0].toUpperCase()}${entry.key.substring(1)} (${entry.value.length})',
                                  style: tt.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...entry.value.map((plant) {
                            final bed = allBeds.firstWhereOrNull(
                              (b) => b.id == plant.bedId,
                            );
                            return _PlantCard(plant: plant, bed: bed);
                          }),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                  ]),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/garden'),
        icon: const Icon(Icons.add),
        label: const Text('Add Plant'),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, List<Plant> plants) {
    final cs = Theme.of(context).colorScheme;
    final stats = {
      'Planted': plants.where((p) => p.status == 'planted').length,
      'Growing': plants.where((p) => p.status == 'growing').length,
      'Harvested': plants.where((p) => p.status == 'harvested').length,
      'Failed': plants.where((p) => p.status == 'failed').length,
    };

    return Row(
      children: stats.entries.map((e) {
        final color = _statusColor(context, e.key.toLowerCase());
        return Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    '${e.value}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                  Text(
                    e.key,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Status',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: _statusFilter == 'all',
                      onSelected: (v) {
                        if (v) setState(() => _statusFilter = 'all');
                        Navigator.pop(ctx);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Planted'),
                      selected: _statusFilter == 'planted',
                      onSelected: (v) {
                        if (v) setState(() => _statusFilter = 'planted');
                        Navigator.pop(ctx);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Growing'),
                      selected: _statusFilter == 'growing',
                      onSelected: (v) {
                        if (v) setState(() => _statusFilter = 'growing');
                        Navigator.pop(ctx);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Harvested'),
                      selected: _statusFilter == 'harvested',
                      onSelected: (v) {
                        if (v) setState(() => _statusFilter = 'harvested');
                        Navigator.pop(ctx);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Failed'),
                      selected: _statusFilter == 'failed',
                      onSelected: (v) {
                        if (v) setState(() => _statusFilter = 'failed');
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  String _statusEmoji(String status) {
    switch (status) {
      case 'planted':
        return '🌱';
      case 'growing':
        return '🌿';
      case 'harvested':
        return '🌾';
      case 'failed':
        return '💀';
      default:
        return '🌱';
    }
  }

  Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'planted':
        return Colors.blue;
      case 'growing':
        return Colors.green;
      case 'harvested':
        return Colors.amber.shade700;
      case 'failed':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}

class _PlantCard extends StatelessWidget {
  final Plant plant;
  final Bed? bed;

  const _PlantCard({required this.plant, this.bed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final daysToHarvest = plant.expectedHarvestStart
        ?.difference(DateTime.now()).inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (bed != null) {
            context.push('/garden/bed/${bed!.id}/plant/${plant.id}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (plant.photoPath != null && plant.photoPath!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(plant.photoPath!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('🌿', style: TextStyle(fontSize: 28)),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.commonName,
                      style: tt.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      plant.variety,
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (bed != null) ...[
                          Icon(Icons.yard_outlined,
                              size: 14, color: cs.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            bed!.name,
                            style: tt.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                        if (plant.seedStartDate != null || plant.transplantDate != null) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.calendar_today,
                              size: 14, color: cs.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            formatShortDate(plant.transplantDate ?? plant.seedStartDate!),
                            style: tt.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (daysToHarvest != null && daysToHarvest > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${daysToHarvest}d',
                    style: TextStyle(
                      color: Colors.amber.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}


