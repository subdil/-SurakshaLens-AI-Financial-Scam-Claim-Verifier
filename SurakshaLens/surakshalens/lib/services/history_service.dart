import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const _key = 'scan_history';

  static Future<void> add(Map<String, dynamic> result) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    final entry = {
      'date': DateTime.now().toIso8601String(),
      'result': result,
    };

    list.insert(0, jsonEncode(entry));

    if (list.length > 20) {
      list.removeRange(20, list.length);
    }

    await prefs.setStringList(_key, list);
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    return list.map((item) {
      return Map<String, dynamic>.from(jsonDecode(item));
    }).toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
