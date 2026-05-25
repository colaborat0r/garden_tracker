// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/garden_providers.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/onboarding_dialog.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/data/regional_calendars.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Show onboarding popup once on first launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) maybeShowOnboardingDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final now = DateTime.now();
    final harvestTotal = ref.watch(harvestTotalThisYearProvider);
    final expenseTotal = ref.watch(expenseTotalThisYearProvider);
    final activePlants = ref.watch(activePlantsCountProvider);
    final allHarvestsList =
        ref.watch(allHarvestsProvider).valueOrNull ?? [];
    final allExpensesList =
        ref.watch(allExpensesProvider).valueOrNull ?? [];
    final totalHarvestLbs = allHarvestsList
        .where((h) => h.unit == 'lb' || h.unit == 'lbs')
        .fold(0.0, (s, h) => s + h.quantity);
    final totalExpenseAll =
        allExpensesList.fold(0.0, (s, e) => s + e.amount);
    final costPerLb =
        totalHarvestLbs > 0 ? totalExpenseAll / totalHarvestLbs : 0.0;
    final readyThisWeek = ref.watch(readyThisWeekProvider);
    final recentHarvests = ref.watch(recentHarvestsProvider);
    final recentObs = ref.watch(recentObservationsProvider);
    final allPlants = ref.watch(allPlantsProvider);
    final gardenName = ref.watch(gardenNameProvider).valueOrNull ?? 'My Garden';
    final regionId = ref.watch(gardenRegionProvider).valueOrNull ?? 'tt';
    final region = regionById(regionId);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Garden name row — tap to rename
                GestureDetector(
                  onTap: () => _editGardenName(context, ref, gardenName),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => context.push('/more/settings/about'),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            'assets/images/app_icon.png',
                            width: 28,
                            height: 28,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.eco, size: 28, color: cs.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(gardenName,
                          style: tt.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      Icon(Icons.edit_outlined,
                          size: 18,
                          color: cs.onSurfaceVariant),
                    ],
                  ),
                ),
                // Date
                Text(DateFormat('EEEE, MMM d').format(now),
                    style: tt.bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
                // Region — tap to change
                GestureDetector(
                  onTap: () => _showRegionPicker(context, ref, regionId),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(region.emoji,
                            style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 4),
                        Text(region.label,
                            style: tt.bodySmall?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w600)),
                        Icon(Icons.arrow_drop_down,
                            size: 16, color: cs.primary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Stats 2×2 grid ──
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'YTD Harvest',
                            value: harvestTotal.valueOrNull != null
                                ? '${harvestTotal.value!.toStringAsFixed(1)} lb'
                                : '…',
                            icon: Icons.scale,
                            color: Colors.amber.shade700,
                            onTap: () => context.go('/reports'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: StatCard(
                            label: 'Active Plants',
                            value: activePlants.valueOrNull != null
                                ? '${activePlants.value}'
                                : '…',
                            icon: Icons.eco,
                            color: cs.primary,
                            onTap: () => context.go('/garden'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'YTD Spend',
                            value: expenseTotal.valueOrNull != null
                                ? formatCurrency(expenseTotal.value!)
                                : '…',
                            icon: Icons.attach_money,
                            color: Colors.teal,
                            onTap: () => context.go('/more/expenses'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: StatCard(
                            label: 'Cost/lb',
                            value: formatCurrency(costPerLb),
                            icon: Icons.trending_down,
                            color: cs.primary,
                            onTap: () => context.go('/reports'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // ── Ready This Week ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('🗓 Ready This Week',
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => context.go('/garden'),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                readyThisWeek.when(
                  data: (plants) => plants.isEmpty
                      ? _emptySection(context,
                          'No harvests expected\nthis week 🌱')
                      : SizedBox(
                          height: 130,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: plants.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (_, i) =>
                                _ReadyPlantCard(plant: plants[i]),
                          ),
                        ),
                  loading: () => const Center(
                      child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator())),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
                // ── Quick Actions ──
                Text('⚡ Quick Actions',
                    style: tt.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionBtn(
                        icon: Icons.add_circle_outline,
                        label: 'Log Observation',
                        color: cs.primary,
                        onTap: () => context.go('/log'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickActionBtn(
                        icon: Icons.grass,
                        label: 'Log Harvest',
                        color: Colors.amber.shade700,
                        onTap: () => context.go('/log'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickActionBtn(
                        icon: Icons.yard_outlined,
                        label: 'Add Bed',
                        color: Colors.teal,
                        onTap: () => context.push('/garden/add-bed'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // ── Recent Activity ──
                Text('📋 Recent Activity',
                    style: tt.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _RecentActivityList(
                  harvests: recentHarvests.valueOrNull ?? [],
                  observations: recentObs.valueOrNull ?? [],
                  plants: allPlants.valueOrNull ?? [],
                  context: context,
                ),
                const SizedBox(height: 80),
              ]),
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
                        color:
                            Theme.of(ctx).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                ...gardenRegions.map((r) => ListTile(
                      leading: Text(r.emoji,
                          style: const TextStyle(fontSize: 24)),
                      title: Text(r.label,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
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

  Widget _emptySection(BuildContext context, String msg) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Text(msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant))),
      );
}
class _ReadyPlantCard extends StatelessWidget {
  final Plant plant;
  const _ReadyPlantCard({required this.plant});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      child: SizedBox(
        width: 140,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🌿', style: TextStyle(fontSize: 28)),
              const Spacer(),
              Text(plant.commonName,
                  style: tt.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              Text(plant.variety,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.shade700.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  daysUntil(plant.expectedHarvestStart),
                  style: tt.labelSmall?.copyWith(
                      color: Colors.amber.shade700,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionBtn(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                  maxLines: 2),
            ],
          ),
        ),
      ),
    );
  }
}
class _RecentActivityList extends StatelessWidget {
  final List<Harvest> harvests;
  final List<Observation> observations;
  final List<Plant> plants;
  final BuildContext context;
  const _RecentActivityList(
      {required this.harvests,
      required this.observations,
      required this.plants,
      required this.context});
  @override
  Widget build(BuildContext ctx) {
    final cs = Theme.of(ctx).colorScheme;
    final tt = Theme.of(ctx).textTheme;
    // merge + sort by date desc
    final items = <({DateTime date, String emoji, String title, String sub})>[];
    for (final h in harvests.take(5)) {
      final plant = plants.firstWhere((p) => p.id == h.plantId,
          orElse: () => plants.first);
      items.add((
        date: h.date,
        emoji: '🥬',
        title: 'Harvested ${plant.commonName}',
        sub: '${h.quantity.toStringAsFixed(1)} ${h.unit}'
      ));
    }
    for (final o in observations.take(5)) {
      final plant = plants.firstWhereOrNull((p) => p.id == o.plantId);
      items.add((
        date: o.date,
        emoji: obsTypeEmoji(o.type),
        title: '${obsTypeLabel(o.type)} — ${plant?.commonName ?? 'Plant'}',
        sub: o.description
      ));
    }
    items.sort((a, b) => b.date.compareTo(a.date));
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text('No activity yet. Start logging! 🌱',
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant)),
        ),
      );
    }
    return Column(
      children: items.take(8).map((item) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: cs.surfaceContainerHighest,
              child: Text(item.emoji,
                  style: const TextStyle(fontSize: 18)),
            ),
            title: Text(item.title,
                style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            subtitle: Text(item.sub,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(
              formatShortDate(item.date),
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          )).toList(),
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
