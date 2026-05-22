// lib/core/services/sample_data_service.dart
import 'package:drift/drift.dart';
import '../database/app_database.dart';

class SampleDataService {
  /// Inserts realistic sample garden data so new users can explore the app.
  static Future<void> loadSampleData(AppDatabase db) async {
    // ── Get the default garden ──────────────────────────────────────────────
    final gardens = await db.getAllGardens();
    if (gardens.isEmpty) return;
    final gardenId = gardens.first.id;

    // ── Beds ────────────────────────────────────────────────────────────────
    final bed1Id = await db.insertBed(BedsCompanion.insert(
      gardenId: gardenId,
      name: 'Main Raised Bed',
      type: const Value('raised'),
      areaSqFt: const Value(32.0),
      location: const Value('South-facing backyard'),
      soilType: const Value("Mel's Mix (peat, compost, vermiculite)"),
      notes: const Value('Primary growing space, full sun 8+ hrs'),
    ));

    final bed2Id = await db.insertBed(BedsCompanion.insert(
      gardenId: gardenId,
      name: 'Herb Container Garden',
      type: const Value('container'),
      areaSqFt: const Value(8.0),
      location: const Value('Back porch'),
      soilType: const Value('Premium potting mix'),
      notes: const Value('Containers on the porch, partial afternoon shade'),
    ));

    final bed3Id = await db.insertBed(BedsCompanion.insert(
      gardenId: gardenId,
      name: 'Tomato Row',
      type: const Value('ground'),
      areaSqFt: const Value(20.0),
      location: const Value('East side fence'),
      soilType: const Value('Native amended with compost'),
      notes: const Value('Trellised along fence, drip irrigation'),
    ));

    // ── Plants ──────────────────────────────────────────────────────────────
    final now = DateTime.now();

    // Bed 1 — raised bed
    final tomatoId = await db.insertPlant(PlantsCompanion.insert(
      bedId: bed1Id,
      commonName: 'Tomato',
      variety: 'Cherokee Purple',
      status: const Value('growing'),
      growthStage: const Value('flowering'),
      quantity: const Value(2),
      source: const Value('nursery'),
      seedStartDate: Value(now.subtract(const Duration(days: 55))),
      transplantDate: Value(now.subtract(const Duration(days: 35))),
      expectedHarvestStart: Value(now.add(const Duration(days: 15))),
      notes: const Value('Staked with bamboo poles. Watch for hornworms.'),
    ));

    final pepperBellId = await db.insertPlant(PlantsCompanion.insert(
      bedId: bed1Id,
      commonName: 'Bell Pepper',
      variety: 'California Wonder',
      status: const Value('growing'),
      growthStage: const Value('fruiting'),
      quantity: const Value(3),
      source: const Value('nursery'),
      seedStartDate: Value(now.subtract(const Duration(days: 60))),
      transplantDate: Value(now.subtract(const Duration(days: 40))),
      expectedHarvestStart: Value(now.add(const Duration(days: 10))),
      notes: const Value('Peppers setting nicely. Need consistent watering.'),
    ));

    final cucumberId = await db.insertPlant(PlantsCompanion.insert(
      bedId: bed1Id,
      commonName: 'Cucumber',
      variety: 'Marketmore 76',
      status: const Value('harvested'),
      growthStage: const Value('harvest_ready'),
      quantity: const Value(4),
      source: const Value('seed'),
      seedStartDate: Value(now.subtract(const Duration(days: 75))),
      transplantDate: Value(now.subtract(const Duration(days: 60))),
      expectedHarvestStart: Value(now.subtract(const Duration(days: 20))),
      notes: const Value('Great producer! Save seeds for next season.'),
    ));

    final lettuceBed1Id = await db.insertPlant(PlantsCompanion.insert(
      bedId: bed1Id,
      commonName: 'Lettuce',
      variety: 'Black Seeded Simpson',
      status: const Value('harvested'),
      growthStage: const Value('harvest_ready'),
      quantity: const Value(6),
      source: const Value('seed'),
      seedStartDate: Value(now.subtract(const Duration(days: 50))),
      transplantDate: Value(now.subtract(const Duration(days: 42))),
      expectedHarvestStart: Value(now.subtract(const Duration(days: 14))),
      notes: const Value('Cut-and-come-again harvest. Bolted after heat wave.'),
    ));

    // Bed 2 — herb containers
    final basilId = await db.insertPlant(PlantsCompanion.insert(
      bedId: bed2Id,
      commonName: 'Basil',
      variety: 'Genovese',
      status: const Value('growing'),
      growthStage: const Value('vegetative'),
      quantity: const Value(2),
      source: const Value('nursery'),
      seedStartDate: Value(now.subtract(const Duration(days: 30))),
      transplantDate: Value(now.subtract(const Duration(days: 20))),
      expectedHarvestStart: Value(now.add(const Duration(days: 5))),
      notes: const Value('Pinch flowers to promote leaf growth.'),
    ));

    await db.insertPlant(PlantsCompanion.insert(
      bedId: bed2Id,
      commonName: 'Mint',
      variety: 'Spearmint',
      status: const Value('growing'),
      growthStage: const Value('vegetative'),
      quantity: const Value(1),
      source: const Value('cutting'),
      transplantDate: Value(now.subtract(const Duration(days: 45))),
      expectedHarvestStart: Value(now.subtract(const Duration(days: 5))),
      notes: const Value('Keep contained — spreads aggressively!'),
    ));

    // Bed 3 — tomato row
    final tomatoCherryId = await db.insertPlant(PlantsCompanion.insert(
      bedId: bed3Id,
      commonName: 'Tomato',
      variety: 'Sun Gold Cherry',
      status: const Value('growing'),
      growthStage: const Value('fruiting'),
      quantity: const Value(3),
      source: const Value('nursery'),
      seedStartDate: Value(now.subtract(const Duration(days: 50))),
      transplantDate: Value(now.subtract(const Duration(days: 32))),
      expectedHarvestStart: Value(now.add(const Duration(days: 8))),
      notes: const Value('Prolific producer, sweet flavor. Needs suckering.'),
    ));

    final squashId = await db.insertPlant(PlantsCompanion.insert(
      bedId: bed3Id,
      commonName: 'Summer Squash',
      variety: 'Yellow Crookneck',
      status: const Value('growing'),
      growthStage: const Value('flowering'),
      quantity: const Value(2),
      source: const Value('seed'),
      seedStartDate: Value(now.subtract(const Duration(days: 35))),
      transplantDate: Value(now.subtract(const Duration(days: 24))),
      expectedHarvestStart: Value(now.add(const Duration(days: 12))),
      notes: const Value('Hand pollinate early morning for better fruit set.'),
    ));

    // ── Harvests ────────────────────────────────────────────────────────────
    await db.insertHarvest(HarvestsCompanion.insert(
      plantId: cucumberId,
      date: Value(now.subtract(const Duration(days: 20))),
      quantity: 2.1,
      unit: const Value('lb'),
      qualityRating: const Value(5),
      notes: const Value('First big harvest! Very crisp and flavorful.'),
    ));
    await db.insertHarvest(HarvestsCompanion.insert(
      plantId: cucumberId,
      date: Value(now.subtract(const Duration(days: 14))),
      quantity: 3.4,
      unit: const Value('lb'),
      qualityRating: const Value(5),
      notes: const Value('Peak production week.'),
    ));
    await db.insertHarvest(HarvestsCompanion.insert(
      plantId: cucumberId,
      date: Value(now.subtract(const Duration(days: 7))),
      quantity: 1.8,
      unit: const Value('lb'),
      qualityRating: const Value(4),
      notes: const Value('Slowing down as heat sets in.'),
    ));
    await db.insertHarvest(HarvestsCompanion.insert(
      plantId: lettuceBed1Id,
      date: Value(now.subtract(const Duration(days: 18))),
      quantity: 0.6,
      unit: const Value('lb'),
      qualityRating: const Value(4),
      notes: const Value('Tender leaves, used for salads all week.'),
    ));
    await db.insertHarvest(HarvestsCompanion.insert(
      plantId: lettuceBed1Id,
      date: Value(now.subtract(const Duration(days: 10))),
      quantity: 0.9,
      unit: const Value('lb'),
      qualityRating: const Value(5),
      notes: const Value('Final big cut before bolting.'),
    ));
    await db.insertHarvest(HarvestsCompanion.insert(
      plantId: basilId,
      date: Value(now.subtract(const Duration(days: 5))),
      quantity: 0.2,
      unit: const Value('lb'),
      qualityRating: const Value(5),
      notes: const Value('Made a big batch of pesto. Amazing aroma!'),
    ));
    await db.insertHarvest(HarvestsCompanion.insert(
      plantId: pepperBellId,
      date: Value(now.subtract(const Duration(days: 3))),
      quantity: 1.1,
      unit: const Value('lb'),
      qualityRating: const Value(4),
      notes: const Value('First peppers of the season — beautiful green ones.'),
    ));

    // ── Observations ────────────────────────────────────────────────────────
    await db.insertObservation(ObservationsCompanion.insert(
      plantId: tomatoId,
      date: Value(now.subtract(const Duration(days: 3))),
      type: 'water',
      description: 'Deep watered 2 gallons each plant at base.',
      amount: const Value(4.0),
      unit: const Value('gal'),
    ));
    await db.insertObservation(ObservationsCompanion.insert(
      plantId: tomatoId,
      date: Value(now.subtract(const Duration(days: 10))),
      type: 'fertilize',
      description: 'Applied tomato-tone granular fertilizer around drip line.',
      amount: const Value(0.5),
      unit: const Value('cup'),
    ));
    await db.insertObservation(ObservationsCompanion.insert(
      plantId: tomatoCherryId,
      date: Value(now.subtract(const Duration(days: 2))),
      type: 'pest',
      description: 'Spotted aphids on lower leaves. Sprayed with neem oil solution.',
    ));
    await db.insertObservation(ObservationsCompanion.insert(
      plantId: cucumberId,
      date: Value(now.subtract(const Duration(days: 8))),
      type: 'note',
      description: 'Powdery mildew on older leaves — improve airflow.',
    ));
    await db.insertObservation(ObservationsCompanion.insert(
      plantId: squashId,
      date: Value(now.subtract(const Duration(days: 1))),
      type: 'water',
      description: 'Morning watering, keeping leaves dry to prevent fungal issues.',
      amount: const Value(1.5),
      unit: const Value('gal'),
    ));

    // ── Observations ────────────────────────────────────────────────────────
    await db.insertExpense(ExpensesCompanion.insert(
      date: Value(now.subtract(const Duration(days: 65))),
      category: 'seeds',
      description: 'Heirloom seed variety pack',
      amount: 18.99,
      vendor: const Value('Baker Creek Seeds'),
      notes: const Value('Tomato, cucumber, squash, lettuce varieties'),
    ));
    await db.insertExpense(ExpensesCompanion.insert(
      date: Value(now.subtract(const Duration(days: 60))),
      category: 'soil',
      description: 'Raised bed soil mix (3 cu ft bags x4)',
      amount: 47.96,
      vendor: const Value('Local Garden Center'),
      notes: const Value('Premium blend with compost and perlite'),
    ));
    await db.insertExpense(ExpensesCompanion.insert(
      date: Value(now.subtract(const Duration(days: 55))),
      category: 'amendments',
      description: 'Tomato-tone organic fertilizer 4 lb bag',
      amount: 14.99,
      vendor: const Value('Home Depot'),
    ));
    await db.insertExpense(ExpensesCompanion.insert(
      date: Value(now.subtract(const Duration(days: 50))),
      category: 'seeds',
      description: 'Basil, mint, and herb seedlings (6-pack)',
      amount: 12.50,
      vendor: const Value('Farmers Market'),
      notes: const Value('Already established starts — saved time!'),
    ));
    await db.insertExpense(ExpensesCompanion.insert(
      date: Value(now.subtract(const Duration(days: 40))),
      category: 'tools',
      description: 'Garden hose nozzle (adjustable)',
      amount: 9.99,
      vendor: const Value('Lowes'),
    ));
    await db.insertExpense(ExpensesCompanion.insert(
      date: Value(now.subtract(const Duration(days: 30))),
      category: 'amendments',
      description: 'Neem oil spray concentrate',
      amount: 11.49,
      vendor: const Value('Amazon'),
      notes: const Value('For aphid and fungal prevention'),
    ));
    await db.insertExpense(ExpensesCompanion.insert(
      date: Value(now.subtract(const Duration(days: 15))),
      category: 'other',
      description: 'Bamboo stakes (25-pack)',
      amount: 7.49,
      vendor: const Value('Walmart'),
      notes: const Value('For staking tomatoes and peppers'),
    ));

    // ── Reminders ───────────────────────────────────────────────────────────
    await db.insertReminder(RemindersCompanion.insert(
      plantId: const Value(null),
      type: 'water',
      title: 'Water all containers',
      notes: const Value('Check moisture level first — containers dry out faster'),
      dueDate: now.add(const Duration(days: 1)),
      isRepeating: const Value(true),
      repeatInterval: const Value('daily'),
    ));
    await db.insertReminder(RemindersCompanion.insert(
      plantId: Value(tomatoId),
      type: 'fertilize',
      title: 'Fertilize tomatoes',
      notes: const Value('Apply tomato-tone at drip line, water in well'),
      dueDate: now.add(const Duration(days: 3)),
      isRepeating: const Value(true),
      repeatInterval: const Value('weekly'),
    ));
    await db.insertReminder(RemindersCompanion.insert(
      plantId: Value(tomatoCherryId),
      type: 'pest_check',
      title: 'Check cherry tomatoes for aphids',
      notes: const Value('Reapply neem oil if aphids return'),
      dueDate: now.add(const Duration(days: 2)),
    ));
    await db.insertReminder(RemindersCompanion.insert(
      plantId: Value(squashId),
      type: 'harvest',
      title: 'Harvest summer squash',
      notes: const Value('Best at 6–8 inches — check every 2 days once they start'),
      dueDate: now.add(const Duration(days: 12)),
    ));

    // ── Journal Entries ─────────────────────────────────────────────────────
    await db.insertJournalEntry(JournalEntriesCompanion.insert(
      title: '🌱 Garden is looking great!',
      body: const Value(
          "Everything is coming in nicely this season. The Cherokee Purple tomatoes are finally flowering — can't wait to taste them! "
          "The cucumber harvest has been amazing, already over 7 lbs total. "
          "Learned that consistent watering is key with cucumbers; any drought stress causes bitterness. "
          "Next season I want to try squash variety 'Patio Star' in the containers."),
      mood: const Value('😄'),
      tags: const Value('tomatoes,cucumbers,lessons-learned'),
      createdAt: Value(now.subtract(const Duration(days: 5))),
    ));
    await db.insertJournalEntry(JournalEntriesCompanion.insert(
      title: '🌧️ Rain + pests = trouble',
      body: const Value(
          'Three days of heavy rain left the garden soggy. '
          'Found aphids on the cherry tomatoes and some powdery mildew on the cucumbers. '
          'Applied neem oil spray in the evening. Will need to re-apply after next rain. '
          'Note to self: improve drainage in raised bed 1 before next rainy season.'),
      mood: const Value('🤔'),
      tags: const Value('pests,disease,rain,lessons-learned'),
      createdAt: Value(now.subtract(const Duration(days: 12))),
    ));
    await db.insertJournalEntry(JournalEntriesCompanion.insert(
      title: '✨ First big harvest of the year',
      body: const Value(
          'Pulled in 2.1 lbs of cucumbers today! Made fridge pickles with fresh dill from the herb garden. '
          'The color, crunch, and flavor are outstanding — so much better than store-bought. '
          'The lettuce is perfect for salads right now; harvesting outer leaves and leaving the center to keep growing. '
          'Total money invested this season so far: \$123. Already harvested \$50+ worth of produce!'),
      mood: const Value('🌱'),
      tags: const Value('harvest,pickles,lettuce,savings'),
      createdAt: Value(now.subtract(const Duration(days: 20))),
    ));
  }
}




