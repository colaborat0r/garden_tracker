// lib/core/utils/formatters.dart
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
final _dateFormat = DateFormat('MMM d, yyyy');
final _shortDateFormat = DateFormat('MMM d');
final _monthFormat = DateFormat('MMM yyyy');
final _currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
final _weightFormat = NumberFormat('#,##0.##');
String formatDate(DateTime? date) =>
    date == null ? '—' : _dateFormat.format(date);
String formatShortDate(DateTime? date) =>
    date == null ? '—' : _shortDateFormat.format(date);
String formatMonth(DateTime date) => _monthFormat.format(date);
String formatCurrency(double amount) => _currencyFormat.format(amount);
String formatWeight(double qty, String unit) =>
    '${_weightFormat.format(qty)} $unit';
String daysUntil(DateTime? date) {
  if (date == null) return '';
  final diff = date.difference(DateTime.now()).inDays;
  if (diff < 0) return 'Overdue';
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  return 'In $diff days';
}
Color statusColor(BuildContext context, String status) {
  final cs = Theme.of(context).colorScheme;
  switch (status) {
    case 'planted':
      return Colors.blue;
    case 'growing':
      return cs.primary;
    case 'harvested':
      return Colors.amber.shade700;
    case 'failed':
      return cs.error;
    default:
      return cs.outline;
  }
}
String obsTypeEmoji(String type) {
  switch (type) {
    case 'water':
      return '💧';
    case 'fertilize':
      return '🌱';
    case 'pest':
      return '🐛';
    case 'prune':
      return '✂️';
    default:
      return '📝';
  }
}
String obsTypeLabel(String type) {
  switch (type) {
    case 'water':
      return 'Watered';
    case 'fertilize':
      return 'Fertilized';
    case 'pest':
      return 'Pest Check';
    case 'prune':
      return 'Pruned';
    default:
      return 'Note';
  }
}
