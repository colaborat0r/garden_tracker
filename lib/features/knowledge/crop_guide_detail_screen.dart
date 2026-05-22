// lib/features/knowledge/crop_guide_detail_screen.dart
import 'package:flutter/material.dart';
import '../../core/data/plant_database.dart';

class CropGuideDetailScreen extends StatelessWidget {
  final PlantInfo plant;
  const CropGuideDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Row(
              children: [
                Text(plant.emoji,
                    style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Text(plant.commonName),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Chip(
                    label: Text(plant.category.toUpperCase()),
                    avatar: const Icon(Icons.eco_outlined, size: 16),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(plant.description,
                      style: tt.bodyMedium
                          ?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 20),

                  // Quick facts grid
                  const _SectionTitle('Quick Facts'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (plant.daysToGermination != null)
                        _FactChip(
                            '🌱', '${plant.daysToGermination}d to germinate'),
                      if (plant.daysToMaturity != null)
                        _FactChip(
                            '📅', '${plant.daysToMaturity}d to maturity'),
                      if (plant.spacing != null)
                        _FactChip('📏', plant.spacing!),
                      _FactChip('☀️', plant.sunRequirement),
                      _FactChip('💧', '${plant.waterNeeds} water'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Best planting months
                  const _SectionTitle('Best Planting Months (Florida)'),
                  const SizedBox(height: 8),
                  _PlantingMonthsRow(months: plant.bestPlantingMonths),
                  const SizedBox(height: 20),

                  // Common varieties
                  if (plant.commonVarieties.isNotEmpty) ...[
                    const _SectionTitle('Common Varieties'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: plant.commonVarieties
                          .map((v) => Chip(label: Text(v)))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Growing guide
                  if (plant.growthGuide.isNotEmpty) ...[
                    const _SectionTitle('Growing Guide'),
                    const SizedBox(height: 8),
                    ...plant.growthGuide.asMap().entries.map(
                          (e) => _GrowthStepCard(
                              step: e.key + 1, text: e.value),
                        ),
                    const SizedBox(height: 20),
                  ],

                  // Tips
                  const _SectionTitle('Pro Tips'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.amber.shade200, width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💡',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(plant.tips,
                              style: tt.bodyMedium?.copyWith(
                                  color: Colors.amber.shade900)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.bold),
      );
}

class _FactChip extends StatelessWidget {
  final String emoji;
  final String label;
  const _FactChip(this.emoji, this.label);
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$emoji $label',
          style: const TextStyle(fontSize: 12)),
    );
  }
}

class _PlantingMonthsRow extends StatelessWidget {
  final List<int> months;
  const _PlantingMonthsRow({required this.months});

  static const _abbr = [
    'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(12, (i) {
        final isActive = months.contains(i + 1);
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? cs.primary
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _abbr[i],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isActive
                    ? cs.onPrimary
                    : cs.onSurfaceVariant,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _GrowthStepCard extends StatelessWidget {
  final int step;
  final String text;
  const _GrowthStepCard({required this.step, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: cs.primaryContainer,
            child: Text('$step',
                style: TextStyle(
                    fontSize: 11,
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(text,
                  style: const TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

