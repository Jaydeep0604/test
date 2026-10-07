import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repo/crypto_repository.dart';
import '../../../services/watchlist_service.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final CryptoRepository repository;

  WatchlistCubit({required this.repository}) : super(const WatchlistState());

  /// Load watchlisted coins from SharedPreferences and API
  Future<void> loadWatchlist() async {
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

      final coins = await repository.fetchWatchlistCoins(watchlistIds);
      final query = state.searchQuery.trim().toLowerCase();

      final filteredCoins = query.isEmpty
          ? coins
          : coins.where((coin) {
              return coin.name.toLowerCase().contains(query) ||
                  coin.symbol.toLowerCase().contains(query);
            }).toList();

      emit(state.copyWith(
        status: WatchlistStatus.success,
        watchlistCoins: coins,
        filteredCoins: filteredCoins,
        watchlistIds: watchlistIds,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WatchlistStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// Remove a coin from Watchlist
  Future<void> removeFromWatchlist(String coinId) async {
    final updatedIds = await WatchlistService.toggleWatchlist(coinId);
    final updatedCoins = state.watchlistCoins.where((coin) => coin.id != coinId).toList();

    final query = state.searchQuery.trim().toLowerCase();
    final filteredCoins = query.isEmpty
        ? updatedCoins
        : updatedCoins.where((coin) {
            return coin.name.toLowerCase().contains(query) ||
                coin.symbol.toLowerCase().contains(query);
          }).toList();

    emit(state.copyWith(
      watchlistIds: updatedIds,
      watchlistCoins: updatedCoins,
      filteredCoins: filteredCoins,
    ));
  }

  /// Search inside Watchlist
  void searchWatchlist(String query) {
    final q = query.trim().toLowerCase();
    final filteredCoins = q.isEmpty
        ? state.watchlistCoins
        : state.watchlistCoins.where((coin) {
            return coin.name.toLowerCase().contains(q) ||
                coin.symbol.toLowerCase().contains(q);
          }).toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredCoins: filteredCoins,
    ));
  }
}
