import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/coin_model.dart';
import '../../../repo/crypto_repository.dart';
import '../../../services/watchlist_service.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final CryptoRepository repository;

  WatchlistCubit({required this.repository}) : super(const WatchlistState());

  /// Load watchlisted coins based on saved IDs in SharedPreferences
  Future<void> loadWatchlist({List<CoinModel>? cachedCoins}) async {
    emit(state.copyWith(status: WatchlistStatus.loading));
    try {
      final watchlistIds = await WatchlistService.getWatchlistIds();

      if (watchlistIds.isEmpty) {
        emit(state.copyWith(
          status: WatchlistStatus.success,
          watchlistCoins: [],
          filteredCoins: [],
          watchlistIds: [],
        ));
        return;
      }

      List<CoinModel> coins = [];

      // Check if cachedCoins has all watchlisted coins
      if (cachedCoins != null && cachedCoins.isNotEmpty) {
        coins = cachedCoins.where((c) => watchlistIds.contains(c.id)).toList();
      }

      // If cachedCoins doesn't have all watchlisted coins, fetch from API
      if (coins.length < watchlistIds.length) {
        final fetchedCoins = await repository.fetchWatchlistCoins(watchlistIds);
        if (fetchedCoins.isNotEmpty) {
          coins = fetchedCoins;
        }
      }

      final filtered = _applyFilter(coins, state.searchQuery);

      emit(state.copyWith(
        status: WatchlistStatus.success,
        watchlistCoins: coins,
        filteredCoins: filtered,
        watchlistIds: watchlistIds,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WatchlistStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// Remove a coin from Watchlist in SharedPreferences and update state
  Future<void> removeFromWatchlist(String coinId) async {
    final updatedIds = await WatchlistService.toggleWatchlist(coinId);
    final updatedCoins = state.watchlistCoins.where((c) => updatedIds.contains(c.id)).toList();
    final filtered = _applyFilter(updatedCoins, state.searchQuery);

    emit(state.copyWith(
      watchlistIds: updatedIds,
      watchlistCoins: updatedCoins,
      filteredCoins: filtered,
    ));
  }

  /// Search inside Watchlist
  void searchWatchlist(String query) {
    final filtered = _applyFilter(state.watchlistCoins, query);
    emit(state.copyWith(
      searchQuery: query,
      filteredCoins: filtered,
    ));
  }

  List<CoinModel> _applyFilter(List<CoinModel> coins, String query) {
    if (query.trim().isEmpty) return coins;
    final q = query.trim().toLowerCase();
    return coins.where((coin) {
      return coin.name.toLowerCase().contains(q) || coin.symbol.toLowerCase().contains(q);
    }).toList();
  }
}
