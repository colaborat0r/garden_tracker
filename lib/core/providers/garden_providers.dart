// lib/core/providers/garden_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'database_provider.dart';
// ── Beds ──
final allBedsProvider = StreamProvider<List<Bed>>((ref) {
  return ref.watch(databaseProvider).watchAllBeds();
});
final bedsByGardenProvider =
    StreamProvider.family<List<Bed>, int>((ref, gardenId) {
  return ref.watch(databaseProvider).watchBedsByGarden(gardenId);
});
final bedProvider = FutureProvider.family<Bed?, int>((ref, id) {
  return ref.watch(databaseProvider).getBed(id);
});
// ── Plants ──
final allPlantsProvider = StreamProvider<List<Plant>>((ref) {
  return ref.watch(databaseProvider).watchAllPlants();
});
final activePlantsProvider = StreamProvider<List<Plant>>((ref) {
  return ref.watch(databaseProvider).watchActivePlants();
});
final plantsByBedProvider =
    StreamProvider.family<List<Plant>, int>((ref, bedId) {
  return ref.watch(databaseProvider).watchPlantsByBed(bedId);
});
final plantProvider = FutureProvider.family<Plant?, int>((ref, id) async {
  return ref.watch(databaseProvider).getPlant(id);
});
final readyThisWeekProvider = StreamProvider<List<Plant>>((ref) {
  return ref.watch(databaseProvider).watchReadyThisWeek();
});
// ── Observations ──
final observationsByPlantProvider =
    StreamProvider.family<List<Observation>, int>((ref, plantId) {
  return ref.watch(databaseProvider).watchObservationsByPlant(plantId);
});
final recentObservationsProvider = StreamProvider<List<Observation>>((ref) {
  return ref.watch(databaseProvider).watchRecentObservations();
});
// ── Harvests ──
final allHarvestsProvider = StreamProvider<List<Harvest>>((ref) {
  return ref.watch(databaseProvider).watchAllHarvests();
});
final harvestsByPlantProvider =
    StreamProvider.family<List<Harvest>, int>((ref, plantId) {
  return ref.watch(databaseProvider).watchHarvestsByPlant(plantId);
});
final recentHarvestsProvider = StreamProvider<List<Harvest>>((ref) {
  return ref.watch(databaseProvider).watchRecentHarvests();
});
// ── Expenses ──
final allExpensesProvider = StreamProvider<List<Expense>>((ref) {
  return ref.watch(databaseProvider).watchAllExpenses();
});
// ── Reminders ──
final activeRemindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(databaseProvider).watchActiveReminders();
});
final allRemindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(databaseProvider).watchAllReminders();
});
// ── Plant Photos ──
final photosByPlantProvider =
    StreamProvider.family<List<PlantPhoto>, int>((ref, plantId) {
  return ref.watch(databaseProvider).watchPhotosByPlant(plantId);
});
final allPhotosProvider = StreamProvider<List<PlantPhoto>>((ref) {
  return ref.watch(databaseProvider).watchAllPhotos();
});
// ── Journal Entries ──
final allJournalEntriesProvider = StreamProvider<List<JournalEntry>>((ref) {
  return ref.watch(databaseProvider).watchAllJournalEntries();
});
// ── Analytics ──
final harvestTotalThisYearProvider = FutureProvider<double>((ref) async {
  ref.watch(allHarvestsProvider);
  return ref.read(databaseProvider).getTotalHarvestThisYear();
});
final expenseTotalThisYearProvider = FutureProvider<double>((ref) async {
  ref.watch(allExpensesProvider);
  return ref.read(databaseProvider).getTotalExpensesThisYear();
});
final activePlantsCountProvider = FutureProvider<int>((ref) async {
  ref.watch(allPlantsProvider);
  return ref.read(databaseProvider).getActivePlantsCount();
});
final yieldByCropProvider = FutureProvider<Map<String, double>>((ref) async {
  ref.watch(allHarvestsProvider);
  ref.watch(allPlantsProvider);
  return ref.read(databaseProvider).getYieldByCrop();
});
final yieldByBedProvider = FutureProvider<Map<String, double>>((ref) async {
  ref.watch(allHarvestsProvider);
  ref.watch(allPlantsProvider);
  ref.watch(allBedsProvider);
  return ref.read(databaseProvider).getYieldByBed();
});
final successRateByVarietyProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(allPlantsProvider);
  return ref.read(databaseProvider).getSuccessRateByVariety();
});
final yearlyHarvestDataProvider =
    FutureProvider.family<Map<int, double>, int>((ref, year) async {
  ref.watch(allHarvestsProvider);
  return ref.read(databaseProvider).getYearlyHarvestData(year);
});
