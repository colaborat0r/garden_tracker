// lib/features/reports/reports_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/garden_providers.dart';
import '../../core/services/export_service.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/stat_card.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});
  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  int _chartYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar.large(
            title: const Text('📊 Reports & Insights'),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.download_outlined),
                tooltip: 'Export',
                onSelected: (v) => _handleExport(v),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                      value: 'csv_harvest',
                      child: ListTile(
                          leading: Icon(Icons.table_chart_outlined),
                          title: Text('Harvest CSV'))),
                  PopupMenuItem(
                      value: 'csv_expense',
                      child: ListTile(
                          leading: Icon(Icons.receipt_long_outlined),
                          title: Text('Expenses CSV'))),
                  PopupMenuItem(
                      value: 'json',
                      child: ListTile(
                          leading: Icon(Icons.data_object_outlined),
                          title: Text('Full JSON Export'))),
                  PopupMenuItem(
                      value: 'pdf',
                      child: ListTile(
                          leading: Icon(Icons.picture_as_pdf_outlined),
                          title: Text('PDF Report'))),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: TabBar(
              controller: _tab,
              tabs: const [
                Tab(icon: Icon(Icons.dashboard_outlined), text: 'Overview'),
                Tab(icon: Icon(Icons.eco_outlined), text: 'By Crop'),
                Tab(icon: Icon(Icons.grid_view_outlined), text: 'By Bed'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            _OverviewTab(chartYear: _chartYear,
                onYearChanged: (y) => setState(() => _chartYear = y)),
            const _ByCropTab(),
            const _ByBedTab(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExport(String type) async {
    try {
      switch (type) {
        case 'csv_harvest':
          final harvests =
              await ref.read(databaseProvider).watchAllHarvests().first;
          final plants =
              await ref.read(databaseProvider).watchAllPlants().first;
          final beds =
              await ref.read(databaseProvider).watchAllBeds().first;
          await ExportService.exportHarvestsCsv(harvests, plants, beds);
        case 'csv_expense':
          final expenses =
              await ref.read(databaseProvider).watchAllExpenses().first;
          await ExportService.exportExpensesCsv(expenses);
        case 'json':
          await ExportService.exportJson(ref.read(databaseProvider));
        case 'pdf':
          await ExportService.exportPdf(
              ref.read(databaseProvider), 'My Garden');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Export failed: $e')));
      }
    }
  }
}

// ── Overview Tab ─────────────────────────────────────────────────────────────

class _OverviewTab extends ConsumerWidget {
  final int chartYear;
  final ValueChanged<int> onYearChanged;
  const _OverviewTab(
      {required this.chartYear, required this.onYearChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allHarvests = ref.watch(allHarvestsProvider).valueOrNull ?? [];
    final allExpenses = ref.watch(allExpensesProvider).valueOrNull ?? [];
    final allPlants = ref.watch(allPlantsProvider).valueOrNull ?? [];
    final harvestTotal = ref.watch(harvestTotalThisYearProvider);
    final expenseTotal = ref.watch(expenseTotalThisYearProvider);
    final yearlyData = ref.watch(yearlyHarvestDataProvider(chartYear));
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final totalHarvestLbs = allHarvests
        .where((h) => h.unit == 'lb' || h.unit == 'lbs')
        .fold(0.0, (s, h) => s + h.quantity);
    final totalExpenseAll = allExpenses.fold(0.0, (s, e) => s + e.amount);
    final costPerLb =
        totalHarvestLbs > 0 ? totalExpenseAll / totalHarvestLbs : 0.0;

    // Last 6 months bar chart data
    final now = DateTime.now();
    final monthlyData = <int, double>{};
    for (var i = 5; i >= 0; i--) { monthlyData[6 - i] = 0; }
    for (final h in allHarvests) {
      if (h.date.isAfter(DateTime(now.year, now.month - 6, 1)) &&
          (h.unit == 'lb' || h.unit == 'lbs')) {
        final key = 6 - (now.month - h.date.month + (now.year - h.date.year) * 12);
        if (key >= 1 && key <= 6) {
          monthlyData[key] = (monthlyData[key] ?? 0) + h.quantity;
        }
      }
    }

    // Expense breakdown
    final expenseByCategory = <String, double>{};
    for (final e in allExpenses) {
      expenseByCategory[e.category] =
          (expenseByCategory[e.category] ?? 0) + e.amount;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary stats
        Row(children: [
          Expanded(
            child: StatCard(
              label: 'YTD Harvest',
              value: harvestTotal.valueOrNull != null
                  ? '${harvestTotal.value!.toStringAsFixed(1)} lb'
                  : '…',
              icon: Icons.scale,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatCard(
              label: 'YTD Spend',
              value: expenseTotal.valueOrNull != null
                  ? formatCurrency(expenseTotal.value!)
                  : '…',
              icon: Icons.attach_money,
              color: Colors.teal,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatCard(
              label: 'Cost/lb',
              value: formatCurrency(costPerLb),
              icon: Icons.trending_down,
              color: cs.primary,
            ),
          ),
        ]),
        const SizedBox(height: 24),
        // 6-month chart
        Text('Last 6 Months (lbs)',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (allHarvests.isEmpty)
          _emptyChart(context, 'Log harvests to see your yield chart')
        else
          _buildBarChart(context, monthlyData, (idx) {
            final month =
                DateTime(now.year, now.month - (6 - idx), 1);
            return '${month.month}/${month.year % 100}';
          }),
        const SizedBox(height: 24),
        // Yearly chart
        Row(
          children: [
            Expanded(
              child: Text('Yearly Harvest ($chartYear lbs)',
                  style: tt.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => onYearChanged(chartYear - 1),
                  iconSize: 20,
                ),
                Text('$chartYear',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  iconSize: 20,
                  onPressed: chartYear < now.year
                      ? () => onYearChanged(chartYear + 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        yearlyData.when(
          data: (data) => allHarvests.isEmpty
              ? _emptyChart(context, 'No harvest data for $chartYear')
              : _buildBarChart(context, data, (idx) {
                  const abbr = [
                    'J', 'F', 'M', 'A', 'M', 'J',
                    'J', 'A', 'S', 'O', 'N', 'D'
                  ];
                  return abbr[(idx - 1).clamp(0, 11)];
                }),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
        ),
        const SizedBox(height: 24),
        // Expense breakdown
        Text('Expense Breakdown',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (expenseByCategory.isEmpty)
          _emptyChart(context, 'Log expenses to see breakdown')
        else
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: expenseByCategory.entries
                    .toList()
                    .asMap()
                    .entries
                    .map((e) {
                  final colors = [
                    cs.primary,
                    Colors.teal,
                    Colors.amber.shade700,
                    Colors.blue,
                    Colors.purple,
                  ];
                  return PieChartSectionData(
                    value: e.value.value,
                    title:
                        '${e.value.key}\n${formatCurrency(e.value.value)}',
                    color: colors[e.key % colors.length],
                    radius: 80,
                    titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        const SizedBox(height: 24),
        // Plant summary
        Text('Plant Summary',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _PlantSummary(plants: allPlants),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context, Map<int, double> data,
      String Function(int) labelFn) {
    final cs = Theme.of(context).colorScheme;
    final maxY = data.values.isEmpty
        ? 10.0
        : (data.values.reduce((a, b) => a > b ? a : b) * 1.2) + 1;
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barGroups: data.entries
              .map((e) => BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        color: cs.primary,
                        width: 18,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ))
              .toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) =>
                    Text(labelFn(v.toInt()),
                        style: const TextStyle(fontSize: 9)),
                reservedSize: 22,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 9)),
              ),
            ),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            getDrawingHorizontalLine: (_) => FlLine(
                color: Theme.of(context).colorScheme.outlineVariant,
                strokeWidth: 0.5),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _emptyChart(BuildContext ctx, String msg) => Container(
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(msg,
              style: TextStyle(
                  color:
                      Theme.of(ctx).colorScheme.onSurfaceVariant)),
        ),
      );
}

// ── By Crop Tab ───────────────────────────────────────────────────────────────

class _ByCropTab extends ConsumerWidget {
  const _ByCropTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yieldAsync = ref.watch(yieldByCropProvider);
    final successAsync = ref.watch(successRateByVarietyProvider);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Yield by crop
        Text('Yield by Crop (lbs)',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        yieldAsync.when(
          data: (data) {
            if (data.isEmpty) {
              return Container(
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('No harvest data yet'),
              );
            }
            final sorted = data.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final maxVal = sorted.first.value;
            return Column(
              children: sorted.map((e) {
                final pct = maxVal > 0 ? e.value / maxVal : 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          Text('${e.value.toStringAsFixed(1)} lb',
                              style: TextStyle(
                                  color: cs.primary,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 8,
                          backgroundColor: cs.surfaceContainerHighest,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(cs.primary),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
        ),
        const SizedBox(height: 24),
        // Success rate by variety
        Text('Success Rate by Variety',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Based on plants with harvested/failed status',
            style: tt.bodySmall
                ?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 12),
        successAsync.when(
          data: (data) {
            if (data.isEmpty) {
              return Container(
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('No plant data yet'),
              );
            }
            return Column(
              children: data.map((row) {
                final rate = (row['successRate'] as double) * 100;
                final total = row['total'] as int;
                final harvested = row['harvested'] as int;
                final failed = row['failed'] as int;
                final color = rate >= 70
                    ? Colors.green
                    : rate >= 40
                        ? Colors.orange
                        : Colors.red;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(row['variety'] as String,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(
                        '$harvested harvested · $failed failed · $total total'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${rate.toStringAsFixed(0)}%',
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

// ── By Bed Tab ────────────────────────────────────────────────────────────────

class _ByBedTab extends ConsumerWidget {
  const _ByBedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yieldAsync = ref.watch(yieldByBedProvider);
    final allPlants = ref.watch(allPlantsProvider).valueOrNull ?? [];
    final allBeds = ref.watch(allBedsProvider).valueOrNull ?? [];
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    // Plants per bed
    final plantsPerBed = <int, int>{};
    for (final p in allPlants) {
      plantsPerBed[p.bedId] = (plantsPerBed[p.bedId] ?? 0) + 1;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Best Performing Beds (lbs harvested)',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        yieldAsync.when(
          data: (data) {
            if (data.isEmpty) {
              return Container(
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('No harvest data yet'),
              );
            }
            final sorted = data.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final maxVal = sorted.first.value;
            return Column(
              children: sorted.asMap().entries.map((entry) {
                final rank = entry.key + 1;
                final e = entry.value;
                final pct = maxVal > 0 ? e.value / maxVal : 0.0;
                final medals = ['🥇', '🥈', '🥉'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          rank <= 3 ? medals[rank - 1] : '$rank.',
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.key,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                Text('${e.value.toStringAsFixed(1)} lb',
                                    style: TextStyle(
                                        color: cs.primary,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 8,
                                backgroundColor:
                                    cs.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    rank == 1
                                        ? Colors.amber.shade700
                                        : rank == 2
                                            ? cs.primary
                                            : cs.secondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
        ),
        const SizedBox(height: 24),
        // Bed overview table
        Text('Bed Overview',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (allBeds.isEmpty)
          Text('No beds yet',
              style: TextStyle(color: cs.onSurfaceVariant))
        else
          ...allBeds.map((b) {
            final count = plantsPerBed[b.id] ?? 0;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: cs.primaryContainer,
                  child: const Text('🌿'),
                ),
                title: Text(b.name,
                    style:
                        const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${b.type} · $count plants'
                    '${b.areaSqFt != null ? ' · ${b.areaSqFt!.toStringAsFixed(0)} sq ft' : ''}'),
                trailing: Text(
                  '${yieldAsync.valueOrNull?[b.name]?.toStringAsFixed(1) ?? '0'} lb',
                  style: TextStyle(
                      color: cs.primary, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
        const SizedBox(height: 80),
      ],
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _PlantSummary extends StatelessWidget {
  final List<Plant> plants;
  const _PlantSummary({required this.plants});
  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{
      'planted': 0,
      'growing': 0,
      'harvested': 0,
      'failed': 0,
    };
    for (final p in plants) {
      counts[p.status] = (counts[p.status] ?? 0) + 1;
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: counts.entries.map((e) {
        final color = statusColor(context, e.key);
        return Chip(
          avatar: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Text('${e.value}',
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          label: Text(e.key[0].toUpperCase() + e.key.substring(1)),
        );
      }).toList(),
    );
  }
}
