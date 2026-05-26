// lib/features/analytics/analytics_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/garden_providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('📈 Analytics'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Growth Timeline
                Text('🌱 Growth Timeline',
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Track your garden\'s expansion over time',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 16),
                _GrowthTimeline(),
                const SizedBox(height: 32),

                // Productivity Analysis
                Text('⚡ Productivity Analysis',
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Compare yields across growing seasons',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 16),
                _ProductivityAnalysis(),
                const SizedBox(height: 32),

                // Efficiency Metrics
                Text('🎯 Efficiency Metrics',
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _EfficiencyMetrics(),
                const SizedBox(height: 32),

                // Best Performers
                Text('🏆 Best Performers',
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _BestPerformers(),
                const SizedBox(height: 32),

                // Seasonal Insights
                Text('🌤 Seasonal Insights',
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _SeasonalInsights(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthTimeline extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPlants = ref.watch(allPlantsProvider).valueOrNull ?? [];
    final cs = Theme.of(context).colorScheme;

    // Group plants by month they were planted
    final monthlyPlants = <DateTime, int>{};
    for (final plant in allPlants) {
      final plantDate = plant.transplantDate ?? plant.seedStartDate;
      if (plantDate != null) {
        final month = DateTime(plantDate.year, plantDate.month);
        monthlyPlants[month] = (monthlyPlants[month] ?? 0) + 1;
      }
    }

    if (monthlyPlants.isEmpty) {
      return _emptyState(context, 'Start planting to see growth timeline');
    }

    final sorted = monthlyPlants.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Calculate cumulative
    var cumulative = 0;
    final cumulativeData = <FlSpot>[];
    for (var i = 0; i < sorted.length; i++) {
      cumulative += sorted[i].value;
      cumulativeData.add(FlSpot(i.toDouble(), cumulative.toDouble()));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: cumulativeData,
                      isCurved: true,
                      color: cs.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: cs.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= sorted.length) return const SizedBox();
                          final date = sorted[value.toInt()].key;
                          return Text(
                            '${date.month}/${date.year % 100}',
                            style: const TextStyle(fontSize: 9),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 9),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: cs.outlineVariant,
                      strokeWidth: 0.5,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Total plants: $cumulative',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductivityAnalysis extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allHarvests = ref.watch(allHarvestsProvider).valueOrNull ?? [];
    final cs = Theme.of(context).colorScheme;

    if (allHarvests.isEmpty) {
      return _emptyState(context, 'Log harvests to analyze productivity');
    }

    // Calculate quarterly harvest totals
    final quarters = <String, double>{};

    for (final harvest in allHarvests.where((h) => h.unit == 'lb' || h.unit == 'lbs')) {
      final quarter = 'Q${((harvest.date.month - 1) ~/ 3) + 1} ${harvest.date.year}';
      quarters[quarter] = (quarters[quarter] ?? 0) + harvest.quantity;
    }

    final sorted = quarters.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: sorted.take(8).map((entry) {
            final maxValue = sorted.map((e) => e.value).reduce((a, b) => a > b ? a : b);
            final percentage = maxValue > 0 ? entry.value / maxValue : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        '${entry.value.toStringAsFixed(1)} lb',
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 8,
                      backgroundColor: cs.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _EfficiencyMetrics extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allHarvests = ref.watch(allHarvestsProvider).valueOrNull ?? [];
    final allPlants = ref.watch(allPlantsProvider).valueOrNull ?? [];
    final allBeds = ref.watch(allBedsProvider).valueOrNull ?? [];
    final allExpenses = ref.watch(allExpensesProvider).valueOrNull ?? [];

    final totalHarvestLbs = allHarvests
        .where((h) => h.unit == 'lb' || h.unit == 'lbs')
        .fold(0.0, (sum, h) => sum + h.quantity);

    final totalArea = allBeds.fold(0.0, (sum, b) => sum + (b.areaSqFt ?? 0));
    final yieldPerSqFt = totalArea > 0 ? totalHarvestLbs / totalArea : 0.0;

    final activePlants = allPlants.where((p) =>
        p.status == 'planted' || p.status == 'growing').length;
    final yieldPerPlant = activePlants > 0 ? totalHarvestLbs / activePlants : 0.0;

    final totalExpense = allExpenses.fold(0.0, (sum, e) => sum + e.amount);
    final roi = totalExpense > 0 ? (totalHarvestLbs * 3 - totalExpense) / totalExpense * 100 : 0.0;

    final metrics = [
      ('Yield/Sq Ft', '${yieldPerSqFt.toStringAsFixed(2)} lb', Icons.grid_on, Colors.blue),
      ('Yield/Plant', '${yieldPerPlant.toStringAsFixed(2)} lb', Icons.eco, Colors.green),
      ('ROI', '${roi.toStringAsFixed(0)}%', Icons.trending_up, Colors.amber.shade700),
    ];

    return Row(
      children: metrics.map((metric) {
        return Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Icon(metric.$3, color: metric.$4, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    metric.$2,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: metric.$4,
                    ),
                  ),
                  Text(
                    metric.$1,
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _BestPerformers extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allHarvests = ref.watch(allHarvestsProvider).valueOrNull ?? [];
    final allPlants = ref.watch(allPlantsProvider).valueOrNull ?? [];
    final cs = Theme.of(context).colorScheme;

    if (allHarvests.isEmpty) {
      return _emptyState(context, 'Log harvests to see best performers');
    }

    // Calculate yield per plant
    final plantYields = <int, double>{};
    for (final harvest in allHarvests.where((h) => h.unit == 'lb' || h.unit == 'lbs')) {
      plantYields[harvest.plantId] = (plantYields[harvest.plantId] ?? 0) + harvest.quantity;
    }

    final sorted = plantYields.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sorted.take(5).map((entry) {
        final plant = allPlants.firstWhereOrNull((p) => p.id == entry.key);
        if (plant == null) return const SizedBox.shrink();

        final rank = sorted.indexOf(entry) + 1;
        final medals = ['🥇', '🥈', '🥉'];

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Text(
              rank <= 3 ? medals[rank - 1] : '$rank.',
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(
              plant.commonName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(plant.variety),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${entry.value.toStringAsFixed(1)} lb',
                style: TextStyle(
                  color: cs.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SeasonalInsights extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allHarvests = ref.watch(allHarvestsProvider).valueOrNull ?? [];
    final cs = Theme.of(context).colorScheme;

    if (allHarvests.isEmpty) {
      return _emptyState(context, 'Log harvests to see seasonal insights');
    }

    // Group by season
    final seasons = <String, double>{
      'Spring (Mar-May)': 0,
      'Summer (Jun-Aug)': 0,
      'Fall (Sep-Nov)': 0,
      'Winter (Dec-Feb)': 0,
    };

    for (final harvest in allHarvests.where((h) => h.unit == 'lb' || h.unit == 'lbs')) {
      final month = harvest.date.month;
      if (month >= 3 && month <= 5) {
        seasons['Spring (Mar-May)'] = seasons['Spring (Mar-May)']! + harvest.quantity;
      } else if (month >= 6 && month <= 8) {
        seasons['Summer (Jun-Aug)'] = seasons['Summer (Jun-Aug)']! + harvest.quantity;
      } else if (month >= 9 && month <= 11) {
        seasons['Fall (Sep-Nov)'] = seasons['Fall (Sep-Nov)']! + harvest.quantity;
      } else {
        seasons['Winter (Dec-Feb)'] = seasons['Winter (Dec-Feb)']! + harvest.quantity;
      }
    }

    final total = seasons.values.fold(0.0, (sum, v) => sum + v);
    if (total == 0) {
      return _emptyState(context, 'No harvest data yet');
    }

    final colors = [
      Colors.pink.shade300,
      Colors.amber.shade700,
      Colors.orange.shade700,
      Colors.blue.shade300,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: seasons.entries.toList().asMap().entries.map((entry) {
                    final percentage = (entry.value.value / total * 100);
                    return PieChartSectionData(
                      value: entry.value.value,
                      title: '${percentage.toStringAsFixed(0)}%',
                      color: colors[entry.key],
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...seasons.entries.toList().asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colors[entry.key],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(entry.value.key)),
                    Text(
                      '${entry.value.value.toStringAsFixed(1)} lb',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

Widget _emptyState(BuildContext context, String message) {
  final cs = Theme.of(context).colorScheme;
  return Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: cs.onSurfaceVariant),
      ),
    ),
  );
}

extension _ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}


