// lib/core/database/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';
part 'app_database.g.dart';
@DriftDatabase(
  tables: [Gardens, Beds, Plants, Observations, Harvests, Expenses, Reminders],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement('PRAGMA foreign_keys = ON');
          await into(gardens)
              .insert(GardensCompanion.insert(name: 'My Garden'));
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
}
QueryExecutor _openConnection() {
  return driftDatabase(name: 'garden_tracker_db');
}

