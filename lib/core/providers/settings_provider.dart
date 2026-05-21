// lib/core/providers/settings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kGardenNameKey = 'garden_name';
const _kDefaultGardenName = 'My Garden';

class GardenNameNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kGardenNameKey) ?? _kDefaultGardenName;
  }

  Future<void> setName(String name) async {
    final trimmed = name.trim().isEmpty ? _kDefaultGardenName : name.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kGardenNameKey, trimmed);
    state = AsyncValue.data(trimmed);
  }
}

final gardenNameProvider =
    AsyncNotifierProvider<GardenNameNotifier, String>(GardenNameNotifier.new);

