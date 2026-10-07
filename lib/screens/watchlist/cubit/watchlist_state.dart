import '../../../models/coin_model.dart';

enum WatchlistStatus { initial, loading, success, failure }

class WatchlistState {
  final WatchlistStatus status;
  final List<CoinModel> watchlistCoins;
  final List<CoinModel> filteredCoins;
  final String searchQuery;
  final List<String> watchlistIds;
  final String? errorMessage;

  const WatchlistState({
    this.status = WatchlistStatus.initial,
    this.watchlistCoins = const [],
    this.filteredCoins = const [],
    this.searchQuery = '',
    this.watchlistIds = const [],
    this.errorMessage,
  });

  WatchlistState copyWith({
    WatchlistStatus? status,
    List<CoinModel>? watchlistCoins,
    List<CoinModel>? filteredCoins,
    String? searchQuery,
    List<String>? watchlistIds,
    String? errorMessage,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      watchlistCoins: watchlistCoins ?? this.watchlistCoins,
      filteredCoins: filteredCoins ?? this.filteredCoins,
      searchQuery: searchQuery ?? this.searchQuery,
      watchlistIds: watchlistIds ?? this.watchlistIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
