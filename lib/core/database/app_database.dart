// lib/core/database/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';
part 'app_database.g.dart';
@DriftDatabase(
  tables: [Gardens, Beds, Plants, Observations, Harvests, Expenses, Reminders,
           PlantPhotos, JournalEntries],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 2;
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement('PRAGMA foreign_keys = ON');
          await into(gardens)
              .insert(GardensCompanion.insert(name: 'My Garden'));
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(plants, plants.growthStage);
            await m.addColumn(plants, plants.quantity);
            await m.addColumn(plants, plants.source);
            await m.createTable(plantPhotos);
            await m.createTable(journalEntries);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
  // GARDENS
  Stream<List<Garden>> watchAllGardens() => select(gardens).watch();
  Future<List<Garden>> getAllGardens() => select(gardens).get();
  Future<int> insertGarden(GardensCompanion g) => into(gardens).insert(g);
  Future<bool> updateGarden(Garden g) => update(gardens).replace(g);
  // BEDS
  Stream<List<Bed>> watchAllBeds() => select(beds).watch();
  Stream<List<Bed>> watchBedsByGarden(int gardenId) =>
      (select(beds)..where((b) => b.gardenId.equals(gardenId))).watch();
  Future<Bed?> getBed(int id) =>
      (select(beds)..where((b) => b.id.equals(id))).getSingleOrNull();
  Future<int> insertBed(BedsCompanion b) => into(beds).insert(b);
  Future<bool> updateBed(Bed b) => update(beds).replace(b);
  Future<int> deleteBed(int id) =>
      (delete(beds)..where((b) => b.id.equals(id))).go();
  // PLANTS
  Stream<List<Plant>> watchAllPlants() => select(plants).watch();
  Stream<List<Plant>> watchPlantsByBed(int bedId) =>
      (select(plants)..where((p) => p.bedId.equals(bedId))).watch();
  Stream<List<Plant>> watchActivePlants() =>
      (select(plants)
            ..where((p) => p.status.isIn(['planted', 'growing'])))
          .watch();
  Stream<List<Plant>> watchReadyThisWeek() {
    final weekFromNow = DateTime.now().add(const Duration(days: 7));
    return (select(plants)
          ..where((p) =>
              p.expectedHarvestStart.isSmallerOrEqualValue(weekFromNow) &
              p.status.isIn(['planted', 'growing'])))
        .watch();
  }
  Future<Plant?> getPlant(int id) =>
      (select(plants)..where((p) => p.id.equals(id))).getSingleOrNull();
  Future<int> insertPlant(PlantsCompanion p) => into(plants).insert(p);
  Future<bool> updatePlant(Plant p) => update(plants).replace(p);
  Future<int> deletePlant(int id) =>
      (delete(plants)..where((p) => p.id.equals(id))).go();
  // OBSERVATIONS
  Stream<List<Observation>> watchObservationsByPlant(int plantId) =>
      (select(observations)
            ..where((o) => o.plantId.equals(plantId))
            ..orderBy([(o) => OrderingTerm.desc(o.date)]))
          .watch();
  Stream<List<Observation>> watchRecentObservations({int limit = 15}) =>
      (select(observations)
            ..orderBy([(o) => OrderingTerm.desc(o.date)])
            ..limit(limit))
          .watch();
  Future<int> insertObservation(ObservationsCompanion o) =>
      into(observations).insert(o);
  Future<int> deleteObservation(int id) =>
      (delete(observations)..where((o) => o.id.equals(id))).go();
  // HARVESTS
  Stream<List<Harvest>> watchAllHarvests() =>
      (select(harvests)..orderBy([(h) => OrderingTerm.desc(h.date)])).watch();
  Stream<List<Harvest>> watchHarvestsByPlant(int plantId) =>
      (select(harvests)
            ..where((h) => h.plantId.equals(plantId))
            ..orderBy([(h) => OrderingTerm.desc(h.date)]))
          .watch();
  Stream<List<Harvest>> watchRecentHarvests({int limit = 15}) =>
      (select(harvests)
            ..orderBy([(h) => OrderingTerm.desc(h.date)])
            ..limit(limit))
          .watch();
  Future<int> insertHarvest(HarvestsCompanion h) => into(harvests).insert(h);
  Future<int> deleteHarvest(int id) =>
      (delete(harvests)..where((h) => h.id.equals(id))).go();
  // EXPENSES
  Stream<List<Expense>> watchAllExpenses() =>
      (select(expenses)..orderBy([(e) => OrderingTerm.desc(e.date)])).watch();
  Future<int> insertExpense(ExpensesCompanion e) => into(expenses).insert(e);
  Future<bool> updateExpense(Expense e) => update(expenses).replace(e);
  Future<int> deleteExpense(int id) =>
      (delete(expenses)..where((e) => e.id.equals(id))).go();
  // REMINDERS
  Stream<List<Reminder>> watchActiveReminders() =>
      (select(reminders)
            ..where((r) => r.isCompleted.equals(false))
            ..orderBy([(r) => OrderingTerm.asc(r.dueDate)]))
          .watch();
  Stream<List<Reminder>> watchAllReminders() =>
      (select(reminders)..orderBy([(r) => OrderingTerm.asc(r.dueDate)]))
          .watch();
  Future<int> insertReminder(RemindersCompanion r) =>
      into(reminders).insert(r);
  Future<bool> updateReminder(Reminder r) => update(reminders).replace(r);
  Future<int> deleteReminder(int id) =>
      (delete(reminders)..where((r) => r.id.equals(id))).go();
  // PLANT PHOTOS
  Stream<List<PlantPhoto>> watchPhotosByPlant(int plantId) =>
      (select(plantPhotos)
            ..where((p) => p.plantId.equals(plantId))
            ..orderBy([(p) => OrderingTerm.desc(p.takenAt)]))
          .watch();
  Stream<List<PlantPhoto>> watchAllPhotos() =>
      (select(plantPhotos)
            ..orderBy([(p) => OrderingTerm.desc(p.takenAt)]))
          .watch();
  Future<int> insertPlantPhoto(PlantPhotosCompanion p) =>
      into(plantPhotos).insert(p);
  Future<int> deletePlantPhoto(int id) =>
      (delete(plantPhotos)..where((p) => p.id.equals(id))).go();
  // JOURNAL ENTRIES
  Stream<List<JournalEntry>> watchAllJournalEntries() =>
      (select(journalEntries)
            ..orderBy([(j) => OrderingTerm.desc(j.createdAt)]))
          .watch();
  Future<int> insertJournalEntry(JournalEntriesCompanion j) =>
      into(journalEntries).insert(j);
  Future<bool> updateJournalEntry(JournalEntry j) =>
      update(journalEntries).replace(j);
  Future<int> deleteJournalEntry(int id) =>
      (delete(journalEntries)..where((j) => j.id.equals(id))).go();
  // ANALYTICS
  Future<double> getTotalHarvestThisYear() async {
    final now = DateTime.now();
    final rows = await (select(harvests)
          ..where((h) =>
              h.date.isBiggerOrEqualValue(DateTime(now.year)) &
              h.unit.isIn(['lb', 'lbs'])))
        .get();
    return rows.fold<double>(0.0, (s, h) => s + h.quantity);
  }
  Future<double> getTotalExpensesThisYear() async {
    final now = DateTime.now();
    final rows = await (select(expenses)
          ..where((e) => e.date.isBiggerOrEqualValue(DateTime(now.year))))
        .get();
    return rows.fold<double>(0.0, (s, e) => s + e.amount);
  }
  Future<int> getActivePlantsCount() async {
    final rows = await (select(plants)
          ..where((p) => p.status.isIn(['planted', 'growing'])))
        .get();
    return rows.length;
  }
  /// Yield by crop (common name → total lbs)
  Future<Map<String, double>> getYieldByCrop() async {
    final harvestRows = await watchAllHarvests().first;
    final plantRows = await watchAllPlants().first;
    final plantMap = {for (final p in plantRows) p.id: p};
    final result = <String, double>{};
    for (final h in harvestRows.where((h) => h.unit == 'lb' || h.unit == 'lbs')) {
      final name = plantMap[h.plantId]?.commonName ?? 'Unknown';
      result[name] = (result[name] ?? 0) + h.quantity;
    }
    return result;
  }
  /// Yield by bed name → total lbs
  Future<Map<String, double>> getYieldByBed() async {
    final harvestRows = await watchAllHarvests().first;
    final plantRows = await watchAllPlants().first;
    final bedRows = await watchAllBeds().first;
    final plantMap = {for (final p in plantRows) p.id: p};
    final bedMap = {for (final b in bedRows) b.id: b};
    final result = <String, double>{};
    for (final h in harvestRows.where((h) => h.unit == 'lb' || h.unit == 'lbs')) {
      final plant = plantMap[h.plantId];
      if (plant != null) {
        final bedName = bedMap[plant.bedId]?.name ?? 'Unknown Bed';
        result[bedName] = (result[bedName] ?? 0) + h.quantity;
      }
    }
    return result;
  }
  /// Success rate by variety: returns list sorted by success rate desc
  Future<List<Map<String, dynamic>>> getSuccessRateByVariety() async {
    final plantRows = await watchAllPlants().first;
    final grouped = <String, List<Plant>>{};
    for (final p in plantRows) {
      final key = '${p.commonName} — ${p.variety}';
      grouped.putIfAbsent(key, () => []).add(p);
    }
    final list = grouped.entries.map((e) {
      final total = e.value.length;
      final harvested = e.value.where((p) => p.status == 'harvested').length;
      final failed = e.value.where((p) => p.status == 'failed').length;
      return {
        'variety': e.key,
        'total': total,
        'harvested': harvested,
        'failed': failed,
        'successRate': total > 0 ? harvested / total : 0.0,
      };
    }).toList();
    list.sort((a, b) =>
        (b['successRate'] as double).compareTo(a['successRate'] as double));
    return list;
  }
  /// Monthly harvest data for a given year
  Future<Map<int, double>> getYearlyHarvestData(int year) async {
    final harvestRows = await watchAllHarvests().first;
    final result = {for (var i = 1; i <= 12; i++) i: 0.0};
    for (final h in harvestRows) {
      if (h.date.year == year && (h.unit == 'lb' || h.unit == 'lbs')) {
        result[h.date.month] = (result[h.date.month] ?? 0) + h.quantity;
      }
    }
    return result;
  }
}
QueryExecutor _openConnection() {
  return driftDatabase(name: 'garden_tracker_db');
}

