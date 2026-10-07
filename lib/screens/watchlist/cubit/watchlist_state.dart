import '../../../models/coin_model.dart';

enum WatchlistStatus { initial, loading, success, failure }

class WatchlistState {
  final WatchlistStatus status;
  final List<CoinModel> allWatchlistCoins;
  final List<CoinModel> filteredWatchlistCoins;
  final String searchQuery;
  final Set<String> watchlistIds;
  final String? errorMessage;

  const WatchlistState({
    this.status = WatchlistStatus.initial,
    this.allWatchlistCoins = const [],
    this.filteredWatchlistCoins = const [],
    this.searchQuery = '',
    this.watchlistIds = const {},
    this.errorMessage,
  });

  WatchlistState copyWith({
    WatchlistStatus? status,
    List<CoinModel>? allWatchlistCoins,
    List<CoinModel>? filteredWatchlistCoins,
    String? searchQuery,
    Set<String>? watchlistIds,
    String? errorMessage,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      allWatchlistCoins: allWatchlistCoins ?? this.allWatchlistCoins,
      filteredWatchlistCoins: filteredWatchlistCoins ?? this.filteredWatchlistCoins,
      searchQuery: searchQuery ?? this.searchQuery,
      watchlistIds: watchlistIds ?? this.watchlistIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
