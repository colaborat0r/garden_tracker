// lib/core/services/export_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../database/app_database.dart';
import '../utils/formatters.dart';

class ExportService {
  // ── CSV Export ──────────────────────────────────────────────────────────────
  static Future<void> exportHarvestsCsv(
      List<Harvest> harvests, List<Plant> plants, List<Bed> beds) async {
    final plantMap = {for (final p in plants) p.id: p};
    final bedMap = {for (final b in beds) b.id: b};

    final rows = <List<dynamic>>[
      ['Date', 'Plant', 'Variety', 'Bed', 'Quantity', 'Unit', 'Quality (1-5)', 'Notes'],
      ...harvests.map((h) {
        final plant = plantMap[h.plantId];
        final bed = plant != null ? bedMap[plant.bedId] : null;
        return [
          h.date.toIso8601String().substring(0, 10),
          plant?.commonName ?? '',
          plant?.variety ?? '',
          bed?.name ?? '',
          h.quantity,
          h.unit,
          h.qualityRating ?? '',
          h.notes ?? '',
        ];
      }),
    ];
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/harvests_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csv);
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Garden Harvest Data',
      text: 'Harvest log export — ${formatDate(DateTime.now())}',
    );
  }

  static Future<void> exportExpensesCsv(List<Expense> expenses) async {
    final rows = <List<dynamic>>[
      ['Date', 'Category', 'Description', 'Amount', 'Vendor', 'Notes'],
      ...expenses.map((e) => [
            e.date.toIso8601String().substring(0, 10),
            e.category,
            e.description,
            e.amount.toStringAsFixed(2),
            e.vendor ?? '',
            e.notes ?? '',
          ]),
    ];
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/expenses_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csv);
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Garden Expenses',
      text: 'Expense log export — ${formatDate(DateTime.now())}',
    );
  }

  // ── JSON Export ─────────────────────────────────────────────────────────────
  static Future<void> exportJson(AppDatabase db) async {
    final beds = await db.watchAllBeds().first;
    final plants = await db.watchAllPlants().first;
    final harvests = await db.watchAllHarvests().first;
    final expenses = await db.watchAllExpenses().first;
    final reminders = await db.watchAllReminders().first;
    final photos = await db.watchAllPhotos().first;
    final journal = await db.watchAllJournalEntries().first;

    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'version': 2,
      'beds': beds
          .map((b) => {
                'id': b.id,
                'name': b.name,
                'type': b.type,
                'areaSqFt': b.areaSqFt,
                'location': b.location,
                'soilType': b.soilType,
                'notes': b.notes,
              })
          .toList(),
      'plants': plants
          .map((p) => {
                'id': p.id,
                'bedId': p.bedId,
                'commonName': p.commonName,
                'variety': p.variety,
                'status': p.status,
                'growthStage': p.growthStage,
                'quantity': p.quantity,
                'source': p.source,
                'seedStartDate': p.seedStartDate?.toIso8601String(),
                'transplantDate': p.transplantDate?.toIso8601String(),
                'expectedHarvestStart': p.expectedHarvestStart?.toIso8601String(),
                'notes': p.notes,
              })
          .toList(),
      'harvests': harvests
          .map((h) => {
                'id': h.id,
                'plantId': h.plantId,
                'date': h.date.toIso8601String(),
                'quantity': h.quantity,
                'unit': h.unit,
                'qualityRating': h.qualityRating,
                'notes': h.notes,
              })
          .toList(),
      'expenses': expenses
          .map((e) => {
                'id': e.id,
                'date': e.date.toIso8601String(),
                'category': e.category,
                'description': e.description,
                'amount': e.amount,
                'vendor': e.vendor,
                'notes': e.notes,
              })
          .toList(),
      'reminders': reminders
          .map((r) => {
                'id': r.id,
                'type': r.type,
                'title': r.title,
                'dueDate': r.dueDate.toIso8601String(),
                'isCompleted': r.isCompleted,
              })
          .toList(),
      'plantPhotos': photos
          .map((p) => {
                'id': p.id,
                'plantId': p.plantId,
                'photoPath': p.photoPath,
                'caption': p.caption,
                'takenAt': p.takenAt.toIso8601String(),
              })
          .toList(),
      'journalEntries': journal
          .map((j) => {
                'id': j.id,
                'title': j.title,
                'body': j.body,
                'mood': j.mood,
                'tags': j.tags,
                'createdAt': j.createdAt.toIso8601String(),
              })
          .toList(),
    };

    final json = const JsonEncoder.withIndent('  ').convert(data);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/garden_export_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(json);
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Garden Data Export (JSON)',
      text: 'Full garden data export — ${formatDate(DateTime.now())}',
    );
  }

  // ── JSON Import / Restore ────────────────────────────────────────────────────
  /// Pick a JSON backup file and restore its contents into [db].
  /// Returns a summary string on success, or throws on failure.
  static Future<String> importJson(AppDatabase db) async {
    // Pick file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) {
      throw Exception('No file selected.');
    }

    final path = result.files.single.path;
    if (path == null) throw Exception('Cannot read file path.');

    final raw = await File(path).readAsString();
    final Map<String, dynamic> data = jsonDecode(raw) as Map<String, dynamic>;

    // ── Beds ──────────────────────────────────────────────────────────────────
    final gardens = await db.getAllGardens();
    if (gardens.isEmpty) throw Exception('No garden found in database.');
    final gardenId = gardens.first.id;

    final bedIdMap = <int, int>{}; // old id → new id
    final rawBeds = (data['beds'] as List? ?? []);
    for (final b in rawBeds.cast<Map<String, dynamic>>()) {
      final newId = await db.insertBed(BedsCompanion.insert(
        gardenId: gardenId,
        name: b['name'] as String? ?? 'Restored Bed',
        type: Value(b['type'] as String? ?? 'raised'),
        areaSqFt: Value((b['areaSqFt'] as num?)?.toDouble()),
        location: Value(b['location'] as String?),
        soilType: Value(b['soilType'] as String?),
        notes: Value(b['notes'] as String?),
      ));
      if (b['id'] != null) bedIdMap[b['id'] as int] = newId;
    }

    // ── Plants ────────────────────────────────────────────────────────────────
    final plantIdMap = <int, int>{}; // old id → new id
    final rawPlants = (data['plants'] as List? ?? []);
    for (final p in rawPlants.cast<Map<String, dynamic>>()) {
      final oldBedId = p['bedId'] as int?;
      final newBedId = oldBedId != null ? bedIdMap[oldBedId] : null;
      if (newBedId == null) continue; // skip if bed wasn't restored
      final newId = await db.insertPlant(PlantsCompanion.insert(
        bedId: newBedId,
        commonName: p['commonName'] as String? ?? 'Unknown',
        variety: p['variety'] as String? ?? '',
        status: Value(p['status'] as String? ?? 'planted'),
        growthStage: Value(p['growthStage'] as String?),
        quantity: Value(p['quantity'] as int?),
        source: Value(p['source'] as String?),
        seedStartDate: Value(_parseDate(p['seedStartDate'])),
        transplantDate: Value(_parseDate(p['transplantDate'])),
        expectedHarvestStart: Value(_parseDate(p['expectedHarvestStart'])),
        notes: Value(p['notes'] as String?),
      ));
      if (p['id'] != null) plantIdMap[p['id'] as int] = newId;
    }

    // ── Harvests ──────────────────────────────────────────────────────────────
    int harvestCount = 0;
    for (final h in (data['harvests'] as List? ?? []).cast<Map<String, dynamic>>()) {
      final oldPlantId = h['plantId'] as int?;
      final newPlantId = oldPlantId != null ? plantIdMap[oldPlantId] : null;
      if (newPlantId == null) continue;
      await db.insertHarvest(HarvestsCompanion.insert(
        plantId: newPlantId,
        date: Value(_parseDate(h['date']) ?? DateTime.now()),
        quantity: (h['quantity'] as num).toDouble(),
        unit: Value(h['unit'] as String? ?? 'lb'),
        qualityRating: Value(h['qualityRating'] as int?),
        notes: Value(h['notes'] as String?),
      ));
      harvestCount++;
    }

    // ── Expenses ──────────────────────────────────────────────────────────────
    int expenseCount = 0;
    for (final e in (data['expenses'] as List? ?? []).cast<Map<String, dynamic>>()) {
      await db.insertExpense(ExpensesCompanion.insert(
        date: Value(_parseDate(e['date']) ?? DateTime.now()),
        category: e['category'] as String? ?? 'other',
        description: e['description'] as String? ?? '',
        amount: (e['amount'] as num).toDouble(),
        vendor: Value(e['vendor'] as String?),
        notes: Value(e['notes'] as String?),
      ));
      expenseCount++;
    }

    // ── Reminders ─────────────────────────────────────────────────────────────
    for (final r in (data['reminders'] as List? ?? []).cast<Map<String, dynamic>>()) {
      final dueDate = _parseDate(r['dueDate']);
      if (dueDate == null) continue;
      await db.insertReminder(RemindersCompanion.insert(
        type: r['type'] as String? ?? 'custom',
        title: r['title'] as String? ?? 'Reminder',
        dueDate: dueDate,
        notes: Value(r['notes'] as String?),
        isCompleted: Value(r['isCompleted'] as bool? ?? false),
      ));
    }

    // ── Journal Entries ───────────────────────────────────────────────────────
    int journalCount = 0;
    for (final j in (data['journalEntries'] as List? ?? []).cast<Map<String, dynamic>>()) {
      await db.insertJournalEntry(JournalEntriesCompanion.insert(
        title: j['title'] as String? ?? 'Restored Entry',
        body: Value(j['body'] as String?),
        mood: Value(j['mood'] as String?),
        tags: Value(j['tags'] as String?),
        createdAt: Value(_parseDate(j['createdAt']) ?? DateTime.now()),
      ));
      journalCount++;
    }

    return 'Restored ${rawBeds.length} beds, ${rawPlants.length} plants, '
        '$harvestCount harvests, $expenseCount expenses, $journalCount journal entries.';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value as String);
    } catch (_) {
      return null;
    }
  }

  // ── PDF Export ──────────────────────────────────────────────────────────────
  static Future<void> exportPdf(
      AppDatabase db, String gardenName) async {
    final harvests = await db.watchAllHarvests().first;
    final plants = await db.watchAllPlants().first;
    final beds = await db.watchAllBeds().first;
    final expenses = await db.watchAllExpenses().first;

    final plantMap = {for (final p in plants) p.id: p};
    final bedMap = {for (final b in beds) b.id: b};

    final totalHarvestLbs = harvests
        .where((h) => h.unit == 'lb' || h.unit == 'lbs')
        .fold(0.0, (s, h) => s + h.quantity);
    final totalExpenses = expenses.fold(0.0, (s, e) => s + e.amount);
    final costPerLb =
        totalHarvestLbs > 0 ? totalExpenses / totalHarvestLbs : 0.0;

    // Yield by crop
    final yieldByCrop = <String, double>{};
    for (final h in harvests.where((h) => h.unit == 'lb' || h.unit == 'lbs')) {
      final name = plantMap[h.plantId]?.commonName ?? 'Unknown';
      yieldByCrop[name] = (yieldByCrop[name] ?? 0) + h.quantity;
    }
    final sortedCrops = yieldByCrop.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final now = DateTime.now();
    final pdf = pw.Document(
      title: '$gardenName — Harvest Report',
      author: 'Garden Tracker',
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(32),
        header: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(gardenName,
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.Text('Generated ${formatDate(now)}',
                    style:
                        const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 8),
          ],
        ),
        build: (ctx) => [
          // Summary stats
          pw.Header(level: 1, text: 'Summary'),
          pw.TableHelper.fromTextArray(
            headers: ['Metric', 'Value'],
            data: [
              ['Total Harvest (lbs)', totalHarvestLbs.toStringAsFixed(2)],
              ['Total Expenses', '\$${totalExpenses.toStringAsFixed(2)}'],
              ['Cost per lb', '\$${costPerLb.toStringAsFixed(2)}'],
              ['Total Plants', plants.length.toString()],
              ['Total Beds', beds.length.toString()],
              [
                'Active Plants',
                plants
                    .where((p) =>
                        p.status == 'planted' || p.status == 'growing')
                    .length
                    .toString()
              ],
            ],
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.green700),
            cellHeight: 24,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
            },
          ),
          pw.SizedBox(height: 16),
          // Yield by crop
          if (sortedCrops.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Yield by Crop (lbs)'),
            pw.TableHelper.fromTextArray(
              headers: ['Crop', 'Total Harvested (lbs)'],
              data: sortedCrops
                  .map((e) => [e.key, e.value.toStringAsFixed(2)])
                  .toList(),
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.green700),
              cellHeight: 24,
            ),
            pw.SizedBox(height: 16),
          ],
          // Harvest log
          if (harvests.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Complete Harvest Log'),
            pw.TableHelper.fromTextArray(
              headers: [
                'Date',
                'Plant',
                'Variety',
                'Bed',
                'Qty',
                'Unit',
                'Quality'
              ],
              data: harvests.map((h) {
                final plant = plantMap[h.plantId];
                final bed = plant != null ? bedMap[plant.bedId] : null;
                return [
                  h.date.toIso8601String().substring(0, 10),
                  plant?.commonName ?? '—',
                  plant?.variety ?? '—',
                  bed?.name ?? '—',
                  h.quantity.toStringAsFixed(2),
                  h.unit,
                  '★' * (h.qualityRating ?? 0),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.green700),
              cellHeight: 20,
              cellStyle: const pw.TextStyle(fontSize: 9),
            ),
            pw.SizedBox(height: 16),
          ],
          // Expense summary
          if (expenses.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Expense Log'),
            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Category', 'Description', 'Amount', 'Vendor'],
              data: expenses.map((e) => [
                    e.date.toIso8601String().substring(0, 10),
                    e.category,
                    e.description,
                    '\$${e.amount.toStringAsFixed(2)}',
                    e.vendor ?? '—',
                  ]).toList(),
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.green700),
              cellHeight: 20,
              cellStyle: const pw.TextStyle(fontSize: 9),
            ),
          ],
          pw.SizedBox(height: 24),
          pw.Center(
            child: pw.Text(
              'Generated by Garden Tracker — ${formatDate(now)}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'garden_report_${now.year}_${now.month}_${now.day}.pdf',
    );
  }
}

