import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/coin_model.dart';
import '../../../repo/crypto_repository.dart';
import '../../../services/watchlist_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final CryptoRepository repository;

  HomeCubit({required this.repository}) : super(const HomeState());

  Future<void> loadInitialData() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));
    try {
      final watchlistIds = await WatchlistService.instance.getWatchlistIds();
      final coins = await repository.fetchCoins(page: 1);

      final filtered = _applyFilter(coins, state.searchQuery);

      emit(state.copyWith(
        status: HomeStatus.success,
        allCoins: coins,
        filteredCoins: filtered,
        watchlistIds: watchlistIds,
        currentPage: 1,
        hasMore: coins.length >= 20,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> refreshData() async {
    emit(state.copyWith(isRefreshing: true));
    try {
      final watchlistIds = await WatchlistService.instance.getWatchlistIds();
      final coins = await repository.fetchCoins(page: 1);

      final filtered = _applyFilter(coins, state.searchQuery);

      emit(state.copyWith(
        status: HomeStatus.success,
        allCoins: coins,
        filteredCoins: filtered,
        watchlistIds: watchlistIds,
        currentPage: 1,
        hasMore: coins.length >= 20,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(state.copyWith(isRefreshing: false));
    }
  }

  Future<void> loadNextPage() async {
    if (state.isPaginatedLoading || !state.hasMore || state.status != HomeStatus.success) {
      return;
    }

    emit(state.copyWith(isPaginatedLoading: true));
    try {
      final nextPage = state.currentPage + 1;
      final newCoins = await repository.fetchCoins(page: nextPage);

      if (newCoins.isEmpty) {
        emit(state.copyWith(
          isPaginatedLoading: false,
          hasMore: false,
        ));
        return;
      }

      // Avoid duplicates by filtering out coins already present
      final existingIds = state.allCoins.map((c) => c.id).toSet();
      final uniqueNewCoins = newCoins.where((c) => !existingIds.contains(c.id)).toList();

      final updatedAllCoins = List<CoinModel>.from(state.allCoins)..addAll(uniqueNewCoins);
      final updatedFilteredCoins = _applyFilter(updatedAllCoins, state.searchQuery);

      emit(state.copyWith(
        allCoins: updatedAllCoins,
        filteredCoins: updatedFilteredCoins,
        currentPage: nextPage,
        hasMore: newCoins.length >= 20,
        isPaginatedLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isPaginatedLoading: false));
    }
  }

  void searchCoins(String query) {
    final filtered = _applyFilter(state.allCoins, query);
    emit(state.copyWith(
      searchQuery: query,
      filteredCoins: filtered,
    ));
  }

  Future<void> toggleWatchlist(String coinId) async {
    final updatedWatchlist = await WatchlistService.instance.toggleWatchlist(coinId);
    emit(state.copyWith(watchlistIds: updatedWatchlist));
  }

  Future<void> syncWatchlist() async {
    final watchlistIds = await WatchlistService.instance.getWatchlistIds();
    emit(state.copyWith(watchlistIds: watchlistIds));
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
