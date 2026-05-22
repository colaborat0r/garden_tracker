// lib/core/database/tables.dart
import 'package:drift/drift.dart';

// ─────────────────────────────────────────────
//  GARDENS
// ─────────────────────────────────────────────
class Gardens extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get location => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─────────────────────────────────────────────
//  BEDS
// ─────────────────────────────────────────────
class Beds extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gardenId => integer().references(Gardens, #id)();
  TextColumn get name => text()();
  // raised | container | ground | hydro
  TextColumn get type => text().withDefault(const Constant('raised'))();
  RealColumn get areaSqFt => real().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get soilType => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─────────────────────────────────────────────
//  PLANTS
// ─────────────────────────────────────────────
class Plants extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bedId => integer().references(Beds, #id)();
  TextColumn get variety => text()();
  TextColumn get commonName => text()();
  DateTimeColumn get seedStartDate => dateTime().nullable()();
  DateTimeColumn get transplantDate => dateTime().nullable()();
  DateTimeColumn get expectedHarvestStart => dateTime().nullable()();
  // planted | growing | harvested | failed
  TextColumn get status =>
      text().withDefault(const Constant('planted'))();
  // seedling | vegetative | flowering | fruiting | harvest_ready
  TextColumn get growthStage => text().nullable()();
  IntColumn get quantity => integer().nullable()();
  // seed | transplant | nursery | cutting | gift
  TextColumn get source => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─────────────────────────────────────────────
//  PLANT PHOTOS  (gallery / photo timeline)
// ─────────────────────────────────────────────
class PlantPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plantId => integer().references(Plants, #id)();
  TextColumn get photoPath => text()();
  TextColumn get caption => text().nullable()();
  DateTimeColumn get takenAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─────────────────────────────────────────────
//  JOURNAL ENTRIES  (notes / lessons learned)
// ─────────────────────────────────────────────
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  // emoji mood: 🌱 😄 🌧️ 🤔 ✨
  TextColumn get mood => text().nullable()();
  TextColumn get tags => text().nullable()(); // comma-separated
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─────────────────────────────────────────────
//  OBSERVATIONS
// ─────────────────────────────────────────────
class Observations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plantId => integer().references(Plants, #id)();
  DateTimeColumn get date =>
      dateTime().withDefault(currentDateAndTime)();
  // water | fertilize | pest | prune | note
  TextColumn get type => text()();
  TextColumn get description => text()();
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get photoPath => text().nullable()();
}

// ─────────────────────────────────────────────
//  HARVESTS
// ─────────────────────────────────────────────
class Harvests extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plantId => integer().references(Plants, #id)();
  DateTimeColumn get date =>
      dateTime().withDefault(currentDateAndTime)();
  RealColumn get quantity => real()();
  TextColumn get unit => text().withDefault(const Constant('lb'))();
  IntColumn get qualityRating => integer().nullable()(); // 1–5
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()();
}

// ─────────────────────────────────────────────
//  EXPENSES
// ─────────────────────────────────────────────
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date =>
      dateTime().withDefault(currentDateAndTime)();
  // seeds | soil | tools | amendments | other
  TextColumn get category => text()();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  TextColumn get vendor => text().nullable()();
  TextColumn get notes => text().nullable()();
}

// ─────────────────────────────────────────────
//  REMINDERS
// ─────────────────────────────────────────────
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plantId => integer().nullable()();
  // water | fertilize | harvest | pest_check | custom
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get dueDate => dateTime()();
  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isRepeating =>
      boolean().withDefault(const Constant(false))();
  // daily | weekly | monthly
  TextColumn get repeatInterval => text().nullable()();
}

