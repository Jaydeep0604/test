import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/coin_model.dart';
import '../../../repo/crypto_repository.dart';
import '../../../services/watchlist_service.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final CryptoRepository repository;

  WatchlistCubit({required this.repository}) : super(const WatchlistState());

  Future<void> loadWatchlist(List<CoinModel> availableCoins) async {
    emit(state.copyWith(status: WatchlistStatus.loading));
    try {
      final watchlistIds = await WatchlistService.instance.getWatchlistIds();

      List<CoinModel> watchlistCoins = [];
      if (availableCoins.isNotEmpty) {
        watchlistCoins = availableCoins.where((coin) => watchlistIds.contains(coin.id)).toList();
      }

      // If availableCoins is empty or missing some watchlisted coins, fetch from API
      final missingIds = watchlistIds.where((id) => !watchlistCoins.any((c) => c.id == id)).toList();
      if (missingIds.isNotEmpty) {
        try {
          final fetchedCoins = await repository.fetchCoins(page: 1, perPage: 250);
          watchlistCoins = fetchedCoins.where((coin) => watchlistIds.contains(coin.id)).toList();
        } catch (_) {
          // If network fetch fails, use whatever we have in availableCoins
        }
      }

      final filtered = _applyFilter(watchlistCoins, state.searchQuery);

      emit(state.copyWith(
        status: WatchlistStatus.success,
        allWatchlistCoins: watchlistCoins,
        filteredWatchlistCoins: filtered,
        watchlistIds: watchlistIds,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WatchlistStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void searchWatchlist(String query) {
    final filtered = _applyFilter(state.allWatchlistCoins, query);
    emit(state.copyWith(
      searchQuery: query,
      filteredWatchlistCoins: filtered,
    ));
  }

  Future<void> removeFromWatchlist(String coinId) async {
    final updatedIds = await WatchlistService.instance.toggleWatchlist(coinId);
    final updatedWatchlistCoins = state.allWatchlistCoins.where((coin) => updatedIds.contains(coin.id)).toList();
    final filtered = _applyFilter(updatedWatchlistCoins, state.searchQuery);

    emit(state.copyWith(
      watchlistIds: updatedIds,
      allWatchlistCoins: updatedWatchlistCoins,
      filteredWatchlistCoins: filtered,
    ));
  }

  List<CoinModel> _applyFilter(List<CoinModel> coins, String query) {
    if (query.trim().isEmpty) {
      return coins;
    }
    final q = query.trim().toLowerCase();
    return coins.where((coin) {
      return coin.name.toLowerCase().contains(q) || coin.symbol.toLowerCase().contains(q);
    }).toList();
  }
}
