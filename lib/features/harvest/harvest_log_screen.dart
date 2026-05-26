// lib/features/harvest/harvest_log_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/garden_providers.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/empty_state.dart';

class HarvestLogScreen extends ConsumerStatefulWidget {
  const HarvestLogScreen({super.key});

  @override
  ConsumerState<HarvestLogScreen> createState() => _HarvestLogScreenState();
}

class _HarvestLogScreenState extends ConsumerState<HarvestLogScreen> {
  String _searchQuery = '';
  String _filterType = 'all'; // all, this_month, this_year
  String _sortBy = 'date_desc'; // date_desc, date_asc, quantity_desc

  @override
  Widget build(BuildContext context) {
    final harvestsAsync = ref.watch(allHarvestsProvider);
    final allPlants = ref.watch(allPlantsProvider).valueOrNull ?? [];
    final allBeds = ref.watch(allBedsProvider).valueOrNull ?? [];
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('🌾 Harvest Log'),
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
                  hintText: 'Search by plant or notes...',
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
          harvestsAsync.when(
            data: (harvests) {
              if (harvests.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    emoji: '🌾',
                    title: 'No harvests logged',
                    subtitle: 'Start tracking your garden yield!',
                    actionLabel: 'Log Harvest',
                    onAction: () => context.go('/log'),
                  ),
                );
              }

              // Filter
              var filtered = harvests.where((h) {
                if (_searchQuery.isNotEmpty) {
                  final plant = allPlants.firstWhereOrNull((p) => p.id == h.plantId);
                  final nameMatch = plant?.commonName.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
                  final notesMatch = h.notes?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
                  if (!nameMatch && !notesMatch) return false;
                }

                final now = DateTime.now();
                switch (_filterType) {
                  case 'this_month':
                    return h.date.month == now.month && h.date.year == now.year;
                  case 'this_year':
                    return h.date.year == now.year;
                  default:
                    return true;
                }
              }).toList();

              // Sort
              switch (_sortBy) {
                case 'date_asc':
                  filtered.sort((a, b) => a.date.compareTo(b.date));
                  break;
                case 'quantity_desc':
                  filtered.sort((a, b) => b.quantity.compareTo(a.quantity));
                  break;
                case 'date_desc':
                default:
                  filtered.sort((a, b) => b.date.compareTo(a.date));
              }

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No harvests match your filters',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ),
                );
              }

              // Group by month
              final grouped = <String, List<Harvest>>{};
              for (final h in filtered) {
                final key = DateFormat('MMMM yyyy').format(h.date);
                grouped[key] = [...(grouped[key] ?? []), h];
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final keys = grouped.keys.toList();
                      final monthKey = keys[index];
                      final monthHarvests = grouped[monthKey]!;
                      final monthTotal = monthHarvests
                          .where((h) => h.unit == 'lb' || h.unit == 'lbs')
                          .fold(0.0, (sum, h) => sum + h.quantity);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  monthKey,
                                  style: tt.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (monthTotal > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${monthTotal.toStringAsFixed(1)} lb',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          ...monthHarvests.map((harvest) {
                            final plant = allPlants.firstWhereOrNull(
                              (p) => p.id == harvest.plantId,
                            );
                            final bed = allBeds.firstWhereOrNull(
                              (b) => b.id == plant?.bedId,
                            );
                            return _HarvestCard(
                              harvest: harvest,
                              plant: plant,
                              bed: bed,
                            );
                          }),
                        ],
                      );
                    },
                    childCount: grouped.length,
                  ),
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
        onPressed: () => context.go('/log'),
        icon: const Icon(Icons.add),
        label: const Text('Log Harvest'),
      ),
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
                  'Filter & Sort',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Time Period',
                    style: Theme.of(ctx).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('All Time'),
                      selected: _filterType == 'all',
                      onSelected: (v) {
                        if (v) setState(() => _filterType = 'all');
                        Navigator.pop(ctx);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('This Month'),
                      selected: _filterType == 'this_month',
                      onSelected: (v) {
                        if (v) setState(() => _filterType = 'this_month');
                        Navigator.pop(ctx);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('This Year'),
                      selected: _filterType == 'this_year',
                      onSelected: (v) {
                        if (v) setState(() => _filterType = 'this_year');
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Sort By', style: Theme.of(ctx).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Newest First'),
                      selected: _sortBy == 'date_desc',
                      onSelected: (v) {
                        if (v) setState(() => _sortBy = 'date_desc');
                        Navigator.pop(ctx);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Oldest First'),
                      selected: _sortBy == 'date_asc',
                      onSelected: (v) {
                        if (v) setState(() => _sortBy = 'date_asc');
                        Navigator.pop(ctx);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Largest Yield'),
                      selected: _sortBy == 'quantity_desc',
                      onSelected: (v) {
                        if (v) setState(() => _sortBy = 'quantity_desc');
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
}

class _HarvestCard extends StatelessWidget {
  final Harvest harvest;
  final Plant? plant;
  final Bed? bed;

  const _HarvestCard({
    required this.harvest,
    this.plant,
    this.bed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withValues(alpha: 0.15),
          child: const Text('🌾', style: TextStyle(fontSize: 20)),
        ),
        title: Text(
          plant?.commonName ?? 'Unknown Plant',
          style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${plant?.variety ?? ''} ${bed != null ? '• ${bed!.name}' : ''}'),
            const SizedBox(height: 4),
            if (harvest.notes != null && harvest.notes!.isNotEmpty)
              Text(
                harvest.notes!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${harvest.quantity.toStringAsFixed(1)} ${harvest.unit}',
              style: tt.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              formatShortDate(harvest.date),
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
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

