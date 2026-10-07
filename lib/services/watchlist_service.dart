import 'package:shared_preferences/shared_preferences.dart';

class WatchlistService {
  static const String _keyWatchlist = 'watchlist_coin_ids';

  static WatchlistService? _instance;
  static WatchlistService get instance {
    _instance ??= WatchlistService._();
    return _instance!;
  }

  WatchlistService._();

  Future<Set<String>> getWatchlistIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? list = prefs.getStringList(_keyWatchlist);
    return list != null ? list.toSet() : <String>{};
  }

  Future<Set<String>> toggleWatchlist(String coinId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentSet = await getWatchlistIds();
    if (currentSet.contains(coinId)) {
      currentSet.remove(coinId);
    } else {
      currentSet.add(coinId);
    }
    await prefs.setStringList(_keyWatchlist, currentSet.toList());
    return currentSet;
  }

  Future<bool> isWatchlisted(String coinId) async {
    final ids = await getWatchlistIds();
    return ids.contains(coinId);
  }
}
