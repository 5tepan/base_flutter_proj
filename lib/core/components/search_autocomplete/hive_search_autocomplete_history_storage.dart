import 'dart:convert';

import 'package:base_flutter_proj/core/components/search_autocomplete/search_autocomplete_history_storage.dart';
import 'package:base_flutter_proj/core/storage/hive_bootstrap.dart';
import 'package:hive/hive.dart';

/// Persistent-история поиска на Hive.
class HiveSearchAutocompleteHistoryStorage
    extends SearchAutocompleteHistoryStorage {
  HiveSearchAutocompleteHistoryStorage({
    this.boxName = 'search_autocomplete_history',
  });

  final String boxName;
  Box? _box;

  Future<Box> _openBox() async {
    final box = _box;
    if (box != null && box.isOpen) {
      return box;
    }

    await HiveBootstrap.ensureInitialized();
    final openedBox = await Hive.openBox(boxName);
    _box = openedBox;
    return openedBox;
  }

  @override
  Future<List<String>> read(String storageKey) async {
    final box = await _openBox();
    return _decode(box.get(storageKey));
  }

  @override
  Future<void> write(String storageKey, List<String> items) async {
    final box = await _openBox();
    await box.put(storageKey, jsonEncode(items));
  }

  @override
  Future<void> clear(String storageKey) async {
    final box = await _openBox();
    await box.delete(storageKey);
  }

  static List<String> _decode(dynamic raw) {
    if (raw == null) {
      return [];
    }
    if (raw is List) {
      return raw.cast<String>();
    }
    if (raw is String) {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.cast<String>();
      }
    }
    return [];
  }
}
