import 'package:shared_preferences/shared_preferences.dart';

class WatchlistService {
  static const String _key = 'watchlist_coin_ids';

  /// Fetch all saved watchlist coin IDs from SharedPreferences
  static Future<List<String>> getWatchlistIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Toggle coin ID in SharedPreferences (add if not present, remove if present)
  static Future<List<String>> toggleWatchlist(String coinId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_key) ?? [];

    if (list.contains(coinId)) {
      list.remove(coinId);
    } else {
      list.add(coinId);
    }

    await prefs.setStringList(_key, list);
    return list;
  }

  /// Check if a coin ID is saved in SharedPreferences
  static Future<bool> isWatchlisted(String coinId) async {
    final ids = await getWatchlistIds();
    return ids.contains(coinId);
  }
}
