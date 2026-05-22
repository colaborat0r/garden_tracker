// lib/features/knowledge/knowledge_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/plant_database.dart';
import '../../core/data/regional_calendars.dart';
import '../../core/providers/settings_provider.dart';
import 'crop_guide_detail_screen.dart';
import 'planting_calendar_screen.dart';

class KnowledgeScreen extends ConsumerStatefulWidget {
  const KnowledgeScreen({super.key});
  @override
  ConsumerState<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends ConsumerState<KnowledgeScreen> {
  String _search = '';
  String _filter = 'all'; // all | vegetable | herb | fruit

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    List<PlantInfo> plants = _search.isNotEmpty
        ? searchPlants(_search)
        : (_filter == 'all'
            ? masterPlantDatabase
            : getPlantsByCategory(_filter));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
              title: Text('📚 Knowledge Base')),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search crops…',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (v) => setState(() => _search = v),
                  ),
                  const SizedBox(height: 12),
                  // Seasonal Calendar card
                  Card(
                    color: cs.primaryContainer,
                    child: ListTile(
                      leading: Icon(Icons.calendar_month_outlined,
                          color: cs.onPrimaryContainer),
                      title: const Text(
                          'Seasonal Planting Calendar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      subtitle: Builder(builder: (_) {
                        final id = ref.watch(gardenRegionProvider).valueOrNull ?? 'tt';
                        final r = regionById(id);
                        return Text(
                          '${r.emoji} ${r.label}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const PlantingCalendarScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Category filter chips
                  if (_search.isEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final cat in [
                            ('all', '🌿 All', 'all'),
                            ('vegetable', '🥕 Vegetables', 'vegetable'),
                            ('herb', '🌱 Herbs', 'herb'),
                            ('fruit', '🍓 Fruits', 'fruit'),
                          ])
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(cat.$2),
                                selected: _filter == cat.$1,
                                onSelected: (_) => setState(
                                    () => _filter = cat.$1),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: plants.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            const Text('🔍',
                                style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 8),
                            Text('No crops found',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _PlantCard(plant: plants[i]),
                      childCount: plants.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  final PlantInfo plant;
  const _PlantCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final catColor = _catColor(plant.category, cs);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CropGuideDetailScreen(plant: plant)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(plant.emoji,
                        style: const TextStyle(fontSize: 28)),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      plant.category,
                      style: TextStyle(
                          fontSize: 10,
                          color: catColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(plant.commonName,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                plant.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11, color: cs.onSurfaceVariant),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.wb_sunny_outlined,
                      size: 12, color: cs.onSurfaceVariant),
                  const SizedBox(width: 2),
                  Text(plant.sunRequirement,
                      style: TextStyle(
                          fontSize: 10, color: cs.onSurfaceVariant)),
                  const Spacer(),
                  if (plant.daysToMaturity != null)
                    Text('${plant.daysToMaturity}d',
                        style: TextStyle(
                            fontSize: 10,
                            color: cs.primary,
                            fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _catColor(String cat, ColorScheme cs) {
    switch (cat) {
      case 'vegetable':
        return Colors.green;
      case 'herb':
        return Colors.teal;
      case 'fruit':
        return Colors.orange;
      default:
        return cs.primary;
    }
  }
}

