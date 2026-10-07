import '../../../models/coin_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
  final HomeStatus status;
  final List<CoinModel> allCoins;
  final List<CoinModel> filteredCoins;
  final String searchQuery;
  final List<String> watchlistIds;
  final int currentPage;
  final bool hasMore;
  final bool isPaginatedLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.allCoins = const [],
    this.filteredCoins = const [],
    this.searchQuery = '',
    this.watchlistIds = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.isPaginatedLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<CoinModel>? allCoins,
    List<CoinModel>? filteredCoins,
    String? searchQuery,
    List<String>? watchlistIds,
    int? currentPage,
    bool? hasMore,
    bool? isPaginatedLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      allCoins: allCoins ?? this.allCoins,
      filteredCoins: filteredCoins ?? this.filteredCoins,
      searchQuery: searchQuery ?? this.searchQuery,
      watchlistIds: watchlistIds ?? this.watchlistIds,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isPaginatedLoading: isPaginatedLoading ?? this.isPaginatedLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
